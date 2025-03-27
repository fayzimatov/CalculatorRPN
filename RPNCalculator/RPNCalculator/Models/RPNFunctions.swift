//
//  RPNFunctions.swift
//  RPNCalculator
//
//  Created by Umidjon on 18/03/25.
//

import Foundation

final class RPNFunctions {
    static func tokenizeExpression(_ expression: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        let express = replaceCommasWithDots(in: expression)
        
        for char in express {
            if char.isNumber ||  char == "," || char == "." {
                currentToken.append(char)
            } else if ["+", "-", "*", "÷", "(", ")", "/", "×"].contains(char) {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(char))
            } else if char == " " {
                continue
            }
        }
        
        if !currentToken.isEmpty {
            tokens.append(currentToken)
        }
        print("Tokens -> \(tokens)")
        return tokens
    }
    
    static func parseToRPN(to tokens: [String]) -> [String] {
        var output: [String] = []
        var operators = Stack<String>()
        let precedence: [String: Int] = ["+": 1, "-": 1, "*": 2, "/": 2, "÷": 2, "×": 2]
        
        var expectUnary = true
        var index = 0
        
        while index < tokens.count {
            let token = tokens[index]
            
            if let _ = Double(token) {
                output.append(token)
                expectUnary = false
            } else if token == "(" {
                operators.push(token)
                expectUnary = true
            } else if token == ")" {
                while let last = operators.peek(), last != "(" {
                    output.append(operators.pop()!)
                }
                _ = operators.pop()
                expectUnary = false
            } else if token == "-" && expectUnary {
                if index + 1 < tokens.count, let nextNum = Double(tokens[index + 1]) {
                    output.append("-\(nextNum)")
                    index += 1
                } else {
                    output.append("-1")
                    operators.push("*")
                }
                expectUnary = false
            } else if precedence.keys.contains(token) {
                while let last = operators.peek(), let lastPrecedence = precedence[last],
                      let tokenPrecedence = precedence[token], lastPrecedence >= tokenPrecedence {
                    output.append(operators.pop()!)
                }
                operators.push(token)
                expectUnary = true
            }
            
            index += 1
        }
        
        while let op = operators.pop() {
            if op != "(" {
                output.append(op)
            }
        }
        print("ParsingRPN -> \(output)")
        return output
    }
    
    static func calculateRPN(to postfix: [String]) -> String {
        var resultStack = Stack<Double>()
        
        for token in postfix {
            if let number = Double(token) {
                resultStack.push(number)
            } else if let op = Operators(rawValue: token),
                      let num1 = resultStack.pop(),
                      let num2 = resultStack.pop() {
                if num1 == 0 && num2 == 0, op.rawValue == "÷" {
                    return "Бесконечность"
                } else {
                    let result = op.apply(num1, num2)
                    resultStack.push(result)
                }
            }
        }
        
        if let finalResult = resultStack.pop() {
            return formatResult(finalResult)
        }
        return "Неопределено"
    }
    
    
    
    // MARK: - Private Helpers
    private static func replaceCommasWithDots(in text: String) -> String {
        return text.replacingOccurrences(of: ",", with: ".")
    }
    
    private static func replaceDotsWithCommas(in text: String) -> String {
        return text.replacingOccurrences(of: ".", with: ",")
    }
    
    private static func formatResult(_ number: Double) -> String {
        if number.isInfinite || number.isNaN {
            return "Неопределено"
        }

        let absNumber = abs(number)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = number > 1 ? 7 : 10
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = ""

        // Если число слишком большое или слишком маленькое — используем научную нотацию
        if (absNumber >= 1e8 || absNumber <= 1e-8) && number != 0 {
            formatter.numberStyle = .scientific
            formatter.exponentSymbol = "e"
        }

        return formatter.string(from: NSNumber(value: number)) ?? String(number)
    }
}
