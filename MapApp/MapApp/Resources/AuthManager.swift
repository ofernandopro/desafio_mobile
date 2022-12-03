//
//  AuthManager.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import FirebaseAuth
import FirebaseFirestore

public class AuthManager {
    
    static let shared = AuthManager()
    var firestore: Firestore?
    
    // MARK: - Public
    
    public func registerNewUser(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
            
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil, result != nil else {
                // Firebase Auth could not create account
                completion(false)
                return
            }
            // Insert into database
            if let idUser = result?.user.uid {
                Firestore.firestore().collection("users").document(idUser).setData([
                    "id": idUser,
                    "name": name,
                    "email": email
                ])
            }
            completion(true)
            
        }
        
    }
    
    public func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard authResult != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func isSignedIn() -> Bool {
        // Check Auth Status
        if Auth.auth().currentUser == nil {
            return false
        }
        return true
    }
    
}

