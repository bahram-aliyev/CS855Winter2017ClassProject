//
//  ChannelQueries.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-27.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ChannelAccessor {
    
    func getChannelPendings(userId: String) -> [ChannelActivityInfo]
    
    func updateChannelActivity(actvtDsc: ChannelActivityDescriptor)
    
    func clearChannelPending(cdsc: ChannelDescriptor)

}

struct ChannelDescriptor {
    
    let channelId: String
    
    let userId: String
    
}

struct ChannelActivityDescriptor {

    let channelId: String
    
    let lastActivity: Date
    
    let userId: String

}

struct ChannelActivityInfo {
    
    let channelId: String
    
    let lastActivity: Date
    
    let peding: Int
    
}
