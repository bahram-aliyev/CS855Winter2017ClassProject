//
//  SignupResponce.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

struct AuthResponse {
    private(set) var isSuccess: Bool
    private(set) var user: User!
    private(set) var erroMessage: String!
    
    init(erroMessage: String! = nil) {
        self.isSuccess = false
        self.user = nil
        self.erroMessage = erroMessage
    }
    
    init(user: User) {
        self.isSuccess = true
        self.user = user
    }
}
