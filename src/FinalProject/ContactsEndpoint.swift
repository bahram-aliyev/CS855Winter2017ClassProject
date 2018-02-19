//
//  ContactsEndpoint.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-07.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ContactsEndpoint {
    func getContacts(rq: GetContactsRequest, _ rsClb: @escaping (GetContactsResponse) -> Void)
}

class GetContactsResponse : ResponseData<[User]> { }

class GetContactsRequest : Request<String> { }
