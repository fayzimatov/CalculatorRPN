//
//  ViewController.swift
//  RPNCalculator
//
//  Created by Umidjon on 06/03/25.
//

import UIKit

// need to give a meaningful name
class ViewController: UIViewController {

// MARK: - UI Elements
    private let buttonElements: [[String]] = [
        ["⌫", "(", ")", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["±", "0", ",", "="]
    ]

    // this is not a UI Element, but a property. Try to add a new MARK 'Properties' and place it before 'UI Elements' (common style)
    var model = CalculatorModel()
    
    // a property as well + normally enums are placed not in a class, but above
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
        label.textColor = .customLabel
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
        label.textColor = .customLightGray
        return label
    }()
    
   

    private let vStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = UIConstants.intervalSpacingStackView
        return vStackView
    }()

    /* this func must be placed before all custom funcs
     Common order of parts:
     1. properties
     2. ui elements
     3. override funcs
     4. custom funcs (eg. open funcs first, then second funcs)
     5. selector funcs
     6. extensions
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }


    
    //MARK: - @objc functions
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        let newText = model.inputSource(value: title)
        updateInputLabel(text: newText)
        if title != "=" {
                     resultLabel.text?.removeAll()
        } else {
            if var result = model.resultInput {
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
                let newText = model.inputSource(value: title)
                updateInputLabel(text: newText)
                resultLabel.text = model.resultInput
                updateResultLabel()
            }
        }
    }
    
    
    //MARK: - SetupUI
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
    
    
    
    //MARK: - setupConstraints
    private func setupConstraints() {
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
            scrollViewResultLabel.bottomAnchor.constraint(equalTo: inputLabel.topAnchor, constant: UIConstants.inputLabelBottom),
            scrollViewResultLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            resultLabel.heightAnchor.constraint(equalTo: scrollViewResultLabel.heightAnchor),
            resultLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollViewResultLabel.widthAnchor),
            
            
            // InputLabel внутри ScrollView
            inputLabel.heightAnchor.constraint(equalTo: scrollViewInputLabel.heightAnchor),
            inputLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollViewInputLabel.widthAnchor),
            
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
        button.setTitle(title, for: .normal)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = UIConstants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed(_:)))
            button.addGestureRecognizer(longPress)
        
        return button
    }
    
    
    
    
    private func updateResultLabel() {
        resultLabel.sizeToFit()
        scrollViewResultLabel.contentSize = CGSize(width: resultLabel.frame.width, height: scrollViewResultLabel.frame.height)

        // Скроллим вправо к концу текста
        let offsetX = max(scrollViewResultLabel.contentSize.width - scrollViewResultLabel.bounds.width, 0)
        scrollViewResultLabel.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
   
    
    private func updateInputLabel(text: String) {
        inputLabel.text = text
        
        // Layout-ni yangilash
        inputLabel.sizeToFit()
        scrollViewInputLabel.contentSize = CGSize(width: inputLabel.frame.width, height: scrollViewInputLabel.frame.height)

        // Scroll-ni oxiriga surish
        let offsetX = max(scrollViewInputLabel.contentSize.width - scrollViewInputLabel.bounds.width, 0)
        scrollViewInputLabel.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
     
}

