//
//  AuthenticatoinService.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation


protocol AuthenticationService  {
    
    func signUp(request: SignupRequest, authCallback: @escaping (AuthResponse) -> Void)
    
    func signIn(authCallback: @escaping (AuthResponse) -> Void)
    
    func signIn(request: SigninRequest, authCallback: @escaping (AuthResponse) -> Void)
    
    func logout()

}
