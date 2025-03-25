//
//  RPNCalculatorServiceProtocol.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 20/03/25.
//

protocol RPNCalculatorServiceProtocol {
    func tokenizeExpression(_ expression: String) -> [String]
    func convertToRPN(from tokens: [String]) -> [String]
    func calculateRPN(_ expression: [String]) -> String
}
