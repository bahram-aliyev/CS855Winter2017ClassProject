//
//  ActivityLogMediatorConfig.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-10.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ActivityLogMediatorConfig {
    
    var userProvider: UserProvider { get }
    
    var photoAccessor: PhotoAccessor { get }
    
    var activityLogAccessor: ActivityLogAccessor { get }
    
    var imageConverter: ImageConverter { get }
    
    var transactionScope: TransactionScope { get }
    
    var channelAccessor: ChannelAccessor { get }
    
    func registerActivityLogListener(_ listener: @escaping (NSDictionary?, Error?) -> Void)
    
    func registerActivityLogPublisher(channelId: String, listener: @escaping (NSDictionary?, Error?) -> Void)
    
    func unregisterFromLogListening(userId: String)
}
