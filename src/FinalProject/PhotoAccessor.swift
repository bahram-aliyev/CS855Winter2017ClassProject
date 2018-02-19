//
//  PhotoAccessor.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol PhotoAccessor {
    
    func getPhotos(_ clause: GetPhotosClause) -> [PhotoInfo]
    
    func savePhoto(photo: Photo)
    
    func getPhoto(pdsc: PhotoDescriptor) -> Photo!
    
    func saveComment(comment: Comment)
    
    func getComments(_ clause: GetCommentsClause) -> [Comment]

    func incrementPhotoPending(pdsc: PhotoDescriptor)
    
    func clearPhotoPending(pdsc: PhotoDescriptor)
    
    func setPhotoHashtags(hdsc: PhotoHastagsDescriptor)
    
    func getPhotoHashtags(pdsc: PhotoDescriptor) -> PhotoHastagsDescriptor!

}

struct GetPhotosClause {
    
    let userId: String
    
    let channelId: String!
    
    let hashtags: [String]!
    
    init(userId: String, channelId: String!, hashtags: [String]! = nil) {
        self.userId = userId
        self.channelId = channelId
        self.hashtags = hashtags
    }

}

struct GetCommentsClause {
    
    let photoId: String
    
    let userId: String
    
    let count: Int!
    
    init(photoId: String, userId: String, count: Int! = nil) {
        self.photoId = photoId
        self.userId = userId
        self.count = count
    }

}

struct PhotoDescriptor {
    
    let photoId: String
    
    let userId: String
    
}

struct PhotoHastagsDescriptor {
    
    let photoDsc: PhotoDescriptor
    
    let hashtags: String!
}

