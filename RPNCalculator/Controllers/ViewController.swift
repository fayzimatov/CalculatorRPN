//
//  ViewController.swift
//  RPNCalculator
//
//  Created by Umidjon on 06/03/25.
//

import UIKit

class ViewController: UIViewController {

    
    private let buttonElements: [[String]] = [
        ["(", ")", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["AC", "0", ",", "="]
    ]

    
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

    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .black)
        view.addSubview(inputLabel)
        
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            inputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
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
                if title == "(" || title == ")" || title == "%" {
                    let button = createButton(title: title, buttonColor: "lightGray")
                    rowStackView.addArrangedSubview(button)
                } else if title == "÷" || title == "×" || title == "-" || title == "=" || title == "+" {
                    let button = createButton(title: title, buttonColor: "orange")
                    rowStackView.addArrangedSubview(button)
                } else {
                    let button = createButton(title: title, buttonColor: "gray")
                    rowStackView.addArrangedSubview(button)
                }
            }
        }
    }

    
    
    
    private func createButton(title: String,buttonColor: String) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(named: buttonColor)
        button.layer.cornerRadius = 40
        button.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        return button
    }
    
    
    @objc private func buttonTapped(_ sender: UIButton) {
        //print(sender.titleLabel?.text)
    }
    
    
}

