//
//  DatabaseManager.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    // MARK: - Public
    
    public func canCreateUser(with email: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
}
