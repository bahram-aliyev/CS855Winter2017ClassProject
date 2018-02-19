//
//  FirebaseExtention.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FIRDatabase {
    
    static var root: FIRDatabaseReference {
        get {
            return FIRDatabase.database().reference()
        }
    }
    
    static var users: FIRDatabaseReference {
        get {
            return FIRDatabase.database().reference().child(FIRGlossary.users)
        }
    }
    
    static var channels: FIRDatabaseReference {
        get {
            return FIRDatabase.database().reference().child(FIRGlossary.channels)
        }
    }
}
