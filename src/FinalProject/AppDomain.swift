//
//  AppDomain.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

final class AppDomain {
    
    private(set) static var currentUser: User!
    
    static var delegate: AuthenticationDelegate!
    
    static func initalize(configs: AppDomainConfig...) {
        for config in configs {
            config.configure()
        }
    }
    
    static func authorize(auth: AuthenticationService) {
        auth.signIn(authCallback: {
            (authRs) in
            
            if authRs.isSuccess {
                self.currentUser = authRs.user
                delegate?.authSucceed(currentUser: self.currentUser)
            }
            else {
                self.currentUser = nil
                delegate?.authFailed()
            }
            
            self.delegate = nil
        })
    }
    
    static func logout(auth: AuthenticationService) {
        auth.logout()
        self.currentUser = nil
    }
    
    
}
