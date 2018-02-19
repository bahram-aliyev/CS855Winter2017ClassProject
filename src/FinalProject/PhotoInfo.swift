//
//  PhotoReelItem.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class PhotoInfo {
    let id: String
    let channelId: String
    var thumbnail: Data
    var hastags: String?
    var pending: Int = 0
    
    init(id: String, channelId: String, thumbnail: Data, hastags: String?, pending: Int) {
        self.id = id
        self.channelId = channelId
        self.thumbnail = thumbnail
        self.hastags = hastags
        self.pending = pending
    }
}

