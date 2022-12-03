//
//  LoginViewController.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDesign()
    }
    
    func setupDesign() {
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        
        registerButton.addTarget(self,
                              action: #selector(didTapRegisterButton),
                              for: .touchUpInside)
        
        self.emailTextField.setLeftPaddingPoints(15)
        self.passwordTextField.setLeftPaddingPoints(15)
    }
    
    private let validation: ValidationService
    
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    @objc func didTapLoginButton() {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
        do {
            let email = try validation.validateEmail(emailTextField.text)
            let password = try validation.validatePassword(passwordTextField.text)
            
            AuthManager.shared.loginUser(email: email, password: password) { success in
                DispatchQueue.main.async {
                    if success { // User logged in
                        Analytics.logEvent("success_login", parameters: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                    } else { // Error ooccurred
                        Analytics.logEvent("error_on_login", parameters: nil)
                        
                        let alert = UIAlertController(title: "Erro",
                                                      message: "Erro ao logar, tente novamente!",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok",
                                                      style: .cancel,
                                                      handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        } catch {
            self.presentAlertError(title: "Erro",
                                   message: "Erro ao logar, tente novamente!",
                                   title1: "Ok")
            print("Error on Signing Up")
        }
        
    }

    @objc private func didTapRegisterButton() {
        let registerVC = RegisterService().alert()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }
    
    func presentAlertError(title: String, message: String, title1: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let actionOk = UIAlertAction(title: title1, style: .default, handler: nil)
        alertController.addAction(actionOk)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            didTapLoginButton()
        }
        return true
    }
    
}
























