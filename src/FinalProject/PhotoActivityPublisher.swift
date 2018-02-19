//
//  PhotoActivityPublisher.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class PhotoActivityPublisher : ActivityPublisher {
    
    private let imageConverter: ImageConverter
    private let imageRecognizer: ImageRecognizer
    
    
    init(activityLogEndpoint: ActivityLogEndpoint, photoAccessor: PhotoAccessor,
         activityLogAccessor: ActivityLogAccessor, transactionScope: TransactionScope,
         imageConverter: ImageConverter, imageRecognizer: ImageRecognizer) {
        
        self.imageConverter = imageConverter
        self.imageRecognizer = imageRecognizer
        
        super.init(activityLogEndpoint: activityLogEndpoint, photoAccessor: photoAccessor,
                   activityLogAccessor: activityLogAccessor, transactionScope: transactionScope)
    }
    
    override func publish(activityLog: ActivityLog, completion: @escaping (Error?) -> Void) {
        
        guard let phtActvt = activityLog as? PhotoActivityLog else {
            fatalError("'activityLog' must be type of PhotoActivityLog")
        }
        
        let thumbnail = imageConverter.thumbnail(rawImage: phtActvt.image)
        
        imageRecognizer.recognize(rawImg: phtActvt.image) { (error, labels) in
            
            if let labels = labels {
                
                var htgsArr = [String]()
                for lbl in labels {
                    htgsArr.append(lbl.components(separatedBy: .whitespaces).joined())
                }
                
                phtActvt.hashtags =
                    (htgsArr.count != 0) ? HashtagUtil.joinHashtags(htgsArr: htgsArr) : nil
            }
            
            let localPhtActvt =
                PhotoActivityLog(id: phtActvt.id, userId: phtActvt.userId,channelId: phtActvt.channelId,
                                 photoId: phtActvt.photoId, image: thumbnail, author: phtActvt.author,
                                 entryDate: phtActvt.entryDate)
            
            let photo =
                Photo(id: phtActvt.photoId, channelId: phtActvt.channelId, userId: phtActvt.userId, author: phtActvt.author,
                      entryDate: phtActvt.entryDate, rawImage: phtActvt.image, thumbnail: thumbnail, hashTags: phtActvt.hashtags)
            
            self.transactionScope.execute(
                context: {
                    self.photoAccessor.savePhoto(photo: photo)
                    self.activityLogAccessor.savePhotoActivity(log: localPhtActvt)
            },
                completion: { (error) in
                    if let error = error {
                        completion(error)
                    }
                    else {
                        let publishPhtRq = PublishPhotoActivityRequest(data: phtActvt)
                        self.activityLogEndpoint.publishPhotoActivity(publishRq: publishPhtRq, rsClb: { completion($0.data) })
                    }
            })
        }
    }
}
