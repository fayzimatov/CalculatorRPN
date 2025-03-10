//
//  RoundedButton.swift
//  RPNCalculator
//
//  Created by Umidjon on 07/03/25.
//

import UIKit

final class RoundedButton: UIButton {
    func circleButton() {
        self.circleButton()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
