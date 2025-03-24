//
//  Model.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 10/03/25.
//

import Foundation
class CalculatorModel {
    
    
    private(set) var currentInput: String = "0"
    
    var clearElement = false
    
    func resetInput() {
        currentInput = "0"
    }
    
        var resultInput: String?
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
            print(currentInput)
            if let lastChar = currentInput.last, lastChar.isLetter {
                print("lastChar: \(lastChar)")
                break
            } else {
                clearElement = false
            }
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
            if let lastChar = currentInput.last, lastChar.isLetter {
                currentInput.removeAll()
                currentInput += "0,"
                clearElement = false
                break
            }
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
            if containsOperator(in: currentInput) && currentInput.last != "(" {
                clearElement = true
            }
            
            func containsOperator(in text: String) -> Bool {
                let operators: Set<Character> = ["+", "-", "÷", "×"]
                return text.contains { operators.contains($0) }
            }

           
            
            var tokens: [String] = []
            if let lastChar = currentInput.last, ["+", "-", "÷", "×"].contains(lastChar) {
                currentInput.removeLast()
                tokens = RPNFunctions.tokenizeExpression(String(currentInput))
            } else {
                tokens = RPNFunctions.tokenizeExpression(currentInput)
            }
            
            let rpnExpression = RPNFunctions.parseToRPN(to: tokens)
            resultInput = currentInput
            if ["+", "-", "÷", "×"].contains(currentInput.last) {
                currentInput = RPNFunctions.calculateRPN(to: rpnExpression)
            } else if !(currentInput.last == "(") {
                currentInput = RPNFunctions.calculateRPN(to: rpnExpression)
            }
                 
        case "±":
            if let lastChar = currentInput.last, lastChar.isLetter {
                break
            }
            let operators = ["+", "-", "÷", "×"]
            let hasOperators = operators.contains { currentInput.contains($0) }
            
            let result = currentInput.split { ["+", "-", "÷", "×"].contains($0) }
            
            
            
            if currentInput == "0" {
                return currentInput
            } else  {
                currentInput = toggleSign(in: currentInput)
            }
            
        case "(":
            if let lastChar = currentInput.last, lastChar.isLetter {
                currentInput.removeAll()
                currentInput += value
                clearElement = false
                break
            }
            clearElement = false
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
            print("clear\(clearElement)")
            print("current\(currentInput)")
            
            if clearElement && ["1","2","3","4","5","6","7","8","9","0"].contains(value) {
                currentInput.removeAll()
                clearElement = false
//                currentInput += value
            }
            let result = currentInput.split { ["+", "-", "÷", "×"].contains($0) }
            print(currentInput)
            //1
            if currentInput == "0" {
                currentInput = value
            }//2 ne daet nam pisat dve nuli ili posle nulya chto to podobnoe
            else if let last = splitExpression(currentInput).last, last == "0" , !["+", "-", "÷", "×"].contains(currentInput.last) {
                print(splitExpression(currentInput))
                print(last)
                print(currentInput)
                currentInput.removeLast()
                currentInput += value
            }
            else if let last = currentInput.last, last == ")" {
                currentInput += "×" + value
            }
            else if value == "0", let lastChar = currentInput.last, "+×÷".contains(lastChar) {
                // Разрешаем "0" после оператора "+", "×", "÷"
                currentInput += value
            }
            else if value == "0", currentInput.count > 1,
                    let lastChar = currentInput.last, lastChar == "-",
                    let secondLast = currentInput.dropLast().last, !"0123456789".contains(secondLast) {
                // Разрешаем "-0", но запрещаем "-00"
                break
            }
            else if value == "0", let lastElement = result.last, lastElement.contains(",") {
                // Разрешаем "0" после запятой (например, "3,0")
                currentInput += value
            }
            else if let lastChar = currentInput.dropLast().last, let last = currentInput.last,
                    value == "0", !result.isEmpty, result.last?.contains(",") == false,
                    "+-×÷".contains(lastChar), last == "0" {
                break
            }
            else if currentInput.suffix(2) == "(0" {
                currentInput.removeLast()
                currentInput += value
            }
            else {
                currentInput += value
            }
        }
        return currentInput
    }
    
    
    private func splitExpression(_ input: String) -> [String] {
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

    
    
    
    private func toggleSign(in text: String) -> String {
        var value = text
        let result = splitExpression(value)
        print("toggle: \(result)")
        
        
        guard let last = result.last else { return value }
        guard let lastCurrent = currentInput.last,!["+", "-", "÷", "×", "(", ")"].contains(last) else { return value}

        if ["+", "-", "÷", "×",].contains(lastCurrent) {
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
            }//------
            else if last.first == "(" {
                
                toggle = false
                let newLast = "(-" + last + ")" // (X) -> (-X)
                value.removeLast(last.count)
                value.append(newLast)
                print(value)
                
                
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

    
    
    func balanceBrackets(in expressesion: String) -> String {
        let openCount = currentInput.filter { $0 == "(" }.count
        let closeCount = currentInput.filter { $0 == ")" }.count
        
        if expressesion.last != "(" && !["+", "-", "÷", "×"].contains(expressesion.last)  {
            let missingCloseBrackets = max(0, openCount - closeCount)
            return  expressesion + String(repeating: ")", count: missingCloseBrackets)
        }
       
        return expressesion
        
    }
    
    
    
    
    
    func cleanExpression(from expression: String) -> String {
        var result = ""
        var previousChar: Character?
        
        for (index, char) in expression.enumerated() {
            if char == "," {
                if index == expression.count - 1 || !expression[expression.index(expression.startIndex, offsetBy: index + 1)].isNumber {
                    continue
                }
            }
            result.append(char)
            previousChar = char
        }
        
        return result
    }

    
    
}
