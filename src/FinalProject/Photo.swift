//
//  Photo.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-27.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class Photo {
    let id: String
    let channelId: String
    let userId: String
    let author: String
    let entryDate: Date
    let rawImage: Data
    let thumbnail: Data
    let hashTags: String!
    
    init(id: String, channelId: String, userId: String, author: String, entryDate: Date,
         rawImage: Data, thumbnail: Data, hashTags: String!) {
        self.id = id
        self.channelId = channelId
        self.userId = userId
        self.author = author
        self.entryDate = entryDate
        self.rawImage = rawImage
        self.thumbnail = thumbnail
        self.hashTags = hashTags
    }
}

