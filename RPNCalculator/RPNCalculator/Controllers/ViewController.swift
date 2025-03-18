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
                return UIColor(named: "customLightGray") ?? .gray // enum with colors or extenxion with colors
            case "÷", "×", "-", "+", "=":
                return UIColor(named: "customOrange") ?? .orange
            default:
                return UIColor(named: "customGray") ?? .gray
            }
        }

    
    
    // MARK: - ScrollView for inputLabel
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()

    private let inputLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 60)
        label.textColor = .white
//        label.minimumScaleFactor = 0.5
//        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
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
        view.addSubview(scrollView)
        scrollView.addSubview(inputLabel)
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            scrollView.bottomAnchor.constraint(equalTo: vStackView.topAnchor, constant: UIConstants.inputLabelBottom),
            scrollView.heightAnchor.constraint(equalToConstant: 100),
            
            // InputLabel внутри ScrollView
            inputLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            inputLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            inputLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            inputLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor),
            
            // Кнопки
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leftSpacingVStackview),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leftSpacingVStackview),
            vStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.vStackViewBottom),
            vStackView.heightAnchor.constraint(equalToConstant: UIConstants.vStackViewHeight)
        ])
    }
        
        

    
    // move to UIButton extension
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
        let newText = model.inputSource(value: title)
        updateInputLabel(text: newText)
        
    }

    
    private func updateInputLabel(text: String) {
        inputLabel.text = text
        
        // Layout-ni yangilash
        inputLabel.sizeToFit()
        scrollView.contentSize = CGSize(width: inputLabel.frame.width, height: scrollView.frame.height)

        // Scroll-ni oxiriga surish
        let offsetX = max(scrollView.contentSize.width - scrollView.bounds.width, 0)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
     
}

