//
//  SignInScreen.swift
//  preparationApp
//
//  Created by Subramani MAC on 6/29/24.
//

import UIKit

class SignInScreen: UIView, UITextFieldDelegate {
    
    var signInSubmitButtonAction: (() -> Void)?
    
    lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Sign In"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Email"
        textField.textColor = .blue
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        return textField
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter PassWord"
        textField.textColor = .blue
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.attributedPlaceholder = NSAttributedString(string: "Enter PassWord", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        return textField
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
        setupUI()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupUI() {
        addSubviews(with: [headingLabel, emailLabel, emailTextField ,passwordLabel, passwordTextField, submitButton])
        
        headingLabel.top == top + .ratioHeightBasedOniPhoneX(5)
        headingLabel.centerX == centerX
        
        emailLabel.top == headingLabel.bottom + .ratioHeightBasedOniPhoneX(5)
        emailLabel.leading == leading + .ratioHeightBasedOniPhoneX(5)
        
        emailTextField.top == emailLabel.bottom + .ratioHeightBasedOniPhoneX(5)
        emailTextField.leading == leading + .ratioHeightBasedOniPhoneX(5)
        emailTextField.trailing == trailing - .ratioHeightBasedOniPhoneX(5)
        emailTextField.height == .ratioHeightBasedOniPhoneX(30)
        
        passwordLabel.top == emailTextField.bottom + .ratioHeightBasedOniPhoneX(5)
        passwordLabel.leading == leading + .ratioHeightBasedOniPhoneX(5)
        
        passwordTextField.top == passwordLabel.bottom + .ratioHeightBasedOniPhoneX(5)
        passwordTextField.leading == leading + .ratioHeightBasedOniPhoneX(5)
        passwordTextField.trailing == trailing - .ratioHeightBasedOniPhoneX(5)
        passwordTextField.height == .ratioHeightBasedOniPhoneX(30)
        
        submitButton.bottom == bottom - .ratioHeightBasedOniPhoneX(10)
        submitButton.width == .ratioWidthBasedOniPhoneX(100)
        submitButton.centerX == centerX
    }
    
    @objc func submitButtonTapped() {
        signInSubmitButtonAction?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
