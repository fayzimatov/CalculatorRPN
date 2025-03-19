//
//  Functions.swift
//  RPNCalculator
//
//  Created by Umidjon on 18/03/25.
//

import Foundation


class RPNFunctions {
    
    
    static func tokenizeExpression(_ expression: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        let express = replaceCommasWithDots(in: expression)
        
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
    
    
    
    
    
    
    
//    static func parseToRPN(to tokens: [String]) -> [String] {
//        var output: [String] = []
//        var operators = Stack<String>()
//        let precedence: [String: Int] = ["+" : 1, "-" : 1, "*" : 2, "/" : 2,"÷" : 2, "×" : 2]
//
//        for token in tokens {
//            if let _ = Double(token) {
//                output.append(token)
//            } else if token == "(" {
//                operators.push(token)
//            } else if token == ")" {
//                while let last = operators.peek(), last != "(" {
//                    output.append(operators.pop()!)
//                }
//                _ = operators.pop()
//            } else if precedence.keys.contains(token) {
//                while let last = operators.peek(), let lastPrecedence = precedence[last],
//                      let tokenPrecedence = precedence[token], lastPrecedence >= tokenPrecedence {
//                    output.append(operators.pop()!)
//                }
//                operators.push(token)
//            }
//        }
//
//        while let op = operators.pop() {
//            output.append(op)
//        }
//
//        print("parseToRPN: \(output)")
//        return output
//       
//    }
//    
    
    
    
    
    static func parseToRPN(to tokens: [String]) -> [String] {
        var output: [String] = []
        var operators = Stack<String>()
        let precedence: [String: Int] = ["+" : 1, "-" : 1, "*" : 2, "/" : 2, "÷" : 2, "×" : 2]
        
        var expectUnary = true  // Ожидаем унарный минус в начале
        
        var index = 0
        while index < tokens.count {
            let token = tokens[index]
            
            if let _ = Double(token) {  // Если число
                output.append(token)
                expectUnary = false
            } else if token == "(" {  // Если открывающая скобка
                operators.push(token)
                expectUnary = true  // После ( может быть унарный минус
            } else if token == ")" {  // Если закрывающая скобка
                while let last = operators.peek(), last != "(" {
                    output.append(operators.pop()!)
                }
                _ = operators.pop()  // Удаляем "("
                expectUnary = false
            } else if token == "-" && expectUnary {  // Унарный минус
                if index + 1 < tokens.count, let nextNum = Double(tokens[index + 1]) {
                    output.append("-\(nextNum)")  // Склеиваем с числом
                    index += 1  // Пропускаем число, т.к. уже добавили
                }
            } else if precedence.keys.contains(token) {  // Бинарный оператор
                while let last = operators.peek(), let lastPrecedence = precedence[last],
                      let tokenPrecedence = precedence[token], lastPrecedence >= tokenPrecedence {
                    output.append(operators.pop()!)
                }
                operators.push(token)
                expectUnary = true  // Следующий минус после оператора может быть унарным
            }
            
            index += 1
        }

        while let op = operators.pop() {
            output.append(op)
        }

        print("parseToRPN: \(output)")
        return output
    }
    
    
    
    enum Operators: String {
        
        case multiply = "×", multiply2 = "*"
        case divide = "/", divide2 = "÷"
        case minus = "-"
        case plus = "+"
        
        func apply(_ num1: Double, _ num2: Double) -> Double {
            switch self {
            case .multiply, .multiply2:
                return num1 * num2
            case .divide, .divide2:
                return num2 / num1
            case .minus:
                return num2 - num1
            case .plus:
                return num1 + num2
            }
        }
        
    }
    
    
    
    static func calculateRPN(to postfix: [String]) -> String {
        
        var resultStack = Stack<Double>()
        
        for tokens in postfix {
            if let number = Double(tokens) {
                resultStack.push(number)
            } else if let op = Operators(rawValue: tokens),
                      let num1 = resultStack.pop(), //22*(-3) // num1 = 19
                      let num2 = resultStack.pop() {// num2 = nil
                let result = op.apply(num1, num2).rounded(toPlaces: 8)
                resultStack.push(result) // doesn't happen in the second iteration
                
            }
        }
         
        return resultStack.pop().map { String($0) } ?? "Ошибка"
    }
    
    

   
    
}



extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        return (self * factor).rounded() / factor
    }
}
