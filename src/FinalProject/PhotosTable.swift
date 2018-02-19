//
//  PhotosTable.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

final class PhotosTable {
    
    static let table = Table("photos")
    
    static let id1 = Expression<String>(clmns.id)
    
    static let userId2 = Expression<String>(clmns.userId)
    
    static let channelId3 = Expression<String>(clmns.channelId)
    
    static let thumbnail4 = Expression<Data>(clmns.thumbnail)
    
    static let rawImage5 = Expression<Data>(clmns.rawImage)
    
    static let hashtags6 = Expression<String?>(clmns.hashtags)
    
    static let author7 = Expression<String>(clmns.author)
    
    static let entryDate8 = Expression<Date>(clmns.entryDate)
    
    static let pendign9 = Expression<Int>(clmns.pendign)
    
    private init() { }
    
}
