//
//  Globals1\.swift
//  RPNCalculator
//
//  Created by Umidjon on 11/03/25.
//

import UIKit

class Constants {
    
    static let device = UIDevice.current.userInterfaceIdiom
    static let windowWidth: CGFloat = UIScreen.main.bounds.width
    static let windowHeight: CGFloat = UIScreen.main.bounds.height
    static let buttonSize = (windowWidth - 3*intervalSpacingStackView - 2*leftSpacingVStackview) / 4
    static let vStackViewBottom: CGFloat = -20
    static let inputLabelBottom: CGFloat = -10
    
    
    static let buttonCornerRadius: CGFloat = {
        if device == .phone {
            return (Constants.buttonSize)/2
        } else {
            return 50
        }
    }()
    
    static let buttonFontSize: CGFloat = {
        if device == .phone {
            return 24
        } else {
            return 34
        }
    }()
    
    
    static let leftSpacingVStackview: CGFloat = {
        if device == .phone {
            return 16
        } else {
            return 10
        }
    }()
    
    
    static let intervalSpacingStackView : CGFloat = {
        if device == .phone {
            return 10
        } else {
            return 20
        }
    }()
    
    
    static let vStackViewHeight: CGFloat = {
        if device == .phone {
            return (5*buttonSize + 3*leftSpacingVStackview)
        } else {
            return windowWidth * 0.75
        }
    }()
}

