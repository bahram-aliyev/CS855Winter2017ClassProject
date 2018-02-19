//
//  TransactionScopeSQLite.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

class TransactionScopeSQLite : TransactionScope {
    func execute(context: @escaping () -> Void, completion: @escaping (Error?) -> Void) {
        do {
            try SQLiteDb.instance.transaction {
                context()
            }
            completion(nil)
        }
        catch {
            completion(error)
        }
    }
}
