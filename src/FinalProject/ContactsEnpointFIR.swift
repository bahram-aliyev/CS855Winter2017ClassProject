//
//  ContactEnpointFIR.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-07.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ContactsEndpointFIR : ContactsEndpoint {
    func getContacts(rq: GetContactsRequest, _ rsClb: @escaping (GetContactsResponse) -> Void) {
        var contacts = [User]()
        
        FIRDatabase.users.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                for entry in data {
                    let userId = entry.key as! String
                    if userId != rq.data {
                        let rawUser = entry.value as! NSDictionary
                        contacts.append(
                            User(id: userId, email: rawUser["email"] as! String, name: rawUser["name"]! as! String)
                        )
                    }
                }

            }
            rsClb(GetContactsResponse(requestId: rq.id, data: contacts))
        }, withCancel: {
            (error) in
                rsClb(GetContactsResponse(requestId: rq.id, failureCause: error.localizedDescription))
        })
    }
}
