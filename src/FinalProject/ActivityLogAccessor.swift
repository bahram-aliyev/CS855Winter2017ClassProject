//
//  ActivityLogAccessor.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ActivityLogAccessor {
    
    func savePhotoActivity(log: PhotoActivityLog)
    
    func saveHashtagActivity(log: HashtagActivityLog)
    
    func saveCommenActivity(log: CommentActivityLog)
    
    func getActivityLog(clause: GetActivityLogClause) -> [ActivityLog]
    
}

struct GetActivityLogClause {
    
    let userId: String
    
    var channelId: String?
    
    var activityType: ActivityType?
}
