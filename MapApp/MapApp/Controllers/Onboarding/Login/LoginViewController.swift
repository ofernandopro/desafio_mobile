//
//  LoginViewController.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        
        registerButton.addTarget(self,
                              action: #selector(didTapRegisterButton),
                              for: .touchUpInside)
        
        self.emailTextField.setLeftPaddingPoints(15)
        self.passwordTextField.setLeftPaddingPoints(15)
        
    }
    
    @objc private func didTapLoginButton() {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  return
        }
        
        AuthManager.shared.loginUser(email: email, password: password) { success in
            DispatchQueue.main.async {
                if success { // User logged in
                    self.dismiss(animated: true, completion: nil)
                } else { // Error ooccurred
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
        
    }

    @objc private func didTapRegisterButton() {
        let registerVC = RegisterService().alert()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
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
























