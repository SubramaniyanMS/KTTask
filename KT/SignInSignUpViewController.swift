//
//  SignInSignUpViewController.swift
//  preparationApp
//
//  Created by Subramani MAC on 6/29/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SignInSignUpViewController: UIViewController {
    
    lazy var signInScreen = SignInScreen()
    lazy var signUpScreen = SignUpScreen()
    
    lazy var switchViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(switchViewButtonTapped), for: .touchUpInside)
        return button
    }()
   
    lazy var googleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray4
        
        self.signUpScreen.isHidden = true
        switchViewButton.setTitle("don't have an account? SignUp", for: .normal)
        
        setUpUI()
        
        signInScreen.signInSubmitButtonAction = { [weak self] in
            print("sign in submit button tapped")
            self?.signInTap()
        }
        
        signUpScreen.signUpSubmitButtonAction = { [weak self] in
            print("sign up submit button tapped")
            self?.signUpTap()
        }
    }
    
    func setUpUI() {
        view.addSubviews(with: [signInScreen, signUpScreen, switchViewButton, googleButton])
        
        signInScreen.centerX == view.centerX
        signInScreen.centerY == view.centerY
        signInScreen.height == .ratioWidthBasedOniPhoneX(300)
        signInScreen.width == .ratioWidthBasedOniPhoneX(300)
        
        signUpScreen.centerX == view.centerX
        signUpScreen.centerY == view.centerY
        signUpScreen.height == .ratioWidthBasedOniPhoneX(400)
        signUpScreen.width == .ratioWidthBasedOniPhoneX(300)
        
        googleButton.top == signUpScreen.bottom + .ratioHeightBasedOniPhoneX(15)
        googleButton.centerX == view.centerX
        googleButton.height == .ratioWidthBasedOniPhoneX(30)
        googleButton.width == .ratioWidthBasedOniPhoneX(30)
        
        switchViewButton.bottom == view.bottom - .ratioHeightBasedOniPhoneX(5)
        switchViewButton.leading == view.leading + .ratioHeightBasedOniPhoneX(5)
        switchViewButton.trailing == view.trailing + .ratioHeightBasedOniPhoneX(-5)
        switchViewButton.height == .ratioWidthBasedOniPhoneX(30)
    }
    
    @objc func switchViewButtonTapped() {
        if signInScreen.isHidden {
            signInScreen.isHidden = false
            signUpScreen.isHidden = true
            switchViewButton.setTitle("don't have an account? SignUp", for: .normal)
        } else {
            signInScreen.isHidden = true
            signUpScreen.isHidden = false
            switchViewButton.setTitle("already having account? signIn", for: .normal)
        }
    }
    
    func signUpTap() {
        guard let email = signUpScreen.emailTextField.text, !email.isEmpty,
              let password = signUpScreen.passwordTextField.text, !password.isEmpty,
              let name = signUpScreen.nameTextField.text, !name.isEmpty,
              let confirmPassword = signUpScreen.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showErrorAlert(withTitle: "Alert", message: "All Fields are Mandatory!!!")
            return
        }
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showErrorAlert(withTitle: "Sign Up Error", message: error.localizedDescription)
                    return
                }
                self.navigateToMapPage()
            }
        } else {
            showErrorAlert(withTitle: "Alert", message: "Passwords don't match")
        }
    }
    
    func signInTap() {
        guard let email = signInScreen.emailTextField.text, !email.isEmpty,
              let password = signInScreen.passwordTextField.text, !password.isEmpty else {
            showErrorAlert(withTitle: "Alert", message: "All Fields are Mandatory!!!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showErrorAlert(withTitle: "Sign In Error", message: error.localizedDescription)
                return
            }
            self.navigateToMapPage()
        }
    }
    
    @objc func googleButtonTapped() {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { user, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }
            
            guard let idToken = user?.user.idToken,
                  let accessToken = user?.user.accessToken else {
                print("Google Sign-In failed: No authentication data")
                return
            }
            
            print("Google Sign-In successful:")
            self.navigateToMapPage()
            print("User ID: \(user?.user.userID ?? "No user ID")")
            print("ID Token: \(idToken.tokenString)")
            print("Access Token: \(accessToken.tokenString)")
            print("User Email: \(user?.user.profile?.email ?? "No email")")
            print("User Name: \(user?.user.profile?.name ?? "No name")")
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            print("Credential: \(credential)")
        }
    }
    
    func navigateToMapPage() {
        let mapVC = ListViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
