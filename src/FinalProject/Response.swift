//
//  ResponseBase.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class Response {
    let id: String
    let requestId: String
    let status: ResponseStatus
    
    init(requestId: String, status: ResponseStatus) {
        self.id = UUID().uuidString
        self.requestId = requestId
        self.status = status
    }
}

class ResponseData<T> : Response {
    let data: T!
    
    init(requestId: String, data: T!) {
        self.data = data
        super.init(requestId: requestId, status: .success)
    }
    
    init(requestId: String, failureCause: String) {
        self.data = nil
        super.init(requestId: requestId, status: .failure(failureCause))
    }
}

enum ResponseStatus {
    case success
    case failure(String)
}
