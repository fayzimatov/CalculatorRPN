//
//  Functions.swift
//  RPNCalculator
//
//  Created by Umidjon on 18/03/25.
//


class RPNFunctions {
    
    
    static func tokenizeExpression(_ expression: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        var express = replaceCommasWithDots(in: expression)
        
        for char in express {
            if char.isNumber || char == "," || char == "." {
                currentToken.append(char)
            } else if ["+", "-", "*", "÷", "(", ")","/", "×"].contains(char) {
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
        
        return tokens
    }
    
    
    static func replaceCommasWithDots(in text: String) -> String {
        return text.replacingOccurrences(of: ",", with: ".")
    }
    
    
    
    
    
    
    
    static func parseToRPN(to tokens: [String]) -> [String] {
        var output: [String] = []
        var operators = Stack<String>()
        let precedence: [String: Int] = ["+" : 1, "-" : 1, "*" : 2, "/" : 2,"÷" : 2, "×" : 2]

        for token in tokens {
            if let _ = Double(token) {
                output.append(token)
            } else if token == "(" {
                operators.push(token)
            } else if token == ")" {
                while let last = operators.peek(), last != "(" {
                    output.append(operators.pop()!)
                }
                _ = operators.pop()  // Удаляем "("
            } else if precedence.keys.contains(token) {
                while let last = operators.peek(), let lastPrecedence = precedence[last],
                      let tokenPrecedence = precedence[token], lastPrecedence >= tokenPrecedence {
                    output.append(operators.pop()!)
                }
                operators.push(token)
            }
        }

        while let op = operators.pop() {
            output.append(op)
        }

        return output
    }
    
    
}
