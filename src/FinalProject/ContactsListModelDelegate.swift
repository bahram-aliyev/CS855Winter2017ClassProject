//
//  ContactsListModelDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-07.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ContactsListModelDelegate {
    
    func contactsLoaded()
    
    func contactsLoadFailed(cause: String)
}
