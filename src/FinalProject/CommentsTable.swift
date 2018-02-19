//
//  CommentsTable.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

final class CommentsTable {
    
    static let table = Table("photo_comments")
    
    static let id1 = Expression<String>(clmns.id)
    
    static let userId2 = Expression<String>(clmns.userId)
    
    static let photoId3 = Expression<String>(clmns.photoId)
    
    static let comment4 = Expression<String>(clmns.comment)
    
    static let author5 = Expression<String>(clmns.author)
    
    static let entryDate6 = Expression<Date>(clmns.entryDate)
    
    private init() { }

}
