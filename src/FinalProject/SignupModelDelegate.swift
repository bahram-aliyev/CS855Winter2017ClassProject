//
//  SignupModelDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-06.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol SignupModelDelegate : AuthenticationDelegate {
    
    func modelValidated(validationResult:[String:String])
    
    func validationFailed()
    
    func signUpFailed(cause:String)
    
}
