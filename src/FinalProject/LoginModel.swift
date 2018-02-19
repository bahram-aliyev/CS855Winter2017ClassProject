//
//  LoginModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class LoginModel {
    
    var email: String!
    var password: String!
    
    var delegate: LoginModelDelegate!
    
    private let authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    func login() {
        let signinRq = SigninRequest(email: self.email, password: self.password)
        authService.signIn(request: signinRq, authCallback: {
            (loginRs) in
            if loginRs.isSuccess {
                AppDomain.delegate = self.delegate
                AppDomain.authorize(auth: self.authService)
            }
            else {
                self.delegate?.loginFailed(cause: loginRs.erroMessage)
            }
        })
    }
    
}
