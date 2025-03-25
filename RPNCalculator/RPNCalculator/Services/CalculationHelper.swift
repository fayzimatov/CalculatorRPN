//
//  CalculationHelper.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 20/03/25.
//

final class CalculationHelper: CalculationHelperProtocol {
    func replaceCommasWithDots(in text: String) -> String {
        return text.replacingOccurrences(of: ",", with: ".")
    }

    func replaceDotsWithCommas(in text: String) -> String {
        return text.replacingOccurrences(of: ".", with: ",")
    }

    func formatResult(_ number: Double) -> String {
        let roundedNumber = Double(String(format: "%.10f", number)) ?? number

        if roundedNumber.isInfinite || roundedNumber.isNaN {
            return "Неопределено"
        }

        if roundedNumber > Double(Int.max) || roundedNumber < Double(Int.min) {
            return String(roundedNumber)
        }

        if roundedNumber.truncatingRemainder(dividingBy: 1) == 0 {
            return replaceDotsWithCommas(in: String(Int(roundedNumber)))
        } else {
            return replaceDotsWithCommas(in: String(roundedNumber))
        }
    }
}
