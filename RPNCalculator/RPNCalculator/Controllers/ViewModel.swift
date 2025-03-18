//
//  Model.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 10/03/25.
//

import Foundation
class CalculatorModel {
    
    private var currentInput: String = "0"
    private var toggle = true
    
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
                if last == "-" && currentInput.suffix(2) == "(-" && value != "-" {
                    currentInput.removeLast()
                } else {
                    currentInput.removeLast()
                    currentInput += value
                }
                
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
                currentInput += "×0,"
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
            currentInput = balanceBrackets(in: currentInput)
            currentInput = simplifyBrackets(in: currentInput)
            
            
        case "±":
            let operators = ["+", "-", "÷", "×"]
            let hasOperators = operators.contains { currentInput.contains($0) }
            
            let result = currentInput.split { ["+", "-", "÷", "×"].contains($0) }
            
            
            
            if currentInput == "0" {
                return currentInput
            } else  {
                currentInput = toggleSign(in: currentInput)
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
            if let last = currentInput.last, last == "(" {
                currentInput.removeLast()
                currentInput += "("
            } else if let last = currentInput.last, last == "," && openCount > closeCount{
                currentInput.removeLast()
                currentInput += ")"
            } else if let last = currentInput.last, ["+", "-", "÷", "×"].contains(last) && openCount > closeCount {
                if currentInput.suffix(2) == "(-" {
                    currentInput.removeLast()
                } else {
                    currentInput.removeLast()
                    currentInput += ")"
                }
            } else if openCount > closeCount {
                currentInput += ")"
            } else if let last = currentInput.last, last == "-" && openCount > closeCount{
                currentInput.removeLast()
                
            }
            
            
        default:
            let result = currentInput.split { ["+", "-", "÷", "×"].contains($0) }
            
            let lastChar = currentInput.last
            
            if currentInput == "0" {
                currentInput = value
            }
            else if let last = currentInput.last, last == ")" {
                currentInput += "×" + value
            }
            else if value == "0", let lastChar = currentInput.last, "+×÷".contains(lastChar) {
                // "+", "×", "÷" dan keyin "0" qo'shishga ruxsat beramiz
                currentInput += value
            }
            else if value == "0", let lastChar = currentInput.last, lastChar == "-",
                    let secondLast = currentInput.dropLast().last, !"0123456789".contains(secondLast) {
                // "-0" bo'lishi mumkin, lekin "00", "-00" yoki undan ko‘pi bo‘lishi mumkin emas
                break
            }
            else if value == "0", result.last?.contains(",") == true {
                currentInput += value
            }
            else if let lastChar = currentInput.dropLast().last, let last = currentInput.last,
                    value == "0", !result[result.count - 1].contains(","),
                    "+-×÷".contains(lastChar), last == "0" {
                break
            } else if  currentInput.suffix(2) == "(0" {
                currentInput.removeLast()
                currentInput += value
            }
            else {
                currentInput += value
            }
        }
            
        
        return currentInput
    }
    
    
    func splitExpression(_ input: String) -> [String] {
        var result: [String] = []
        var number = ""
        var lastOperator: Character? = nil
        var insideBrackets = false

        for (index, char) in input.enumerated() {
            if char == "(" {
                insideBrackets = true
                number.append(char)
            } else if char == ")" {
                insideBrackets = false
                number.append(char)
            } else if ["+", "-", "÷", "×"].contains(char), !insideBrackets {
                if char == "-" && (index == 0 || ["+", "-", "÷", "×", "("].contains(lastOperator)) {
                    number.append(char)
                } else {
                    if !number.isEmpty {
                        result.append(number)
                    }
                    number = ""
                    lastOperator = char
                }
            } else {
                number.append(char)
                lastOperator = nil
            }
        }

        if !number.isEmpty {
            result.append(number)
        }

        if result.count == 1, result[0].first == "(", result[0].last == ")" {
            return [result[0]]
        }

        return result
    }

    func toggleSign(in text: String) -> String {
        var value = text
        let result = splitExpression(value)

        let openCount = currentInput.filter { $0 == "(" }.count
        let closeCount = currentInput.filter { $0 == ")" }.count
        
        guard let last = result.last else { return value }
        guard let lastCurrent = currentInput.last,!["+", "-", "÷", "×", "(", ")"].contains(last) else { return value}

        if ["+", "-", "÷", "×", "("].contains(lastCurrent) || openCount > closeCount {
            return value
        } else {
            if value.count > last.count, value.dropLast(last.count + 1).last == "-" {
                let prefix = value.dropLast(last.count + 1)
                value = prefix + "+" + last
                return value
            }
            
            if last.first == "(", last.last == ")", last.dropFirst().first == "-" {
                toggle = true
                let newLast = String(last.dropFirst(2).dropLast()) // (-X) -> X
                value.removeLast(last.count)
                value.append(newLast)
            }
            else if last.first == "(" {
                toggle = false
                let newLast = "(-" + last.dropFirst() // (X) -> (-X)
                value.removeLast(last.count)
                value.append(newLast)
            }
            else if last.first == "-" {
                toggle = true
                let newLast = String(last.dropFirst()) // -X -> X
                value.removeLast(last.count)
                value.append(newLast)
            }
            else {
                toggle = false
                let newLast = "(-" + last + ")" // X -> (-X)
                value.removeLast(last.count)
                value.append(newLast)
            }

        }
        return value
    }
    
    
    func simplifyBrackets(in expression: String) -> String {
        var result = expression
        
        while result.first == "(" && result.last == ")" {
            let trimmed = String(result.dropFirst().dropLast())
            
            let openCount = trimmed.filter { $0 == "(" }.count
            let closeCount = trimmed.filter { $0 == ")" }.count
            
            if openCount == closeCount {
                result = trimmed
            } else {
                break
            }
        }
        
        return result
    }
    
    func balanceBrackets(in expressesion: String) -> String {
        let openCount = currentInput.filter { $0 == "(" }.count
        let closeCount = currentInput.filter { $0 == ")" }.count
        
        if expressesion.last != "(" && !["+", "-", "÷", "×"].contains(expressesion.last)  {
            let missingCloseBrackets = max(0, openCount - closeCount)
            return  expressesion + String(repeating: ")", count: missingCloseBrackets)
        }
       
        return expressesion
        
    }
    
    
}
