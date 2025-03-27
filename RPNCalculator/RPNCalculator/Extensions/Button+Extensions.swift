//
//  Button+Extensions.swift
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


