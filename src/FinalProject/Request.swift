//
//  RequestBase.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation


class Request<T> {
    let data: T
    let id: String
    
    init(data: T) {
        self.id = UUID.init().uuidString
        self.data = data
    }
}

class AnyRequest: Request<Any?> {
    init() {
        super.init(data: nil)
    }
}
