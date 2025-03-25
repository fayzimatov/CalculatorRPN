//
//  CalculatorViewController.swift
//  RPNCalculator
//
//  Created by Umidjon on 06/03/25.
//

import UIKit

import UIKit

final class CalculatorViewController: UIViewController {
    
    let model: CalculatorModelProtocol
    
    private let buttonElements: [[String]] = [
        ["⌫", "(", ")", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["±", "0", ",", "="]
    ]
    
    // MARK: - UI Elements
    let scrollViewInputLabel: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    let inputLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .customLabel
        return label
    }()
    
    let scrollViewResultLabel: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 30)
        label.textColor = .customLightGray
        return label
    }()
    
    let vStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = UIConstants.intervalSpacingStackView
        return vStackView
    }()
    
    
    
    init(model: CalculatorModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    
    convenience init() {
        let calculationHelper = CalculationHelper()
        let rpnService = RPNCalculatorService(helper: calculationHelper)
        let model = CalculatorModel(rpnService: rpnService)
        self.init(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .customBlack)
        view.addSubview(scrollViewInputLabel)
        view.addSubview(scrollViewResultLabel)
        scrollViewInputLabel.addSubview(inputLabel)
        scrollViewResultLabel.addSubview(resultLabel)
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
    
    
}
