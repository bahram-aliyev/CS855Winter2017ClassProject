//
//  ChannelsListModelDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-13.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ChannelsListModelDelegate : PhotoPublisherDelegate {

    func channelsLoaded()
    
    func channlesLoadingFailed(cause: String)

}
