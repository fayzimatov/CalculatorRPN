//
//  CalculatorModel.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 10/03/25.
//

import Foundation

final class CalculatorModel {
    
    // MARK: - Properties
    private(set) var currentInput: String = "0"
    private var toggle = true
    private(set) var clearElement = false
    private(set) var resultInput: String?
    
    
    
    // MARK: - Public Methods
    func resetInput() {
        currentInput = "0"
        clearElement = false
        resultInput = nil
    }
    
    func processInput(value: String) -> String {
        switch value {
        case "⌫": checkerDelete()
        case "+", "-", "÷", "×": checkerOperations(value)
        case ",": checkerComma()
        case "=": checkerEqual()
        case "±": checkerNegativeLastNum()
        case "(": checkerOpenBrackets()
        case ")": checkerCloseBrackets()
        default:  checkerNumbers(value)
        }
        return currentInput
    }
    
    func balanceBrackets(in expression: String) -> String {
        let openCount = expression.filter { $0 == "(" }.count
        let closeCount = expression.filter { $0 == ")" }.count
        if expression.last != "(" && !["+", "-", "÷", "×"].contains(expression.last ?? " ") {
            let missingCloseBrackets = max(0, openCount - closeCount)
            return expression + String(repeating: ")", count: missingCloseBrackets)
        }
        return expression
    }
    
    
    
    // MARK: - Private Methods
    private func checkerDelete() {
        if currentInput.contains(where: { $0.isLetter }) {
            currentInput = "0"
        }
        if !currentInput.isEmpty {
            currentInput.removeLast()
            if currentInput.isEmpty {
                currentInput = "0"
            }
        }
    }
    
    private func checkerOperations(_ value: String) {
        if beginWith(in: currentInput) {
            return
        }
        if let lastChar = currentInput.last, lastChar.isLetter {
            return
        }
        clearElement = false
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
    }
    
    private func checkerComma() {
        clearElement = false

        if beginWith(in: currentInput) {
            return
        }
        if let lastChar = currentInput.last, lastChar.isLetter {
            currentInput = "0,"
            clearElement = false
            return
        }
        if currentInput == "0" {
            currentInput = "0,"
        } else if let last = currentInput.last, last == "(" {
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
        
    }
    private func checkerEqual() {
        if beginWith(in: currentInput) {
            return
        }
        
        if containsOperator(in: currentInput) && currentInput.last != "(" {
            clearElement = true
            var tokens: [String] = []
            if let lastChar = currentInput.last, ["+", "-", "÷", "×"].contains(lastChar) {
                currentInput.removeLast()
                tokens = RPNFunctions.tokenizeExpression(String(currentInput))
            } else {
                tokens = RPNFunctions.tokenizeExpression(currentInput)
            }
            let rpnExpression = RPNFunctions.parseToRPN(to: tokens)
            resultInput = balanceBrackets(in: currentInput)
            if ["+", "-", "÷", "×"].contains(currentInput.last) {
                currentInput = RPNFunctions.calculateRPN(to: rpnExpression)
            } else if !(currentInput.last == "(") {
                currentInput = RPNFunctions.calculateRPN(to: rpnExpression)
            }
        }
    }
    
    private func checkerNegativeLastNum() {
        if beginWith(in: currentInput) {
            return
        }
        if let lastChar = currentInput.last, lastChar.isLetter {
            return
        }
        if currentInput == "0" {
            return
        } else {
            currentInput = toggleLastNumberSign(in: currentInput)
        }
        
    }
    
    private func checkerOpenBrackets() {
        if beginWith(in: currentInput) {
            return
        }
        if let lastChar = currentInput.last, lastChar.isLetter {
            currentInput = "("
            clearElement = false
            return
        }
        clearElement = false
        if currentInput == "0" {
            currentInput = "("
        } else if let last = currentInput.last, last == "(" || ["+", "-", "÷", "×"].contains(last) {
            currentInput += "("
        } else if let last = currentInput.last, last == "," {
            currentInput.removeLast()
            currentInput += "×("
        } else {
            currentInput += "×("
        }
    }
    
    private func checkerCloseBrackets() {
        if beginWith(in: currentInput) {
            return
        }
        let openCount = currentInput.filter { $0 == "(" }.count
        let closeCount = currentInput.filter { $0 == ")" }.count
        if let last = currentInput.last, last == "(" {
            currentInput.removeLast()
            currentInput += "("
        } else if let last = currentInput.last, last == "," && openCount > closeCount {
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
        } else if let last = currentInput.last, last == "-" && openCount > closeCount {
            currentInput.removeLast()
        }
    }
    private func checkerNumbers(_ value: String) {
        
        
        if clearElement {
            currentInput = ""
            clearElement = false
        }
        resultInput = ""
        let result = currentInput.split { ["+", "-", "÷", "×"].contains($0) }
        if currentInput == "0" {
            currentInput = value
        } else if let last = splitExpression(currentInput).last, last == "0", !["+", "-", "÷", "×"].contains(currentInput.last) {
            currentInput.removeLast()
            currentInput += value
        } else if let last = currentInput.last, last == ")" {
            currentInput += "×" + value
        } else if value == "0", let lastChar = currentInput.last, "+×÷".contains(lastChar) {
            currentInput += value
        } else if value == "0", currentInput.count > 1,
                  let lastChar = currentInput.last, lastChar == "-",
                  let secondLast = currentInput.dropLast().last, !"0123456789)".contains(secondLast) {
            return
        } else if value == "0", let lastElement = result.last, lastElement.contains(",") {
            currentInput += value
        } else if let lastChar = currentInput.dropLast().last, let last = currentInput.last,
                  value == "0", !result.isEmpty, result.last?.contains(",") == false,
                  "+-×÷".contains(lastChar), last == "0" {
            return
        } else if currentInput.suffix(2) == "(0" {
            currentInput.removeLast()
            currentInput += value
        } else {
            currentInput += value
        }
    }
    
    
    
    
    //MARK: - Helpers
    private func containsOperator(in text: String) -> Bool {
        let operators: Set<Character> = ["+", "-", "÷", "×"]
        return text.contains { operators.contains($0) }
    }
    
    
    private func toggleLastNumberSign(in text: String) -> String {
        var value = text
        let result = splitExpression(value)
        
        
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
    
    private func splitExpression(_ input: String) -> [String] {
        var result: [String] = []
        var number = ""
        var lastOperator: Character?
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
    
    
    private func beginWith(in text: String) -> Bool {
        var boolean = false
        for item in text {
            if item == "e" {
                boolean = true
            }
        }
        return boolean
    }
}

