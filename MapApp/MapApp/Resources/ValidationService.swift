//
//  ValidationService.swift
//  MapApp
//
//  Created by Fernando Moreira on 27/11/22.
//

import Foundation

struct ValidationService {
    
    func validateName(_ name: String?) throws -> String {
        guard let name = name else { throw
            ValidationError.invalidName
        }
        
        if !name.isAlphanumeric {
            throw ValidationError.invalidName
        }
        return name
    }
    
    func validateEmail(_ email: String?) throws -> String {
        guard let email = email else { throw
            ValidationError.invalidValue
        }
        if !email.contains("@") || !email.contains(".") || email == "" {
            throw ValidationError.invalidEmail
        }
        return email
    }
    
    func validatePassword(_ password: String?) throws -> String {
        guard let password = password else { throw
            ValidationError.invalidValue
        }
        if password.count < 6 || password == "" {
            throw ValidationError.passwordTooShort
        }
        return password
    }
    
}

enum ValidationError: LocalizedError {
    case invalidName
    case invalidValue
    case invalidEmail
    case passwordTooShort
    
    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "Você digitou um nome inválido."
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








