//
//  ViewController.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private func handleIsAuthenticated() {
        if !AuthManager.shared.isSignedIn() { // User not signed In, show Login Screen
            let loginVC = LoginService().alert()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleIsAuthenticated()
    }

}
