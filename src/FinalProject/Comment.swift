//
//  Comment.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class Comment {
    let id: String
    let photoId: String
    let userId: String
    let text: String
    let entryDate: Date
    let author: String
    
    init(id: String, photoId: String, userId: String, text: String, entryDate: Date, author: String) {
        self.id = id
        self.photoId = photoId
        self.userId = userId
        self.text = text
        self.entryDate = entryDate
        self.author = author
    }
    
    convenience init(text: String, photoId: String, author: String, userId: String) {
        self.init(id: UUID.init().uuidString, photoId: photoId, userId: userId,
                  text: text, entryDate: Date(), author: author)
    }
}
