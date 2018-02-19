//
//  PhotoContentModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-30.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class PhotoContentModel {
    
    static let TopCommentsMaxCount = 5
    
    private let photoAccess: PhotoAccessor
    private let userProvider: UserProvider
    private let publisherFactory: ActivityPublisherFactory
    
    private(set) var photo: Photo!
    private(set) var coments: [Comment]!
    
    var delegate: PhotoContentModelDelegate?
    
    var publishActionResponder: ((Error?) -> Void)?
    
    init(photoAccess: PhotoAccessor, userProvider: UserProvider, publisherFactory: ActivityPublisherFactory) {
        self.photoAccess = photoAccess
        self.userProvider = userProvider
        self.publisherFactory = publisherFactory
    }
    
    var commentsCount: Int {
        get {
             let cmmtCount = self.coments?.count ?? 0
             return cmmtCount <= PhotoContentModel.TopCommentsMaxCount
                                    ? cmmtCount : PhotoContentModel.TopCommentsMaxCount
        }
    }
    
    func loadData(photoInfo: PhotoInfo) {
        self.photo = photoAccess.getPhoto(pdsc: PhotoDescriptor(photoId: photoInfo.id, userId: userProvider.currentUser.id))
        let clause = GetCommentsClause(photoId: photoInfo.id, userId: userProvider.currentUser.id,
                                       count: PhotoContentModel.TopCommentsMaxCount)
        
        self.coments = photoAccess.getComments(clause)
        self.delegate?.dataLoaded(bundle: (photo: self.photo, comments: self.coments))
    }
    
    func addComment(text: String) {
        let currentUser = userProvider.currentUser!
        let commentActivityLog =
                CommentActivityLog(userId: currentUser.id, channelId: self.photo.channelId,
                                   photoId:self.photo.id, comment: text, author: currentUser.name)
        self.publisherFactory
                .getPublisher(type: commentActivityLog.type)
                    .publish(activityLog: commentActivityLog, completion: {
                        self.publishActionResponder?($0)
                        self.delegate?.commentAdded()
                    })
    }
    
    func addHashTags(hashTags: String) {
        let currentUser = userProvider.currentUser!
        let hashtagActivityLog =
                HashtagActivityLog(userId: currentUser.id, channelId: self.photo.channelId,
                               photoId:self.photo.id, hashtags: hashTags, author: currentUser.name)
        
        self.publisherFactory
                .getPublisher(type: hashtagActivityLog.type)
                    .publish(activityLog: hashtagActivityLog, completion: {
                        self.publishActionResponder?($0)
                        self.delegate?.hashTagsUpdated()
                    })
    }
    
    func loadComments() {
        let clause = GetCommentsClause(photoId: self.photo.id, userId: self.userProvider.currentUser.id)
        self.coments = self.photoAccess.getComments(clause)
    }
    
    func getComment(index: Int) -> Comment {
        return self.coments[index]
    }

}
