//
//  CommentActivityDispatcher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class CommentActivityDispatcher : ActivityDispatcher {
 
    override func dispatch(activityLogRaw: NSDictionary, completion: @escaping (Error?) -> Void) {
        if ActivityType.comment.rawValue != activityLogRaw["type"] as? String {
            fatalError("'activityLogRaw' is not match to CommentActivityLog")
        }
        
        let id = activityLogRaw["id"] as! String
        let channelId = activityLogRaw["channelId"] as! String
        let photoId = activityLogRaw["photoId"] as! String
        let author = activityLogRaw["author"] as! String
        let entryDate = Date(timeIntervalSince1970: TimeInterval(activityLogRaw["entryDate"] as! NSNumber))
        let text = activityLogRaw["comment"] as! String
        let currentUserId = self.userProvider.currentUser.id
        
        let comment = Comment(id: id, photoId: photoId, userId: currentUserId,
                              text: text, entryDate: entryDate, author: author)
        
        let commentActivityLog =
                CommentActivityLog(id: id, userId: currentUserId, channelId: channelId,
                                   photoId: photoId, comment: text, author: author, entryDate: entryDate)
        
        
        let channelActvtDsc = ChannelActivityDescriptor(channelId: channelId, lastActivity: entryDate, userId: currentUserId)
        let photoDsc = PhotoDescriptor(photoId: photoId, userId: currentUserId)
        
        transactionScope.execute(
            context: {
                self.photoAccessor.saveComment(comment: comment)
                self.activityLogAccessor.saveCommenActivity(log: commentActivityLog)
                self.photoAccessor.incrementPhotoPending(pdsc: photoDsc)
                self.channelAccessor.updateChannelActivity(actvtDsc: channelActvtDsc)
            },
            completion: {
                completion($0)
            }
        )
    }
}
