//
//  Extensions.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 26/03/25.
//

//
//  Button + Extensions.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 26/03/25.
//

import UIKit


extension UIButton {
    static func createCalculatorButton(title: String, buttonColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: UIConstants.buttonFontSize)
        button.setTitle(title, for: .normal)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = UIConstants.buttonCornerRadius
        button.layer.masksToBounds = true
        return button
    }
}

//
//  Color + Extensions.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 26/03/25.
//

import UIKit


extension UIColor {
    static let defaultCustomLabel = UIColor(named: "customLabel") ?? .white
    static let defaultCustomLightGray = UIColor(named: "customLightGray") ?? .lightGray
    static let defaultCustomBlack = UIColor(named: "customBlack") ?? .black
    static let defaultCustomGray = UIColor(named: "customGray") ?? .gray
    static let defaultCustomOrange = UIColor(named: "customOrange") ?? .orange
}


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

