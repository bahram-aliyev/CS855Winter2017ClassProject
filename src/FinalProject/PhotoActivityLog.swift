//
//  PhotoActivityLog.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class PhotoActivityLog : ActivityLog {
    let image: Data
    var hashtags: String!
    
    init(id: String, userId: String, channelId: String, photoId: String, image: Data, author: String, entryDate: Date, hashtags: String? = nil) {
        self.image = image
        self.hashtags = hashtags
        
        super.init(id: id, userId: userId, channelId: channelId, photoId: photoId, type: .photo, author: author, entryDate: entryDate)
    }
    
    convenience init(userId: String, channelId: String, image: Data, author: String) {
        self.init(id: UUID.init().uuidString, userId: userId, channelId: channelId,
                  photoId: UUID.init().uuidString, image: image, author: author, entryDate: Date())
    }
}
