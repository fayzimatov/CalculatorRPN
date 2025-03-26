//
//  CalculatorViewDelegate.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 26/03/25.
//

import UIKit

protocol CalculatorViewDelegate: AnyObject {
    func buttonTapped(_ title: String)
    func buttonLongPressed(_ title: String)
}
