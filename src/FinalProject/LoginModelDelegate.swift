//
//  LoginModelDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-06.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol LoginModelDelegate : AuthenticationDelegate {
    func loginFailed(cause:String)
}
