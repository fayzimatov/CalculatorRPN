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
        ["(", ")", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["AC", "0", ",", "="]
    ]

    
    
//    enum ButtonType: String {
//        
//        case function = "(",")","%","AC"
//        case operatorSymbol = "÷", "×", "-", "+", "="
//        case number = "0","1", "2", "3", "4", "5", "6", "7", "8", "9", ","
//        
//        
//        var color: UIColor {
//            switch self {
//            case .function:
//                return UIColor(named: "lightGray") ?? .lightGray
//            case .operatorSymbol:
//                return UIColor(named: "orange") ?? .orange
//            case .number:
//                return UIColor(named: "gray") ?? .gray
//            }
//        }
//    }
//    
    
//    enum ButtonType {
//        case function, operatorSymbol, number
//        
//        static func getType(for title: String) -> ButtonType? {
//            switch title {
//            case "(", ")", "%", "AC":
//                return .function
//            case "÷", "×", "-", "+", "=":
//                return .operatorSymbol
//            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",":
//                return .number
//            default:
//                return nil
//            }
//        }
//        
//        var color: UIColor {
//            switch self {
//            case .function:
//                return UIColor(named: "lightGray") ?? .lightGray
//            case .operatorSymbol:
//                return UIColor(named: "orange") ?? .orange
//            case .number:
//                return UIColor(named: "gray") ?? .gray
//            }
//        }
//    }

    
    enum ButtonType {
            case number, operatorSymbol, function
        }

    private func getButtonColor(for title: String) -> UIColor {
            switch title {
            case "(", ")", "%","AC":
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
        label.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        label.textColor = .white
        
        label.backgroundColor = UIColor(.black)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // создание ui-элементов -- кофингурация отдельных сабвью + setupConstraints() -- конфигурация экрана
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .customBlack)
        view.addSubview(inputLabel)
        
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -240),
            inputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputLabel.heightAnchor.constraint(equalToConstant: 100)
        ])//вынести константы в переменные
        
        //вынести стек в ui-элементы
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 10
        view.addSubview(vStackView)
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: 20),
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        
        for row in buttonElements {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            vStackView.addArrangedSubview(rowStackView)
            
            for title in row {
                let color = getButtonColor(for: title)
                let button = createButton(title: title, buttonColor: color)
                rowStackView.addArrangedSubview(button)
            }
        }
    }

    

    
    private func createButton(title: String,buttonColor: UIColor) -> UIButton {
        let button = RoundedButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.setTitle(title, for: .normal)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        return button
    }
    
    
    @objc private func buttonTapped(_ sender: UIButton) {
        //print(sender.titleLabel?.text)
    }
   
    
     
    
}

