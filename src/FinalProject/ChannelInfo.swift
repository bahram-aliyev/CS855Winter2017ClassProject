//
//  ChannelListItem.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ChannelInfo {

    let id: String
    let name: String
    var lastActivity: Date!
    var pending: Int = 0
    var thumbnail: Data!
    
    init(id: String, name: String, lastActivity: Date!, pending: Int, thumbnail: Data!) {
        self.id = id
        self.name = name
        self.lastActivity = lastActivity
        self.pending = pending
        self.thumbnail = thumbnail
    }
}
