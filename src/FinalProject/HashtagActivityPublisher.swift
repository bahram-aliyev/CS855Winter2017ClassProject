//
//  HashTagActivityPublisher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class HashtagActivityPublisher : ActivityPublisher {
    
    override func publish(activityLog: ActivityLog, completion: @escaping (Error?) -> Void) {
    
        guard let htgActvt = activityLog as? HashtagActivityLog else {
            fatalError("'activityLog' must be type of CommentActivityLog")
        }
        
        let photoDsc = PhotoDescriptor(photoId: htgActvt.photoId, userId: htgActvt.userId)
        let htgsDsc = self.photoAccessor.getPhotoHashtags(pdsc: photoDsc)

        guard htgsDsc != nil else { return }
        
        let htgsBundle = HashtagUtil.mergeHashtags(currentHtgs: htgsDsc?.hashtags, newHtgs: htgActvt.hashtags)
        let updHtgsDsc = PhotoHastagsDescriptor(photoDsc: photoDsc, hashtags: htgsBundle.mergedHtgs)
        
        let unqHtgsActivityLog =
                HashtagActivityLog(id: htgActvt.id, userId: htgActvt.userId, channelId: htgActvt.channelId, photoId: htgActvt.photoId,
                                   hashtags: htgsBundle.uniqueHtgs, author: htgActvt.author, entryDate: htgActvt.entryDate)
        
        transactionScope.execute(
            context: {
                self.photoAccessor.setPhotoHashtags(hdsc: updHtgsDsc)
                self.activityLogAccessor.saveHashtagActivity(log: htgActvt)
        },
            completion: { (error) in
                if let error = error {
                    completion(error)
                }
                else {
                    let publishHtgRq = PublishHashtagActivityRequest(data: unqHtgsActivityLog)
                    self.activityLogEndpoint.publishHashtagActivity(publishRq: publishHtgRq, rsClb: { completion($0.data) })
                }
        })
    }
    
}
