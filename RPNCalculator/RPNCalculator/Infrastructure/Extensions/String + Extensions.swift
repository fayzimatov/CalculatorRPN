//
//  String + Extensions.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 26/03/25.
//

import Foundation

//extension String {
//    var strDesc: String {
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .decimal
//            formatter.maximumFractionDigits = self > 1 ? 7 : 10
//            formatter.decimalSeparator = "."
//            formatter.groupingSeparator = ""
//
//            let nsDecimal = self as NSDecimalNumber
//            let doubleValue = nsDecimal.doubleValue
//
//            if (abs(doubleValue) >= 1e8 || abs(doubleValue) <= 1e-8) && self != 0  {
//                formatter.numberStyle = .scientific
//                formatter.exponentSymbol = "e"
//            }
//
//            return formatter.string(from: nsDecimal) ?? self.description
//        }
//     
//
//}
// 
