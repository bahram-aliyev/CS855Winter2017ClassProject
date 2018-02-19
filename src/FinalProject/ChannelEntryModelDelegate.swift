//
//  ChannelEntryModelDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ChannelEntryModelDelegate {
    
    func channelPublished(channel:Channel)
    
    func channelPublishingFailed(cause: String)

}
