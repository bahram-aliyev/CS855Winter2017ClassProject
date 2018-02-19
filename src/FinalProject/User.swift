//
//  User.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//


final class User {

    let id: String
    let email: String
    let name: String
    
    init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
}
