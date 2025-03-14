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
                if last == "-" && currentInput.suffix(2) == "(-" && value != "-" {
                    print(currentInput.suffix(2))
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
            print("nil")
            
        case "±":
            
            let operators = ["+", "-", "÷", "×"]
            let hasOperators = operators.contains { currentInput.contains($0) }
            
            let result = currentInput.split { ["+", "-", "÷", "×"].contains($0) }
            
            
            
            if currentInput == "0" {
                return currentInput
            } else  {
                currentInput = negateLastNumber(in: commaToDot(in: currentInput))
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
                print(currentInput.suffix(2))
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
            print("second \(result)")
            
            let lastChar = currentInput.last
            print(lastChar ?? "nil")
            
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
                print("0 ni - dan keyin kiritish cheklangan")
                break
            }
            else if value == "0", result.last?.contains(",") == true {
                currentInput += value
            }
            else if let lastChar = currentInput.dropLast().last, let last = currentInput.last,
                    value == "0", !result[result.count - 1].contains(","),
                    "+-×÷".contains(lastChar), last == "0" {
                // "00", "-00", "+00" yoki boshqa operator bilan bog'langan "0" larni oldini olamiz
                print("Ketma-ket 0 yozish cheklangan")
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
    
    func splitNumbers(string: String) {
        
    }
    
    func commaToDot(in text: String) -> String {
        var result = text.split { ["+", "-", "÷", "×"].contains(String($0)) }.map { String($0) }
        var modifiedText = text
        
        if let last = result.last, last.contains(",") {
            let replacedLast = last.replacingOccurrences(of: ",", with: ".")
            modifiedText = text.replacingOccurrences(of: last, with: replacedLast, options: .backwards)
        }
        print(modifiedText)
        return modifiedText
    }

    func negateLastNumber(in text: String) -> String {
        var components = text.split { ["+", "-", "÷", "×"].contains(String($0)) }.map { String($0) }
        
        guard !components.isEmpty, let lastNumber = components.last, let number = Double(lastNumber) else {
            return text
        }
        
        let negatedNumber = "(-\(abs(number)))" // Sonni -1 ga ko'paytirib qavs ichiga olamiz
        let modifiedText = text.replacingOccurrences(of: lastNumber, with: negatedNumber, options: .backwards)
        
        return modifiedText
    }
    
//    private func formatResult(_ result: Double) -> String {
//        if result.truncatingRemainder(dividingBy: 1) == 0 {
//            return String(Int(result))
//        } else {
//            return String(result).replacingOccurrences(of: ".", with: ",")
//        }
//    }
}
