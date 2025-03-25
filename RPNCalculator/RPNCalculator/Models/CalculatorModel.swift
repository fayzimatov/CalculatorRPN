//
//  CalculatorModel.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 18/03/25.
//

final class CalculatorModel: CalculatorModelProtocol {
    
    private var state: CalculatorState
    private let rpnService: RPNCalculatorServiceProtocol

    var result: String? { state.result }

    init(state: CalculatorState = .initial, rpnService: RPNCalculatorServiceProtocol) {
        self.state = state
        self.rpnService = rpnService
    }

    func resetInput() {
        state = .initial
    }

    func processInput(_ value: String) -> String {
        switch value {
        case "⌫":
            if !state.currentInput.isEmpty {
                state.currentInput.removeLast()
                if state.currentInput.isEmpty {
                    state.currentInput = "0"
                }
            }

        case "+", "-", "÷", "×":
            if let lastChar = state.currentInput.last, lastChar.isLetter {
                break
            } else {
                state.clearElement = false
            }
            if state.currentInput.isEmpty {
                state.currentInput = "0"
            }
            if let last = state.currentInput.last, ["+", "-", "÷", "×", ","].contains(String(last)) {
                if last == "-" && state.currentInput.suffix(2) == "(-" && value != "-" {
                    state.currentInput.removeLast()
                } else {
                    state.currentInput.removeLast()
                    state.currentInput += value
                }
            } else if let last = state.currentInput.last, last == "(", value == "-" {
                state.currentInput += value
            } else if let last = state.currentInput.last, last != "(" {
                state.currentInput += value
            }

        case ",":
            if let lastChar = state.currentInput.last, lastChar.isLetter {
                state.currentInput.removeAll()
                state.currentInput += "0,"
                state.clearElement = false
                break
            }
            if state.currentInput == "0" {
                state.currentInput = "0,"
            } else if let last = state.currentInput.last, last == "(" {
                state.currentInput += "0,"
            } else if let last = state.currentInput.last, last == ")" {
                state.currentInput += "×0,"
            } else {
                let components = state.currentInput.components(separatedBy: ["+", "-", "÷", "×"])
                if let lastNumber = components.last, !lastNumber.contains(",") {
                    if let last = state.currentInput.last, ["+", "-", "÷", "×"].contains(String(last)) {
                        state.currentInput += "0"
                    }
                    state.currentInput += ","
                }
            }

        case "=":
            if containsOperator(in: state.currentInput) && state.currentInput.last != "(" {
                state.clearElement = true
            }

            var tokens: [String] = []
            if let lastChar = state.currentInput.last, ["+", "-", "÷", "×"].contains(lastChar) {
                state.currentInput.removeLast()
                tokens = rpnService.tokenizeExpression(state.currentInput)
            } else {
                tokens = rpnService.tokenizeExpression(state.currentInput)
            }

            let rpnExpression = rpnService.convertToRPN(from: tokens)
            state.result = balanceBrackets(in: state.currentInput)
            if ["+", "-", "÷", "×"].contains(state.currentInput.last) {
                state.currentInput = rpnService.calculateRPN(rpnExpression)
            } else if state.currentInput.last != "(" {
                state.currentInput = rpnService.calculateRPN(rpnExpression)
            }

        case "±":
            if let lastChar = state.currentInput.last, lastChar.isLetter {
                break
            }
            state.currentInput = toggleSign(in: state.currentInput)

        case "(":
            if let lastChar = state.currentInput.last, lastChar.isLetter {
                state.currentInput.removeAll()
                state.currentInput += value
                state.clearElement = false
                break
            }
            state.clearElement = false
            if state.currentInput == "0" {
                state.currentInput = "("
            } else if let last = state.currentInput.last, last == "(" || ["+", "-", "÷", "×"].contains(last) {
                state.currentInput += "("
            } else if let last = state.currentInput.last, last == "," {
                state.currentInput.removeLast()
                state.currentInput += "×("
            } else {
                state.currentInput += "×("
            }

        case ")":
            let openCount = state.currentInput.filter { $0 == "(" }.count
            let closeCount = state.currentInput.filter { $0 == ")" }.count
            if let last = state.currentInput.last, last == "(" {
                state.currentInput.removeLast()
                state.currentInput += "("
            } else if let last = state.currentInput.last, last == "," && openCount > closeCount {
                state.currentInput.removeLast()
                state.currentInput += ")"
            } else if let last = state.currentInput.last, ["+", "-", "÷", "×"].contains(last) && openCount > closeCount {
                if state.currentInput.suffix(2) == "(-" {
                    state.currentInput.removeLast()
                } else {
                    state.currentInput.removeLast()
                    state.currentInput += ")"
                }
            } else if openCount > closeCount {
                state.currentInput += ")"
            } else if let last = state.currentInput.last, last == "-" && openCount > closeCount {
                state.currentInput.removeLast()
            }

        default:
            if state.clearElement && ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"].contains(value) {
                state.currentInput.removeAll()
                state.clearElement = false
            }
            if state.currentInput == "0" {
                state.currentInput = value
            } else if let last = splitExpression(state.currentInput).last, last == "0", !["+", "-", "÷", "×"].contains(state.currentInput.last) {
                state.currentInput.removeLast()
                state.currentInput += value
            } else if let last = state.currentInput.last, last == ")" {
                state.currentInput += "×" + value
            } else if value == "0", let lastChar = state.currentInput.last, "+×÷".contains(lastChar) {
                state.currentInput += value
            } else if value == "0", state.currentInput.count > 1,
                      let lastChar = state.currentInput.last, lastChar == "-",
                      let secondLast = state.currentInput.dropLast().last, !"0123456789)".contains(secondLast) {
                break
            } else if value == "0", let lastElement = splitExpression(state.currentInput).last, lastElement.contains(",") {
                state.currentInput += value
            } else if let lastChar = state.currentInput.dropLast().last, let last = state.currentInput.last,
                      value == "0", !splitExpression(state.currentInput).isEmpty, splitExpression(state.currentInput).last?.contains(",") == false,
                      "+-×÷".contains(lastChar), last == "0" {
                break
            } else if state.currentInput.suffix(2) == "(0" {
                state.currentInput.removeLast()
                state.currentInput += value
            } else {
                state.currentInput += value
            }
        }
        return state.currentInput
    }

    
    
    private func containsOperator(in text: String) -> Bool {
        let operators: Set<Character> = ["+", "-", "÷", "×"]
        return text.contains { operators.contains($0) }
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

    
    private func toggleSign(in text: String) -> String {
        var value = text
        let result = splitExpression(value)
        guard let last = result.last, let lastCurrent = value.last, !["+", "-", "÷", "×", "(", ")"].contains(lastCurrent) else { return value }

        if value.count > last.count, value.dropLast(last.count + 1).last == "-" {
            let prefix = value.dropLast(last.count + 1)
            value = String(prefix) + "+" + last
            return value
        }

        if last.first == "(", last.last == ")", last.dropFirst().first == "-" {
            let newLast = String(last.dropFirst(2).dropLast())
            value.removeLast(last.count)
            value.append(newLast)
        } else if last.first == "(" {
            let newLast = "(-" + String(last.dropFirst()) + ")"
            value.removeLast(last.count)
            value.append(newLast)
        } else if last.first == "-" {
            let newLast = String(last.dropFirst())
            value.removeLast(last.count)
            value.append(newLast)
        } else {
            let newLast = "(-" + last + ")"
            value.removeLast(last.count)
            value.append(newLast)
        }

        return value
    }

    
    func balanceBrackets(in expression: String) -> String {
    let openCount = state.currentInput.filter { $0 == "(" }.count
    let closeCount = state.currentInput.filter { $0 == ")" }.count

    if expression.last != "(" && !["+", "-", "÷", "×"].contains(expression.last ?? " ") {
        let missingCloseBrackets = max(0, openCount - closeCount)
        return expression + String(repeating: ")", count: missingCloseBrackets)
    }

    return expression
}
    
}
