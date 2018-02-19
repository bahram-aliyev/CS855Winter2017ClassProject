
//
//  ValidationError.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-06.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

struct ValidationError: Error {
    
    private let message: String
    
    public init(message m: String) {
        message = m
    }
    
    var localizedDescription: String {
        get {
            return self.message
        }
    }
}
