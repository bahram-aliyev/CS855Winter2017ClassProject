//
//  ActivityLogEndpointFIR.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ActivityLogEndpointFIR : ActivityLogEndpoint {
    
    func publishPhotoActivity(publishRq: PublishPhotoActivityRequest, rsClb: @escaping (PublishResponse) -> Void) {
        let photoLog = publishRq.data
        
        var photoLogRaw = self.extractLogBaseRaw(photoLog)
        photoLogRaw["image"] = photoLog.image.base64EncodedString()
        photoLogRaw["hashtags"] = photoLog.hashtags

        self.pushActivityLog(rqId: publishRq.id, activityLog: photoLog, actvLogRaw: photoLogRaw, rsClb: rsClb)
    }
    
    func publishCommentActivity(publishRq: PublishCommentActivityRequest, rsClb: @escaping (PublishResponse) -> Void) {
        let commentLog = publishRq.data
        
        var commentLogRaw = self.extractLogBaseRaw(commentLog)
        commentLogRaw["comment"] = commentLog.comment
        
        self.pushActivityLog(rqId: publishRq.id, activityLog: commentLog, actvLogRaw: commentLogRaw, rsClb: rsClb)
    }
    
    func publishHashtagActivity(publishRq: PublishHashtagActivityRequest, rsClb: @escaping (PublishResponse) -> Void) {
        let hashtagLog = publishRq.data
        
        var hashtagLogRaw = self.extractLogBaseRaw(hashtagLog)
        hashtagLogRaw["hashtags"] = hashtagLog.hashtags
        
        self.pushActivityLog(rqId: publishRq.id, activityLog: hashtagLog, actvLogRaw: hashtagLogRaw, rsClb: rsClb)
    }
    
    private func pushActivityLog(rqId: String, activityLog: ActivityLog, actvLogRaw: [String : Any],
                                 rsClb: @escaping (PublishResponse) -> Void) {

        let chnlActivityLogRef =
                FIRDatabase.channels
                    .child(activityLog.channelId)
                        .child(FIRGlossary.activityLog)
                            .child(activityLog.id)
        
        chnlActivityLogRef.setValue(actvLogRaw) { (error, snapshot) in
            rsClb(PublishResponse(requestId: rqId, data: error))
        }
    }
    
    private func extractLogBaseRaw(_ activityLog: ActivityLog) -> [String : Any] {
        let logBaseRaw: [String : Any] = [
            "type"      : activityLog.type.rawValue,
            "photoId"   : activityLog.photoId,
            "channelId" : activityLog.channelId,
            "author"    : activityLog.author,
            "authorId"  : activityLog.userId,
            "entryDate" : activityLog.entryDate.timeIntervalSince1970
        ]
        
        return logBaseRaw
    }

}
