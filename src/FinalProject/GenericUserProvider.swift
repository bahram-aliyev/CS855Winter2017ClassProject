//
//  GenericUserProvider.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class GenericUserProvider : UserProvider {
    
    let authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    func logout() {
        ActivityLogMediator.current.stopListening(userId: AppDomain.currentUser.id)
        AppDomain.logout(auth: self.authService)
    }

    var currentUser: User! {
        get {
            return AppDomain.currentUser
        }
    }
}
