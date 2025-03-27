//
//  CalculatorViewController.swift
//  RPNCalculator
//
//  Created by Umidjon on 06/03/25.
//

import UIKit


final class CalculatorViewController: UIViewController {
    // MARK: - Properties
    private let calculatorView = CalculatorView()
    private let model = CalculatorModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods
    private func setupView() {
        calculatorView.delegate = self
        self.view = calculatorView
    }
}

// MARK: - RPNCalculatorViewDelegate
extension CalculatorViewController: CalculatorViewDelegate {
    func buttonTapped(_ title: String) {
        let newText = model.processInput(value: title)
        calculatorView.updateInputLabel(text: newText)
        if title != "=" {
            calculatorView.updateResultLabel(text: nil)
        } else {
            calculatorView.updateResultLabel(text: model.resultInput)
        }
    }

    func buttonLongPressed(_ title: String) {
        if title == "⌫" {
            model.resetInput()
            calculatorView.updateInputLabel(text: "0")
            calculatorView.updateResultLabel(text: nil)
        } else {
            let newText = model.processInput(value: title)
            calculatorView.updateInputLabel(text: newText)
            calculatorView.updateResultLabel(text: model.resultInput)
        }
    }
}
