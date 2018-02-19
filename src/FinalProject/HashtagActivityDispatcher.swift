//
//  HashtagActivityDispatcher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class HashtagActivityDispatcher : ActivityDispatcher {
    
    override func dispatch(activityLogRaw: NSDictionary, completion: @escaping (Error?) -> Void) {
        if ActivityType.hashtag.rawValue != activityLogRaw["type"] as? String {
            fatalError("'activityLogRaw' is not match to CommentActivityLog")
        }
        
        let id = activityLogRaw["id"] as! String
        let channelId = activityLogRaw["channelId"] as! String
        let photoId = activityLogRaw["photoId"] as! String
        let author = activityLogRaw["author"] as! String
        let entryDate = Date(timeIntervalSince1970: TimeInterval(activityLogRaw["entryDate"] as! NSNumber))
        let hashtags = activityLogRaw["hashtags"] as! String
        let currentUserId = self.userProvider.currentUser.id
        
        let phtHtgsDsc =
                self.photoAccessor.getPhotoHashtags(pdsc: PhotoDescriptor(photoId: photoId, userId: currentUserId))
        
        guard phtHtgsDsc != nil else { return }
        
        let mergedHtgs =
                HashtagUtil.mergeHashtags(currentHtgs: phtHtgsDsc?.hashtags, newHtgs: hashtags).mergedHtgs
        
        let htgActvityLog =
                HashtagActivityLog(id: id, userId: currentUserId, channelId: channelId, photoId: photoId,
                                   hashtags: hashtags, author: author, entryDate: entryDate)
        
        let updPhtHtgsDsc = PhotoHastagsDescriptor(photoDsc: phtHtgsDsc!.photoDsc, hashtags: mergedHtgs)
        let channelActvtDsc = ChannelActivityDescriptor(channelId: channelId, lastActivity: entryDate, userId: currentUserId)
        
        transactionScope.execute(
            context: {
                self.photoAccessor.setPhotoHashtags(hdsc: updPhtHtgsDsc)
                self.activityLogAccessor.saveHashtagActivity(log: htgActvityLog)
                self.photoAccessor.incrementPhotoPending(pdsc: updPhtHtgsDsc.photoDsc)
                self.channelAccessor.updateChannelActivity(actvtDsc: channelActvtDsc)
            },
            completion: {
                completion($0)
            }
        )
    }
}
