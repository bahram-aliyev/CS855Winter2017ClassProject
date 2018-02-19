//
//  CommentActivityLog.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class CommentActivityLog : ActivityLog {
    let comment: String
    
    init(id: String, userId: String, channelId: String, photoId: String, comment: String, author: String, entryDate: Date) {
        self.comment = comment
        super.init(id: id, userId: userId, channelId: channelId, photoId: photoId, type: .comment, author: author, entryDate: entryDate)
    }
    
    convenience init(userId: String, channelId: String, photoId: String, comment: String, author: String) {
        self.init(id: UUID.init().uuidString, userId: userId, channelId: channelId, photoId: photoId, comment: comment, author: author, entryDate: Date())
    }
}
