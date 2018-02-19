//
//  ActivityDispatcherFactory.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityDispatcherFactory {
    
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

    func getDispatcher(activityType: ActivityType) -> ActivityDispatcher {
        switch activityType {
            case .comment:
                return
                    CommentActivityDispatcher(userProvider: self.userProvider, photoAccessor: self.photoAccessor, activityLogAccessor: self.activityLogAccessor,
                                              imageConverter: self.imageConverter, transactionScope: self.transactionScope, channelAccessor: self.channelAccessor)
            case .photo:
                return
                    PhotoActivityDispatcher(userProvider: self.userProvider, photoAccessor: self.photoAccessor, activityLogAccessor: self.activityLogAccessor,
                                            imageConverter: self.imageConverter, transactionScope: self.transactionScope, channelAccessor: self.channelAccessor)
            case .hashtag:
                return
                    HashtagActivityDispatcher(userProvider: self.userProvider, photoAccessor: self.photoAccessor, activityLogAccessor: self.activityLogAccessor,
                                              imageConverter: self.imageConverter, transactionScope: self.transactionScope, channelAccessor: self.channelAccessor)
        }
    }
    
}
