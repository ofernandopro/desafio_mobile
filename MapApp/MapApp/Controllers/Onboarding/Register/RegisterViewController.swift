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

        self.setupDesign()
    }
    
    func setupDesign() {
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
    
    private let validation: ValidationService
    
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRegisterButton() {
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        do {
            let name = try validation.validateName(nameTextField.text)
            let email = try validation.validateEmail(emailTextField.text)
            let password = try validation.validatePassword(passwordTextField.text)
        
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
            
        } catch {
            self.presentAlertError(title: "Erro",
                                   message: "Erro ao criar conta, tente novamente!",
                                   title1: "Ok")
            print("Error on Registering")
        }
        
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


