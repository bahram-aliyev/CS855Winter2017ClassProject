//
//  ActivityLogEndpoint.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ActivityLogEndpoint {
    
    func publishPhotoActivity(publishRq: PublishPhotoActivityRequest, rsClb: @escaping (PublishResponse) -> Void)
    
    func publishCommentActivity(publishRq: PublishCommentActivityRequest, rsClb: @escaping (PublishResponse) -> Void)
    
    func publishHashtagActivity(publishRq: PublishHashtagActivityRequest, rsClb: @escaping(PublishResponse) -> Void)
    
}

class PublishPhotoActivityRequest : Request<PhotoActivityLog> { }

class PublishCommentActivityRequest : Request<CommentActivityLog> { }

class PublishHashtagActivityRequest : Request<HashtagActivityLog> { }

class PublishResponse : ResponseData<Error> { }
