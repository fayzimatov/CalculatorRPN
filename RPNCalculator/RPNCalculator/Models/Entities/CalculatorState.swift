//
//  CalculatorState.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 18/03/25.
//
import UIKit

struct CalculatorState {
    var currentInput: String
    var result: String?
    var clearElement: Bool

    static let initial = CalculatorState(currentInput: "0", result: nil, clearElement: false)
}
