//
//  CommentActivityPublisher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class CommentActivityPublisher : ActivityPublisher {
    
    override func publish(activityLog: ActivityLog, completion: @escaping (Error?) -> Void) {
        
        guard let cmmtActvt = activityLog as? CommentActivityLog else {
            fatalError("'activityLog' must be type of CommentActivityLog")
        }
        
        let comment = Comment(text: cmmtActvt.comment, photoId: activityLog.photoId,
                              author: cmmtActvt.author, userId: activityLog.userId)
        
        transactionScope.execute(
            context: {
                self.photoAccessor.saveComment(comment: comment)
                self.activityLogAccessor.saveCommenActivity(log: cmmtActvt)
            },
            completion: { (error) in
                if let error = error {
                    completion(error)
                }
                else {
                    let publishCmmtRq = PublishCommentActivityRequest(data: cmmtActvt)
                    self.activityLogEndpoint.publishCommentActivity(publishRq: publishCmmtRq, rsClb: { completion($0.data) })
                }
        })
    }
    
}
