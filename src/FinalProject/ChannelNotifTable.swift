//
//  ChannelNotifications.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

final class ChannelNotifTable {
    
    static let table = Table("channel_notifications")
    
    static let channelId1 = Expression<String>(clmns.channelId)
    
    static let userId2 = Expression<String>(clmns.userId)
    
    static let pendign3 = Expression<Int>(clmns.pendign)
    
    static let lastActivity4 = Expression<Date>(clmns.lastActivity)
    
    private init() { }
    
}
