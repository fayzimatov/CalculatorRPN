//
//  Globals1\.swift
//  RPNCalculator
//
//  Created by Umidjon on 11/03/25.
//

import UIKit

class UIConstants {
    
    static let device = UIDevice.current.userInterfaceIdiom
    static let windowWidth: CGFloat = UIScreen.main.bounds.width
    static let windowHeight: CGFloat = UIScreen.main.bounds.height
    static let buttonSize = (windowWidth - 3 * intervalSpacingStackView - 2 * leftSpacingVStackview) / 4
    static let vStackViewBottom: CGFloat = -20
    static let inputLabelBottom: CGFloat = -10

    
    static let buttonCornerRadius: CGFloat = (device == .phone) ? (buttonSize / 2) : 50
    static let buttonFontSize: CGFloat = (device == .phone) ? 24 : 34
    static let leftSpacingVStackview: CGFloat = (device == .phone) ? 16 : 10
    static let intervalSpacingStackView: CGFloat = (device == .phone) ? 10 : 20
    static let vStackViewHeight: CGFloat = (device == .phone) ? (5 * buttonSize + 3 * leftSpacingVStackview) : windowWidth * 0.75
    
}
