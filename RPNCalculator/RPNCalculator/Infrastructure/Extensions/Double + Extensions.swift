//
//  Double + Extensions.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 26/03/25.
//
import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        return (self * factor).rounded() / factor
    }
}
