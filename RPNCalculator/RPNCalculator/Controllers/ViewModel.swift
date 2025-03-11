//
//  Model.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 10/03/25.
//

class CalculatorModel {
    
    private var currentInput: String = "0"
    
    func inputSource(value: String) -> String {
        
        switch value {
            
        case "⌫":
            currentInput = "0"
            
            
        case "+","-","÷","×":
            if let first = currentInput.first, first == "0" {
                currentInput.removeFirst()
            }
            if let last = currentInput.last,
                ["+","-","÷","×"].contains(last) {
                currentInput.removeLast()
            }
            currentInput += value
            
            
            
        case ",":
            if let first = currentInput.first, first == "0", first == "," {
                currentInput.removeFirst()
            }
            if let last = currentInput.last, last == ",", last == "," {
                currentInput.removeLast()
            }
            currentInput += value
    
            
            
        case "=": print("=")
        case "±": print("±")
            
            
        default:
            if let first = currentInput.first, first == "0" {
                currentInput.removeFirst()
            }
            currentInput += value
            print("nil")
        }

        
        
        
        
        return currentInput
        
    }
}

