//
//  Multidimensional_Integration_TaskGroupTests.swift
//  Multidimensional Integration TaskGroupTests
//
//  Created by Jeff_Terry on 1/16/24.
//

import XCTest

final class Multidimensional_Integration_TaskGroupTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringParsing() throws {
        
        let integrationLimitsText = "0.0, 1.0\n2.0, 3.0\n4.0, 5.0\n6.0, 7.0\n"
        
        let returnLimits = parseString(stringWithParameters: integrationLimitsText, separator: ", ")
        
        XCTAssertEqual(returnLimits.0[3], 6.0, accuracy: 1E-7, "Print does not match")
        XCTAssertEqual(returnLimits.1[1], 3.0, accuracy: 1E-7, "Print does not match")
        
        
        
    }
    
    func testVolume() throws {
        
        let myVolumeBox = BoundingBox()
        
        let dimensions = 5
        
        let lowerBound = [0.0, -2.0, 3.0, 4.0, 1.0]
        let upperBound = lowerBound.map{($0 + 2.0)}
        
        myVolumeBox.initWithDimensionsAndRanges(dimensions: dimensions, lowerBound: lowerBound, upperBound: upperBound)
        
        XCTAssertEqual(myVolumeBox.volume, pow(2.0, Double(dimensions)), accuracy: 1E-7, "Print does not match" )
        
        
    }
    
    func testIntegrationOfEToTheMinusX() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var testValue = 3.14159
        
        let myMonte = MonteCarloIntegral()
        
        
        
        myMonte.selectedFunction = "exp(-x)"
        myMonte.selectFunctionToIntegrate() 
        
        myMonte.numberOfGuesses = "32000"
        myMonte.numberOfIterations = "16"
        
        await myMonte.startTheIntegration()
        
                
        
            
            testValue = myMonte.integral
        
        
        XCTAssertEqual(testValue, myMonte.exact, accuracy: 1.5e-3, "Print it should have been closer.")
        
        
    
    }
    
    func testIntegrationOfEToTheX() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var testValue = 3.14159
        
        let myMonte = MonteCarloIntegral()
        
        
        
        myMonte.selectedFunction = "exp(x)"
        myMonte.selectFunctionToIntegrate()
        
        myMonte.numberOfGuesses = "32000"
        myMonte.numberOfIterations = "16"
        
        await myMonte.startTheIntegration()
        
                
        
            
            testValue = myMonte.integral
        
        
        XCTAssertEqual(testValue, myMonte.exact, accuracy: 1.5e-3, "Print it should have been closer.")
        
        
    
    }
    
    func testIntegrationOf10DIntegral() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var testValue = 3.14159
        
        let myMonte = MonteCarloIntegral()
        
        
        
        myMonte.selectedFunction = "10DIntegral"
        myMonte.selectFunctionToIntegrate()
        
        myMonte.numberOfGuesses = "32000"
        myMonte.numberOfIterations = "300"
        
        await myMonte.startTheIntegration()
        
                
        
            
            testValue = myMonte.integral
        
        
        XCTAssertEqual(testValue, myMonte.exact, accuracy: 1.5e-2, "Print it should have been closer.")
        
        
    
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
