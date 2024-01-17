//
//  ContentView.swift
//  Multidimensional Integration Task
//
//  Created by Jeff_Terry on 1/16/24.
//

import SwiftUI

struct ContentView: View {

    // Variables
    
    @Bindable var monteCarloIntegralCalculator = MonteCarloIntegral()

    
    var body: some View {
        VStack {
            // Button to start calculation
            Button("Integrate") {
                
                startTheIntegration()
            }
            .padding()
            .disabled(monteCarloIntegralCalculator.calculating == true)
            VStack{
                
                Text("Limits of Integration:")
                // Textfield for limits of integration
                TextEditor(text: $monteCarloIntegralCalculator.limitsOfIntegrationText).frame(width:80, height:130).padding()
            }
            
            // Progress indicator
            if monteCarloIntegralCalculator.calculating {
                ProgressView()
                ProgressView("Calculaton:", value: monteCarloIntegralCalculator.currentIteration, total: monteCarloIntegralCalculator.iterations)
            } else {
                Text("Idle")
            }
            
            
            // Picker for selecting function
            Picker("Select Function", selection: $monteCarloIntegralCalculator.selectedFunction) {
                ForEach(monteCarloIntegralCalculator.functionOptions, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: monteCarloIntegralCalculator.selectedFunction, {functionSelector()})
            .pickerStyle(MenuPickerStyle())
            .padding().pickerStyle(MenuPickerStyle())
            .padding()
            
            HStack{
                
            Text("Number of Guesses:")
            // Textfield for number of guesses
                TextField("Number of Guesses", text: $monteCarloIntegralCalculator.numberOfGuesses)
                .padding()
            
        }
            
            HStack{
                
            Text("Number of Interations:")
                
            // Textfield for number of iterations
                TextField("Number of Iterations", text: $monteCarloIntegralCalculator.numberOfIterations)
                .padding()
        }
            

            HStack{
                
            Text("Integral Value:")
            // Textfield for integral value
                TextField("Integral Value", text: $monteCarloIntegralCalculator.integralValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Standard Deviation:")
            // Textfield for std dev value
                TextField("Standard Deviation", text: $monteCarloIntegralCalculator.stdDevValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Exact Value:")
            // Textfield for exact value
                TextField("Exact Value", text: $monteCarloIntegralCalculator.exactValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Error:")
            // Textfield for error value
                TextField("Error", text: $monteCarloIntegralCalculator.errorValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Time:")
            // Textfield for time value
                TextField("Time", text: $monteCarloIntegralCalculator.timeValue)
                .padding()
            
        }

            
        }
        .padding()
    }
    
    // Functions
    
    
    /// startTheIntegration
    /// - Parameter sender: normally integration button in the GUI
    /// starts the multidimensional integration
    func startTheIntegration()  {
        
        Task{
            await monteCarloIntegralCalculator.startTheIntegration()
            
        }
        
        
    }

    
    func functionSelector() {
        
        monteCarloIntegralCalculator.selectFunctionToIntegrate()
        
        
        
    }
}


#Preview {
    ContentView()
}

