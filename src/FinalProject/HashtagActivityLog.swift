//
//  TagActivityLog.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class HashtagActivityLog : ActivityLog {
    let hashtags: String
    
    init(id: String, userId: String, channelId: String, photoId: String, hashtags: String, author: String, entryDate: Date) {
        self.hashtags = hashtags
        super.init(id: id, userId: userId, channelId: channelId, photoId: photoId, type: .hashtag, author: author, entryDate: entryDate)
    }
    
    convenience init(userId: String, channelId: String, photoId: String, hashtags: String, author: String) {
        self.init(id: UUID.init().uuidString, userId: userId, channelId: channelId, photoId: photoId,
                    hashtags: hashtags, author: author, entryDate: Date())
    }
}
