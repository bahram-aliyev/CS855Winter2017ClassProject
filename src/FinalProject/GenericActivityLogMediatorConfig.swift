//
//  GenericActivityLogMediatorConfig.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-11.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class GenericActivityLogMediatorConfig : ActivityLogMediatorConfig {
    
    var userProvider: UserProvider {
        get {
            return Models.userProvider
        }
    }
    
    var photoAccessor: PhotoAccessor {
        get {
            return Models.photoAccessor
        }
    }
    
    var activityLogAccessor: ActivityLogAccessor {
        get {
            return Models.activityLogAccessor
        }
    }
    
    var imageConverter: ImageConverter {
        get {
            return Models.imageConverter
        }
    }
    
    var transactionScope: TransactionScope {
        get {
            return Models.transactionScope
        }
    }
    
    var channelAccessor: ChannelAccessor {
        get {
            return Models.channelAccessor
        }
    }
    
    func registerActivityLogListener(_ listener: @escaping (NSDictionary?, Error?) -> Void) {
        preconditionFailure("GenericActivityLogMediatorConfig.registerActivityLogListener method must be overridden")
    }

    func registerActivityLogPublisher(channelId: String, listener: @escaping (NSDictionary?, Error?) -> Void) {
        preconditionFailure("registerActivityLogPublisher method must be overridden")
    }
    
    func unregisterFromLogListening(userId: String) {
        preconditionFailure("unregisterFromLogListening method must be overridden")
    }
}
