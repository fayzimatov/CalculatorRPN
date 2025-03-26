//
//  String+Extensions.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 24/03/25.
//

extension String {
    func replacingCommasWithDots() -> String {
        return replacingOccurrences(of: ",", with: ".")
    }

    func replacingDotsWithCommas() -> String {
        return replacingOccurrences(of: ".", with: ",")
    }
}
