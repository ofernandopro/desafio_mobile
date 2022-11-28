//
//  RegisterViewController.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit
import FirebaseAnalytics

class RegisterViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.addTarget(self,
                              action: #selector(didTapCloseButton),
                              for: .touchUpInside)
        registerButton.addTarget(self,
                              action: #selector(didTapRegisterButton),
                              for: .touchUpInside)
        
        self.nameTextField.setLeftPaddingPoints(15)
        self.emailTextField.setLeftPaddingPoints(15)
        self.passwordTextField.setLeftPaddingPoints(15)
        
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRegisterButton() {
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  return
        }
        
        AuthManager.shared.registerNewUser(name: name, email: email, password: password) { registered in
            DispatchQueue.main.async {
                if registered {
                    Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                        AnalyticsParameterMethod: self.method
                      ])
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Erro",
                                                  message: "Erro ao criar conta, tente novamente!",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: .cancel,
                                                  handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
    
}


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            didTapRegisterButton()
        }
        return true
    }
    
}


