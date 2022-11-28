//
//  ValidationService.swift
//  MapApp
//
//  Created by Fernando Moreira on 27/11/22.
//

import Foundation

struct ValidationService {
    
    func validateEmail(_ email: String?) throws -> String {
        guard let email = email else { throw ValidationError.invalidValue }
        guard email.contains("@") || email.contains(".") || email != "" else { throw ValidationError.invalidEmail }
        return email
    }
    
    func validatePassword(_ password: String?) throws -> String {
        guard let password = password else { throw ValidationError.invalidValue }
        guard password.count >= 6 || password != "" else { throw ValidationError.passwordTooShort }
        return password
    }
    
}

enum ValidationError: LocalizedError {
    case invalidValue
    case invalidEmail
    case passwordTooShort
    
    var errorDescription: String? {
        switch self {
        case .invalidValue:
            return "Você digitou um valor inválido."
        case .invalidEmail:
            return "Você digitou um email inválido."
        case .passwordTooShort:
            return "Sua senha deve ter 6 ou mais caracteres!"
        default:
            return ""
        }
    }
    
}








