//
//  ActivityPublisherFactory.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityPublisherFactory {
    
    let activityLogEndpoint: ActivityLogEndpoint
    let photoAccessor: PhotoAccessor
    let activityLogAccessor: ActivityLogAccessor
    let transactionScope: TransactionScope
    let imageConverter: ImageConverter
    let imageRecognizer: ImageRecognizer
    
    init(activityLogEndpoint: ActivityLogEndpoint, photoAccessor: PhotoAccessor,
         activityLogAccessor : ActivityLogAccessor, transactionScope: TransactionScope,
         imageConverter: ImageConverter, imageRecognizer: ImageRecognizer) {
        
        self.activityLogEndpoint = activityLogEndpoint
        self.photoAccessor = photoAccessor
        self.activityLogAccessor = activityLogAccessor
        self.transactionScope = transactionScope
        self.imageConverter = imageConverter
        self.imageRecognizer = imageRecognizer
    }
    
    func getPublisher(type: ActivityType) -> ActivityPublisher {
        switch type {
        case .comment:
            return
                CommentActivityPublisher(activityLogEndpoint: self.activityLogEndpoint, photoAccessor: self.photoAccessor,
                                         activityLogAccessor: self.activityLogAccessor, transactionScope: self.transactionScope)
        case .photo:
            return
                PhotoActivityPublisher(activityLogEndpoint: self.activityLogEndpoint,photoAccessor: self.photoAccessor,
                                       activityLogAccessor: self.activityLogAccessor, transactionScope: self.transactionScope,
                                       imageConverter: self.imageConverter, imageRecognizer: self.imageRecognizer)
        case .hashtag:
            return
                HashtagActivityPublisher(activityLogEndpoint: self.activityLogEndpoint, photoAccessor: self.photoAccessor,
                                         activityLogAccessor: self.activityLogAccessor, transactionScope: self.transactionScope)
        }
    }
}
