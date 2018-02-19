//
//  ActivityLogTbl.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

final class ActivityLogTable {
    
    static let table = Table("activity_log")
    
    static let id1 = Expression<String>(clmns.id)
    
    static let userId2 = Expression<String>(clmns.userId)
    
    static let channelId3 = Expression<String>(clmns.channelId)
    
    static let author4 = Expression<String>(clmns.author)
    
    static let type5 = Expression<String>(clmns.type)
    
    static let photoId6 = Expression<String>(clmns.photoId)
    
    static let thumbnail7 = Expression<Data?>(clmns.thumbnail)
    
    static let comment8 = Expression<String?>(clmns.comment)
    
    static let hashtags9 = Expression<String?>(clmns.hashtags)
    
    static let entryDate10 = Expression<Date>(clmns.entryDate)
    
    private init() { }
    
}
