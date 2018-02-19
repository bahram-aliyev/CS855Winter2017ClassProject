//
//  ActivityPublisher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityPublisher {
    
    let photoAccessor: PhotoAccessor
    let activityLogAccessor: ActivityLogAccessor
    let transactionScope: TransactionScope
    let activityLogEndpoint: ActivityLogEndpoint
    
    init(activityLogEndpoint: ActivityLogEndpoint, photoAccessor: PhotoAccessor,
         activityLogAccessor : ActivityLogAccessor, transactionScope: TransactionScope) {
    
        self.activityLogEndpoint = activityLogEndpoint
        self.photoAccessor = photoAccessor
        self.activityLogAccessor = activityLogAccessor
        self.transactionScope = transactionScope
    }
    
    func publish(activityLog: ActivityLog, completion: @escaping (Error?) -> Void) {
        preconditionFailure("ActiviPublisher.publish method must be overridden")
    }
}
