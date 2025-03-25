//
//  CalculatorViewController + Extensions.swift
//  RPNCalculator
//
//  Created by Umidjon on 18/03/25.
//

import UIKit

extension CalculatorViewController {
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        let newText = model.processInput(title)
        updateInputLabel(text: newText)
        if title != "=" {
            resultLabel.text?.removeAll()
        } else {
            if var result = model.result {
                result = model.balanceBrackets(in: result)
                resultLabel.text = result
            } else {
                resultLabel.text = ""
            }
        }
        updateResultLabel()
    }

    @objc private func buttonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let button = sender.view as? UIButton, let title = button.currentTitle else { return }
            if title == "⌫" {
                inputLabel.text = "0"
                model.resetInput()
                updateInputLabel(text: "0")
            } else {
                let newText = model.processInput(title)
                updateInputLabel(text: newText)
                resultLabel.text = model.result
                updateResultLabel()
            }
        }
    }

    func createButton(title: String, buttonColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: UIConstants.buttonFontSize)
        button.setTitle(title, for: .normal)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = UIConstants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed(_:)))
        button.addGestureRecognizer(longPress)

        return button
    }

    func updateResultLabel() {
        resultLabel.sizeToFit()
        scrollViewResultLabel.contentSize = CGSize(width: resultLabel.frame.width, height: scrollViewResultLabel.frame.height)
        let offsetX = max(scrollViewResultLabel.contentSize.width - scrollViewResultLabel.bounds.width, 0)
        scrollViewResultLabel.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }

    func updateInputLabel(text: String) {
        inputLabel.text = text
        inputLabel.sizeToFit()
        scrollViewInputLabel.contentSize = CGSize(width: inputLabel.frame.width, height: scrollViewInputLabel.frame.height)
        let offsetX = max(scrollViewInputLabel.contentSize.width - scrollViewInputLabel.bounds.width, 0)
        scrollViewInputLabel.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }

    func setupConstraints() {
        scrollViewInputLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollViewResultLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        vStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollViewInputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            scrollViewInputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            scrollViewInputLabel.bottomAnchor.constraint(equalTo: vStackView.topAnchor, constant: UIConstants.inputLabelBottom),
            scrollViewInputLabel.heightAnchor.constraint(equalToConstant: 50),

            scrollViewResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            scrollViewResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            scrollViewResultLabel.bottomAnchor.constraint(equalTo: scrollViewInputLabel.topAnchor, constant: UIConstants.inputLabelBottom),
            scrollViewResultLabel.heightAnchor.constraint(equalToConstant: 30),

            resultLabel.heightAnchor.constraint(equalTo: scrollViewResultLabel.heightAnchor),
            resultLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollViewResultLabel.widthAnchor),

            inputLabel.heightAnchor.constraint(equalTo: scrollViewInputLabel.heightAnchor),
            inputLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollViewInputLabel.widthAnchor),

            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            vStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.vStackViewBottom),
            vStackView.heightAnchor.constraint(equalToConstant: UIConstants.vStackViewHeight)
        ])
    }
    
    func getButtonColor(for title: String) -> UIColor {
        switch title {
        case "(", ")", "%", "±", "⌫":
            return UIColor(named: "customLightGray") ?? .gray
        case "÷", "×", "-", "+", "=":
            return UIColor(named: "customOrange") ?? .orange
        default:
            return UIColor(named: "customGray") ?? .gray
        }
    }
}
