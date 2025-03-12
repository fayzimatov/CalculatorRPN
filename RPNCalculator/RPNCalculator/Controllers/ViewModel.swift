//
//  Model.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 10/03/25.
//

import Foundation
class CalculatorModel {
    
    private var currentInput: String = "0"
    
    func inputSource(value: String) -> String {
        
        switch value {
            
        case "⌫":
            if !currentInput.isEmpty {
                currentInput.removeLast()
                if currentInput.isEmpty {
                    currentInput = "0"
                }
            }
            
            
        case "+", "-", "÷", "×":
            if currentInput.isEmpty {
                currentInput = "0"
            }
            if let last = currentInput.last, ["+", "-", "÷", "×", ","].contains(String(last)) {
                currentInput.removeLast()
                currentInput += value
            } else if let last = currentInput.last, value != "-"  {
                
            } else if let last = currentInput.last, last == "(", value == "-" {
                currentInput += value
            } else if let last = currentInput.last, last != "(" {
                currentInput += value
            }
            
            
            
            
            
        case ",":
            if currentInput == "0" {
                currentInput = "0,"
            } else if let last = currentInput.last, last == "("{
                currentInput += "0,"
            } else if let last = currentInput.last, last == ")" {
                currentInput.removeLast()
                currentInput += ")"
            } else {
                let components = currentInput.components(separatedBy: ["+", "-", "÷", "×"])
                if let lastNumber = components.last, !lastNumber.contains(",") {
                    if let last = currentInput.last, ["+", "-", "÷", "×"].contains(String(last)) {
                        currentInput += "0"
                    }
                    currentInput += ","
                }
            }
            
        case "=":
            print("nil")
            
        case "±":
            if currentInput == "0" {
                return currentInput
            }
            
            let operators = ["+", "-", "÷", "×"]
            let hasOperators = operators.contains { currentInput.contains($0) }
            
            if !hasOperators {
                if currentInput.hasPrefix("-") {
                    currentInput.removeFirst()
                } else {
                    currentInput = "-" + currentInput
                }
            } else {
                var components = currentInput.components(separatedBy: CharacterSet(charactersIn: "+-÷×"))
                if var lastNumber = components.last {
                    if lastNumber.hasPrefix("-") {
                        lastNumber.removeFirst()
                    } else {
                        lastNumber = "-" + lastNumber
                    }
                    
                    if let range = currentInput.range(of: components.last ?? "", options: .backwards) {
                        currentInput.replaceSubrange(range, with: lastNumber)
                    }
                }
            }
            
        case "(":
            if  currentInput == "0" {
                currentInput = "("
            }  else if let last = currentInput.last, last == "(" || ["+", "-", "÷", "×"].contains(last) {
                currentInput += "("
            }  else if let last = currentInput.last, last == ","{
                currentInput.removeLast()
                currentInput += "×("
            } else {
                currentInput += "×("
            }
            
            
        case ")":
            let openCount = currentInput.filter { $0 == "(" }.count
            let closeCount = currentInput.filter { $0 == ")" }.count
            print(currentInput)
            if let last = currentInput.last, last == "(" {
                currentInput.removeLast()
                currentInput += "("
            } else if let last = currentInput.last, last == "," && openCount > closeCount{
                currentInput.removeLast()
                currentInput += ")"
            } else if let last = currentInput.last, ["+", "-", "÷", "×"].contains(last) && openCount > closeCount {
                currentInput.removeLast()
                currentInput += ")"
            } else if openCount > closeCount {
                currentInput += ")"
            } else if let last = currentInput.last, last == "-" && openCount > closeCount{
                currentInput.removeLast()
                
            }
            
            
            
            
    
        default:
            
            if currentInput == "0" {
                currentInput = value
            } else if currentInput.suffix(2) == "00" {
                currentInput.removeLast()
            }
            else if let last = currentInput.last, last == ")" {
                currentInput = currentInput + "×" + value
            }else {
                if value == "0", let lastChar = currentInput.last,  "+-×÷".contains(lastChar) {
                    currentInput += value
                } else if value == "0", currentInput.hasSuffix("0") {
                    
                }  else {
                    currentInput += value
                }
            }
            
//            
//            else {
//                currentInput += value
//            }
            
        }
        
        return currentInput
    }
    
    
//    private func formatResult(_ result: Double) -> String {
//        if result.truncatingRemainder(dividingBy: 1) == 0 {
//            return String(Int(result))
//        } else {
//            return String(result).replacingOccurrences(of: ".", with: ",")
//        }
//    }
}
