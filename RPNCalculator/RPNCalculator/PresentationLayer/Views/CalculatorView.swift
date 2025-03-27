//
//  CalculatorView.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 20/03/25.
//


import UIKit

final class CalculatorView: UIView {
    // MARK: - Properties
    weak var delegate: CalculatorViewDelegate?
    
    private let buttonElements: [[String]] = [
        ["⌫", "(", ")", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["±", "0", ",", "="]
    ]
    
    // MARK: - UI Elements
    private let scrollViewInputLabel: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let inputLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .defaultCustomLabel
        return label
    }()
    
    private let scrollViewResultLabel: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 30)
        label.textColor = .defaultCustomLightGray
        return label
    }()
    
    private let vStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = UIConstants.intervalSpacingStackView
        return vStackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateInputLabel(text: String) {
        inputLabel.text = text
        inputLabel.sizeToFit()
        scrollViewInputLabel.contentSize = CGSize(width: inputLabel.frame.width, height: scrollViewInputLabel.frame.height)
        let offsetX = max(scrollViewInputLabel.contentSize.width - scrollViewInputLabel.bounds.width, 0)
        scrollViewInputLabel.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
    func updateResultLabel(text: String?) {
        resultLabel.text = text
        resultLabel.sizeToFit()
        scrollViewResultLabel.contentSize = CGSize(width: resultLabel.frame.width, height: scrollViewResultLabel.frame.height)
        let offsetX = max(scrollViewResultLabel.contentSize.width - scrollViewResultLabel.bounds.width, 0)
        scrollViewResultLabel.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .defaultCustomBlack
        addSubview(scrollViewInputLabel)
        addSubview(scrollViewResultLabel)
        scrollViewInputLabel.addSubview(inputLabel)
        scrollViewResultLabel.addSubview(resultLabel)
        addSubview(vStackView)
        
        for row in buttonElements {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = UIConstants.intervalSpacingStackView
            vStackView.addArrangedSubview(rowStackView)
            
            for title in row {
                let color = getButtonColor(for: title)
                let button = UIButton.createCalculatorButton(title: title, buttonColor: color)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed(_:)))
                button.addGestureRecognizer(longPress)
                rowStackView.addArrangedSubview(button)
            }
        }
    }
    private func setupConstraints() {
        scrollViewInputLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollViewResultLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollViewInputLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            scrollViewInputLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            scrollViewInputLabel.bottomAnchor.constraint(equalTo: vStackView.topAnchor, constant: UIConstants.inputLabelBottom),
            scrollViewInputLabel.heightAnchor.constraint(equalToConstant: 50),
            
            scrollViewResultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            scrollViewResultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            scrollViewResultLabel.bottomAnchor.constraint(equalTo: scrollViewInputLabel.topAnchor, constant: UIConstants.inputLabelBottom),
            scrollViewResultLabel.heightAnchor.constraint(equalToConstant: 30),
            
            resultLabel.heightAnchor.constraint(equalTo: scrollViewResultLabel.heightAnchor),
            resultLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollViewResultLabel.widthAnchor),
            
            inputLabel.heightAnchor.constraint(equalTo: scrollViewInputLabel.heightAnchor),
            inputLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollViewInputLabel.widthAnchor),
            
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            vStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.vStackViewBottom),
            vStackView.heightAnchor.constraint(equalToConstant: UIConstants.vStackViewHeight)
        ])
    }
    
    private func getButtonColor(for title: String) -> UIColor {
        switch title {
        case "(", ")", "%", "±", "⌫":
            return UIColor(named: "customLightGray") ?? .gray
        case "÷", "×", "-", "+", "=":
            return UIColor(named: "customOrange") ?? .orange
        default:
            return UIColor(named: "customGray") ?? .gray
        }
    }
    
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        delegate?.buttonTapped(title)
    }
    
    @objc private func buttonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let button = sender.view as? UIButton, let title = button.currentTitle else { return }
            delegate?.buttonLongPressed(title)
        }
    }
}
