//
//  Enums.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 26/03/25.
//

import Foundation

enum Operators: String {
    case multiply = "×"
    case multiply2 = "*"
    case divide = "/"
    case divide2 = "÷"
    case minus = "-"
    case plus = "+"

    func applyDecimal(_ num1: Decimal, _ num2: Decimal) -> Decimal {
        switch self {
        case .plus: return num2 + num1
        case .minus: return num2 - num1
        case .multiply,.multiply2: return num2 * num1
        case .divide,.divide2: return num1 != 0 ? num2 / num1 : Decimal.nan
        }
    }
    
   
}
