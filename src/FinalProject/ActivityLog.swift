//
//  ActivityLog.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityLog {

    let id: String
    let userId: String
    let channelId: String
    let photoId: String
    let type: ActivityType
    let author: String
    let entryDate: Date
    
    init(id: String, userId: String, channelId: String, photoId: String, type: ActivityType, author: String, entryDate: Date) {
        self.id = id
        self.userId = userId
        self.channelId = channelId
        self.photoId = photoId
        self.type = type
        self.author = author
        self.entryDate = entryDate
    }
}
