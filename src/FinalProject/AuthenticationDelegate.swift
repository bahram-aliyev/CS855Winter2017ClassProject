//
//  AppDomainDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol AuthenticationDelegate {
    
    func authSucceed(currentUser: User)
    
    func authFailed()
    
}
