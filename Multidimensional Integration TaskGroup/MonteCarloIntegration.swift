//
//  MonteCarloIntegration.swift
//  Integration Threaded
//
//  Created by Jeff Terry on 3/30/20.
//  Copyright © 2020 Jeff Terry. All rights reserved.
//

import Foundation

typealias integrationFunctionHandler = (_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double


@Observable class MonteCarloIntegral {
    
    
    var functionForIntegration: integrationFunctionHandler? = nil
    var limitsOfIntegrationText: String = "0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n"
    var integralValue: String = ""
    var numberOfGuesses: String = "32000"
    var numberOfIterations: String = "2048"
    var progress: Double = 0.0
    var exactValue: String = ""
    var stdDevValue: String = ""
    var errorValue: String = ""
    var timeValue: String = ""
    var selectedFunction: String = "exp(-x)"
    var functionOptions = ["exp(-x)", "exp(x)", "10DIntegral"]
    var dimensions = 1.0
    //integral e^-x from 0 to 1
    var exact = -exp(-1.0)+exp(0.0)
    var limitsOfIntegration = ([0.0], [1.0])
    var integral = 0.0
    var iterations = 0.0
    var currentIteration = 0.0
    var totalGuesses = 0.0
    var guesses = 0.0
    var error = 0.0
    var stdDev = 0.0
    var progressPercentage = 0.0
    
    var start = DispatchTime.now() //Start time
    var stop = DispatchTime.now()  //Stop time
    
    var nanotime :UInt64 = 0
    var timeInterval : Double = 0.0
    
    var calculating = false
    
    
    init(){
        
        functionForIntegration = eToTheX
    }
    
    /// calculateMonteCarloIntegral
    /// - Parameters:
    ///   - dimensions: number of dimensions
    ///   - guesses: number of guesses in each iteration
    ///   - lowerLimit: lower bound of the integration, needs one value per each dimension
    ///   - upperLimit: upper bound of the integration, needs one value per each dimension
    ///   - functionToBeIntegrated: passed in function to be integrated over the range lowerLimit to UpperLimit. Must be of type integrationFunctionHandler
    func calculateMonteCarloIntegral(dimensions: Int, guesses: Int32, lowerLimit: [Double], upperLimit: [Double], functionToBeIntegrated: integrationFunctionHandler) -> Double{
        
        var currentIntegral = 0.0
        var parameters :[Double] = []
        
        for _ in 0 ..< guesses{
            
            for j in 0 ..< dimensions{
                
                parameters.append(Double.random(in: (lowerLimit[j] ... upperLimit[j])))
                
            }
            
            currentIntegral += functionToBeIntegrated(dimensions, parameters)
            parameters.removeAll()
            
        }
        
        
        return(currentIntegral)
        
    }
    
    /// eToTheMinusX
    /// - Parameters:
    ///   - numberOfDimensions: number of dimensions to match type integrationFunctionHandler
    ///   - arrayOfInputs: input for each dimension to be calculated in this case only 1st is used. Must be an array to match type integrationFunctionHandler
    /// returns the value of exp(-x)
    func eToTheMinusX(_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double {
        
        if numberOfDimensions == 1 {
            
            return (exp(-arrayOfInputs[0]))
            
            
            
        }
        
        else {
            
            print("The dimensions do not match for 1D exp(-x).")
            
            
        }
        
        return (0.0)
        
        
    }
    
    /// eToTheX
    /// - Parameters:
    ///   - numberOfDimensions: number of dimensions to match type integrationFunctionHandler
    ///   - arrayOfInputs: input for each dimension to be calculated in this case only 1st is used. Must be an array to match type integrationFunctionHandler
    /// returns the value of exp(x)
    func eToTheX(_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double {
        
        if numberOfDimensions == 1 {
            
            return (exp(arrayOfInputs[0]))
            
            
            
        }
        
        else {
            
            print("The dimensions do not match for 1D exp(-x).")
            
            
        }
        
        return (0.0)
        
        
    }
    
    /// tenDIntegral
    /// - Parameters:
    ///   - numberOfDimensions: number of dimensions to match type integrationFunctionHandler
    ///   - arrayOfInputs: input for each dimension to be calculated. Must be an array to match type integrationFunctionHandler
    ///                                        2
    ///  return    (x  + x  + x  + x  + x  + x  + x  + x  + x  + x  )
    ///         0     1     2     3     4      5     6     7     8     9
    func tenDIntegral(_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double {
        
        
        if numberOfDimensions == 10 {
            //(x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9)^2
            
            let total = arrayOfInputs.reduce(0, +)
            
            return(pow(total, 2.0))
            
        }
        else {
            
            print("The dimensions of the 10D Integration were not equal to 10.")
            
        }
        
        return (0.0)
        
    }
    
    func selectFunctionToIntegrate(){
        
        
        switch selectedFunction {
            
        case "exp(x)":
            dimensions = 1
            exact = exp(1.0) - exp(0.0)
            functionForIntegration = eToTheX
            
        case "10DIntegral":
            dimensions = 10
            exact = 155.0/6.0
            functionForIntegration = tenDIntegral
            
        case "exp(-x)":
            dimensions = 1
            exact = -exp(-1.0) + exp(0.0)
            functionForIntegration = eToTheMinusX
            
        default:
            
            dimensions = 1
            exact = -exp(-1.0) + exp(0.0)
            functionForIntegration = eToTheMinusX
            
            
            
        }
    }
    
    @MainActor func blackTheDisplayAtTheStartOfTheCalculation() {
        //Blank the Display
        integralValue = ""
        exactValue = ""
        errorValue = ""
        stdDevValue = ""
        timeValue = ""
    }
    
    func startTheIntegration() async {
            
        await blackTheDisplayAtTheStartOfTheCalculation()
            
            //get limits of Integration
            let integrationLimitString = limitsOfIntegrationText
            limitsOfIntegration = parseString(stringWithParameters: integrationLimitString, separator: ", ")
            
            //test to make sure the number of Dimensions matches the number of Integration Limits
            //matches equals or exceeds.
            
            var safeToCalculate = false
            let numberOfLowerLimits = limitsOfIntegration.0.count
            let numberOfUpperLimits = limitsOfIntegration.1.count
            
            if(numberOfLowerLimits >= Int(dimensions)){
                
                safeToCalculate = true
            }
            
            if ((numberOfUpperLimits >= Int(dimensions) && safeToCalculate)){
                
                safeToCalculate = true
                
                
            }
            else{
                
                safeToCalculate = false
            }
            
            if !safeToCalculate {
                
                
                print("There was an error in the limits of integration.")
                return
            }
            
            
            
            let theIterations = Int(numberOfIterations)
            iterations = Double(theIterations!)
            
            let myGuesses = Int(numberOfGuesses)
            //print (myGuesses)
            
            start = DispatchTime.now() // starting time of the integration
            //progressIndicator.startAnimation(self)
            self.calculating = true
            
            //integrateButton.isEnabled = false
            
            let myQueue = DispatchQueue.init(label: "integrationQueue", qos: .userInitiated, attributes: .concurrent)
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                
                self.integration(iterations: Int32(theIterations!), guesses: Int32(myGuesses!), lowerLimit:self.limitsOfIntegration.0, upperLimit:self.limitsOfIntegration.1, theQueue: myQueue)
                
            }
            
            print("done")
            
        
    }
    
    
    /// integration
    /// does the heavily lifting and performs the threaded Monte Carlo Integration
    /// - Parameters:
    ///   - iterations: number of iterations
    ///   - guesses: number of guesses
    ///   - lowerLimit: array of the lower limits of integration should be >= number of dimensions
    ///   - upperLimit: array of the upper limits of integration should be >= number of dimensions
    ///   - theQueue: DispatchQueue in which we will perform the threaded integration. This can be concurrent or synchrous as needed. Testing usally synchronously. Calculations done concurrently.
    func integration(iterations: Int32, guesses: Int32, lowerLimit:[Double], upperLimit:[Double], theQueue: DispatchQueue)  {
        
        var integralArray :[Double] = []
        
        theQueue.async{ [self] in
            
            DispatchQueue.concurrentPerform(iterations: Int(iterations), execute: { index in
                
                //print("started index \(index)")
                
                DispatchQueue.main.async{
                    
                    self.currentIteration = Double(index)
                }
                
                
                integralArray.append(calculateMonteCarloIntegral(dimensions: Int(self.dimensions), guesses: guesses, lowerLimit: lowerLimit, upperLimit: upperLimit, functionToBeIntegrated: self.functionForIntegration!))
                
                
            })
            
        //Calculate the Volume of the Multidimensional Box
            
        let myVolume = BoundingBox()
        
        myVolume.initWithDimensionsAndRanges(dimensions: Int(self.dimensions), lowerBound: lowerLimit, upperBound: upperLimit)
        
        
        let volume = myVolume.volume
        
        let integralValue = integralArray.map{$0 * (volume / Double(guesses))}
        
        //print(integralValue)
        
        let myIntegral = integralValue.mean
            let myStdDev = integralValue.stdev
        
        print("integral is \(myIntegral) exact is \(self.exact)")
            
            
        self.integral = myIntegral
        self.stdDev = myStdDev ?? 0.0
            self.error = exact - myIntegral
        
        DispatchQueue.main.async{
            
            self.integralValue = myIntegral.formatted(.number.precision(.fractionLength(7)))
            
            self.exactValue = self.exact.formatted(.number.precision(.fractionLength(7)))
            self.stdDevValue = self.stdDev.formatted(.number.precision(.fractionLength(7)))
            
            self.errorValue = self.error.formatted(.number.precision(.fractionLength(7)))
            
        self.stop = DispatchTime.now()    //end time
            
            self.calculating = false
            
           // self.progressIndicator.stopAnimation(self)
           // self.integrateButton.isEnabled = true
            
            self.nanotime = self.stop.uptimeNanoseconds - self.start.uptimeNanoseconds //difference in nanoseconds from the start of the calculation until the end.
            
            self.timeInterval = Double(self.nanotime) / 1_000_000_000
            self.timeValue = self.timeInterval.formatted(.number.precision(.fractionLength(7)))
            
            
        
            
            
        }
            
        
        
        
        }
         
        
    }
    
}
