//
//  CalculationHelperProtocol.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 20/03/25.
//

protocol CalculationHelperProtocol {
    func replaceCommasWithDots(in text: String) -> String
    func replaceDotsWithCommas(in text: String) -> String
    func formatResult(_ number: Double) -> String
}
