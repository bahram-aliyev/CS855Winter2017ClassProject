//
//  ChannelItemModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class Channel {
    
    let id: String
    let name: String
    let author: String
    let entryDate: Date
    private(set) var participants: [User]
    
    var lastActivity: Date!
    var pendgin: Int = 0
    var thumbnail: Data!
    
    init(id: String, name: String, author: String, entryDate: Date,
                 participants: [User], lastActivity: Date!, pendgin: Int, thumbnail: Data!) {
        self.id = id
        self.name = name
        self.author = author
        self.entryDate = entryDate
        self.participants = participants
        self.lastActivity = lastActivity
        self.pendgin = pendgin
        self.thumbnail = thumbnail
    }
    
    convenience init(name: String, author: String) {
        self.init(id: UUID.init().uuidString, name: name, author: author, entryDate: Date(),
                  participants:[User](), lastActivity: nil, pendgin: 0, thumbnail: nil)
    }
    
    func addParticipant(contact: User) {
        participants.append(contact)
    }
}
