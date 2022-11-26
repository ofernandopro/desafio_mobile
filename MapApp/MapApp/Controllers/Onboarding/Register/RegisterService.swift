//
//  RegisterService.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit

class RegisterService {
    
    func alert() -> RegisterViewController {
        let storyBoard = UIStoryboard(name: "RegisterViewController", bundle: .main)
        
        let alertVC = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                
        return alertVC
    }

}
