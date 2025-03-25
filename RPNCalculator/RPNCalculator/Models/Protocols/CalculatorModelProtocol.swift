//
//  CalculatorModelProtocol.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 18/03/25.
//

protocol CalculatorModelProtocol {
    var result: String? { get }
    func processInput(_ value: String) -> String
    func resetInput()
    func balanceBrackets(in expression: String) -> String
}
