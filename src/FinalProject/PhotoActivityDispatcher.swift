//
//  PhotoActivityDispatcher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class PhotoActivityDispatcher : ActivityDispatcher {

    override func dispatch(activityLogRaw: NSDictionary, completion: @escaping (Error?) -> Void) {
        if ActivityType.photo.rawValue != activityLogRaw["type"] as? String {
            fatalError("'activityLogRaw' is not match to PhotoActivityLog")
        }
        
        let id = activityLogRaw["id"] as! String
        let channelId = activityLogRaw["channelId"] as! String
        let photoId = activityLogRaw["photoId"] as! String
        let author = activityLogRaw["author"] as! String
        let entryDate = Date(timeIntervalSince1970: TimeInterval(activityLogRaw["entryDate"] as! NSNumber))
        let image = Data(base64Encoded: activityLogRaw["image"] as! String)!
        let thumbnail = self.imageConverter.thumbnail(rawImage: image)
        let hashtags = activityLogRaw["hashtags"] as? String
        let currentUserId = self.userProvider.currentUser.id
        
        let photo =
                Photo(id: photoId, channelId: channelId, userId: currentUserId, author: author,
                      entryDate: entryDate, rawImage: image, thumbnail: thumbnail,hashTags: hashtags)
        
        let photoActivityLog =
                PhotoActivityLog(id: id, userId: currentUserId, channelId: channelId,
                                 photoId: photoId, image: thumbnail, author: author, entryDate: entryDate)
        
        let channelActvtDsc = ChannelActivityDescriptor(channelId: channelId, lastActivity: entryDate, userId: currentUserId)
        
        transactionScope.execute(
            context: {
                self.photoAccessor.savePhoto(photo: photo)
                self.activityLogAccessor.savePhotoActivity(log: photoActivityLog)
                self.channelAccessor.updateChannelActivity(actvtDsc: channelActvtDsc)
            },
            completion: {
                completion($0)
            }
        )
    }

}
