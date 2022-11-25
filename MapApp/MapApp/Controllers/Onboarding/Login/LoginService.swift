//
//  LoginService.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit

class LoginService {
    
    func alert() -> LoginViewController {
        let storyBoard = UIStoryboard(name: "LoginViewController", bundle: .main)
        
        let alertVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
        return alertVC
    }

}
