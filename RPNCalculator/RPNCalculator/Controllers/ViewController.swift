//
//  ViewController.swift
//  RPNCalculator
//
//  Created by Umidjon on 06/03/25.
//

import UIKit

class ViewController: UIViewController {

// MARK: - UI Elements
    private let buttonElements: [[String]] = [
        ["⌫", "(", ")", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["±", "0", ",", "="]
    ]

    
    //MARK: - Zametka
    var model = CalculatorModel()
    
    
    enum ButtonType {
            case number, operatorSymbol, function
        }

    
    // MARK: - ButtonColor function
    private func getButtonColor(for title: String) -> UIColor {
            switch title {
            case "(", ")", "%","±","⌫":
                return UIColor(named: "customLightGray") ?? .gray
            case "÷", "×", "-", "+", "=":
                return UIColor(named: "customOrange") ?? .orange
            default:
                return UIColor(named: "customGray") ?? .gray
            }
        }

    
    
    
    private let inputLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 80, weight: .medium)
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        label.backgroundColor = UIColor(.black)
        return label
    }()
    
    
    private let vStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = UIConstants.intervalSpacingStackView
        return vStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }


    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .customBlack)
        view.addSubview(inputLabel)
        view.addSubview(vStackView)
        
        for row in buttonElements {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = UIConstants.intervalSpacingStackView
            vStackView.addArrangedSubview(rowStackView)
            
            for title in row {
                let color = getButtonColor(for: title)
                let button = createButton(title: title, buttonColor: color)
                rowStackView.addArrangedSubview(button)
            }
        }
    }
    
    
    
    //MARK: - setupConstraints
    private func setupConstraints() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            vStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.vStackViewBottom),
            vStackView.heightAnchor.constraint(equalToConstant: UIConstants.vStackViewHeight)
        ])
    
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            inputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            inputLabel.bottomAnchor.constraint(equalTo: vStackView.topAnchor, constant: UIConstants.inputLabelBottom)
        ])
    }

    

    
    
//MARK: - createButton
    private func createButton(title: String,buttonColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: UIConstants.buttonFontSize)
//        UIConstants.device == .phone ? .boldSystemFont(ofSize: 24) : .boldSystemFont(ofSize: 34)
        button.setTitle(title, for: .normal)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = UIConstants.buttonCornerRadius
//        UIConstants.device == .phone ? (UIConstants.buttonSize)/2 : 50
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        return button
    }
    
    
    
    //MARK: - @objc functions
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
//        if title == "AC" {
//            inputLabel.text = "0"
//        } else {
//            inputLabel.text = (inputLabel.text == "0") ? title : (inputLabel.text ?? "") + title
//        }
        inputLabel.text  = model.inputSource(value: title)
//        print(title)
        
    }
   
    
    
    
    //MARK: - Input Source
    
     
}

