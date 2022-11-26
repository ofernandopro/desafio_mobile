//
//  ProfileViewController.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBAction func actionSignOutButton(_ sender: Any) {
    
        do {
            try Auth.auth().signOut()
        } catch {
            print("Failed to sign out")
        }
        
        self.handleIsAuthenticated()
        
    }
    
    private func handleIsAuthenticated() {
        if !AuthManager.shared.isSignedIn() { // User not signed In, show Login Screen
            let loginVC = LoginService().alert()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
