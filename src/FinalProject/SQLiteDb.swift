//
//  SQLiteDb.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

final class SQLiteDb {
    
    private static var path: String {
        get {
            return
                FileManager().urls(for: .documentDirectory, in: .userDomainMask)
                                    .first!.appendingPathComponent("app.db").path
        }
    }
    
    static var isCreated: Bool {
        get {
            return FileManager().fileExists(atPath: path)
        }
    }
    
    static let instance = try! Connection(path)
    
    private init() {
        
    }
}
