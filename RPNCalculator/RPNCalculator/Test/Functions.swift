//
//  Functions.swift
//  RPNCalculator
//
//  Created by Umidjon on 18/03/25.
//


class RPNFunctions {
    
    
    func tokenizeExpression(_ expression: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        
        for char in expression {
            if char.isNumber || char == "," || char == "." {
                currentToken.append(char)
            } else if ["+", "-", "*", "÷", "(", ")","/"].contains(char) {
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
    
    
    func replaceCommasWithDots(in text: String) -> String {
        return text.replacingOccurrences(of: ",", with: ".")
    }
    
    
    
    
    
    
//    func parseToRPN(to tokens: [String]) -> [String] {
//        
//        
//        var output: [String] = []
//        
//        var operators: [String] = []
//        
//        var precedence: [String: Int] = ["+" : 1, "-" : 1, "*" : 2, "/" : 2]
//        
//        
//        for token in tokens {
//            if let number = Double(token) {
//                output.append(token)
//            } else if token == "(" {
//                operators.append(token)
//            } else if token == ")" {
//                while let last = operators.last, last != "(" {
//                    output.append(operators.removeLast())
//                }
//                operators.removeLast()
//            } else if precedence.keys.contains(token) {
//                while let last = operators.last, let lastPrecedence = precedence[last],
//                      let tokenPrecedence = precedence[token], lastPrecedence >= tokenPrecedence {
//                    output.append(operators.removeLast())
//                }
//                operators.append(token)
//            }
//        }
//        
//        while let op = operators.popLast() {
//            output.append(op)
//        }
//        
//        return output
//        
//    }
    
    
    func parseToRPN(to tokens: [String]) -> [String] {
        var output: [String] = []
        var operators = Stack<String>()  // Используем Stack
        let precedence: [String: Int] = ["+" : 1, "-" : 1, "*" : 2, "/" : 2]

        for token in tokens {
            if let _ = Double(token) {  // Число -> сразу в output
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
