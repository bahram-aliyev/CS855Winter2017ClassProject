//
//  SignupModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import Validator

class SignupModel {
    
    var email: String!
    var name: String!
    var password: String!
    
    var delegate: SignupModelDelegate!
    
    private let authService: AuthenticationService
    
    let emailValidator = ValidationRulePattern(pattern: EmailValidationPattern.standard,
                                                    error: ValidationError(message: "Please provide a valid email."))

    
    let nameValidator = ValidationRuleCondition<String>(error: ValidationError(message: "User Name is required.")) {
        return !($0?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
    
    let passwordRules: ValidationRuleSet<String>
    
    init(authService: AuthenticationService) {
        self.authService = authService
        
        var passwordRules = ValidationRuleSet<String>()
        passwordRules.add(rule: ValidationRuleLength(min: 6, error: ValidationError(message: "Password must be at least 6 characters long.")))
        passwordRules.add(rule: ValidationRuleRequired<String>(error: ValidationError(message: "Password is required.")))
        self.passwordRules = passwordRules
    }
    
    func signUp() {
        if self.isValid() {

            let signupRq = SignupRequest(email: self.email, name: self.name, password: self.password)
            authService.signUp(request: signupRq, authCallback: {
                
                // signing up
                (signupRs) in
                    if signupRs.isSuccess {
                        let signinRq = SigninRequest(email: self.email, password: self.password)
                        
                        // login after the signing up
                        self.authService.signIn(request: signinRq, authCallback: {
                            (loginRs) in
                                AppDomain.delegate = self.delegate
                                AppDomain.authorize(auth: self.authService)
                        })
                }
                else {
                    self.delegate?.signUpFailed(cause: signupRs.erroMessage)
                }
            })
        }
        else {
            delegate?.validationFailed()
        }
    }
    
    private func isValid() -> Bool {
        var validationResult = [String:String]()
        
        if case let ValidationResult.invalid(error) = Validator.validate(input: self.name, rule: self.nameValidator) {
            validationResult["name"] = (error.first as? ValidationError)?.localizedDescription
        }
        
        if case let ValidationResult.invalid(error) = Validator.validate(input: self.email, rule: self.emailValidator) {
            validationResult["email"] = (error.first as? ValidationError)?.localizedDescription
        }
        
        if case let ValidationResult.invalid(error) = Validator.validate(input: self.password, rules: self.passwordRules) {
            validationResult["password"] = (error.first as? ValidationError)?.localizedDescription
        }
        
        self.delegate?.modelValidated(validationResult: validationResult)
        
        return validationResult.isEmpty
    }
}
