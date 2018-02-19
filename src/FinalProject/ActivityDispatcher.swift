//
//  ActivityDispatcher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityDispatcher {
    
    let userProvider: UserProvider
    let photoAccessor: PhotoAccessor
    let activityLogAccessor: ActivityLogAccessor
    let imageConverter: ImageConverter
    let transactionScope: TransactionScope
    let channelAccessor: ChannelAccessor
    
    init(userProvider: UserProvider, photoAccessor: PhotoAccessor, activityLogAccessor: ActivityLogAccessor,
         imageConverter: ImageConverter, transactionScope: TransactionScope, channelAccessor: ChannelAccessor) {
        
        self.userProvider = userProvider
        self.photoAccessor = photoAccessor
        self.activityLogAccessor = activityLogAccessor
        self.imageConverter = imageConverter
        self.transactionScope = transactionScope
        self.channelAccessor = channelAccessor
    }
    
    func dispatch(activityLogRaw: NSDictionary, completion: @escaping (Error?) -> Void) {
        preconditionFailure("ActivityDispatcher.dispatch method must be overridden")
    }
    
}
