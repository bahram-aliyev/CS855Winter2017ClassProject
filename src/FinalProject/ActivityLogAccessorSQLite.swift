//
//  ActivityLogAccessorSQLite.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite

class ActivityLogAccessorSQLite : ActivityLogAccessor {
    
    func savePhotoActivity(log: PhotoActivityLog) {
        let savePhtActQr =
                ActivityLogTable.table
                    .insert(
                        ActivityLogTable.id1 <- log.id,
                        ActivityLogTable.userId2 <- log.userId,
                        ActivityLogTable.channelId3 <- log.channelId,
                        ActivityLogTable.author4 <- log.author,
                        ActivityLogTable.type5 <- log.type.rawValue,
                        ActivityLogTable.photoId6 <- log.photoId,
                        ActivityLogTable.thumbnail7 <- log.image,
                        ActivityLogTable.entryDate10 <- log.entryDate
                    )

        do {
            _ = try SQLiteDb.instance.run(savePhtActQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func saveHashtagActivity(log: HashtagActivityLog) {
        let saveHstgActQr =
                ActivityLogTable.table
                    .insert(
                        ActivityLogTable.id1 <- log.id,
                        ActivityLogTable.userId2 <- log.userId,
                        ActivityLogTable.channelId3 <- log.channelId,
                        ActivityLogTable.author4 <- log.author,
                        ActivityLogTable.type5 <- log.type.rawValue,
                        ActivityLogTable.photoId6 <- log.photoId,
                        ActivityLogTable.hashtags9 <- log.hashtags,
                        ActivityLogTable.entryDate10 <- log.entryDate
                    )

        do {
            _ = try SQLiteDb.instance.run(saveHstgActQr)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func saveCommenActivity(log: CommentActivityLog) {
        let saveCmmyActQr =
                ActivityLogTable.table
                    .insert(
                        ActivityLogTable.id1 <- log.id,
                        ActivityLogTable.userId2 <- log.userId,
                        ActivityLogTable.channelId3 <- log.channelId,
                        ActivityLogTable.author4 <- log.author,
                        ActivityLogTable.type5 <- log.type.rawValue,
                        ActivityLogTable.photoId6 <- log.photoId,
                        ActivityLogTable.comment8 <- log.comment,
                        ActivityLogTable.entryDate10 <- log.entryDate
                    )

        do {
            _ = try SQLiteDb.instance.run(saveCmmyActQr)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getActivityLog(clause: GetActivityLogClause) -> [ActivityLog] {
        var getActvLogQr =
                ActivityLogTable.table.filter(ActivityLogTable.userId2 == clause.userId)
        
        getActvLogQr =
            clause.channelId != nil ? getActvLogQr.filter(ActivityLogTable.channelId3 == clause.channelId!)
                                    : getActvLogQr
        
        getActvLogQr =
            clause.activityType != nil ? getActvLogQr.filter(ActivityLogTable.type5 == clause.activityType!.rawValue)
                                       : getActvLogQr
        
        getActvLogQr = getActvLogQr.order(ActivityLogTable.entryDate10.desc)
        
        var activityLog = [ActivityLog]()
        
        if let actvSeq = try? SQLiteDb.instance.prepare(getActvLogQr) {
            for actvRow in actvSeq {
                activityLog.append(activityLogFactoryMethod(logRow: actvRow))
            }
        }
        
        return activityLog
    }
    
    private func activityLogFactoryMethod(logRow: Row) -> ActivityLog {
        let id = logRow.get(ActivityLogTable.id1)
        let userId = logRow.get(ActivityLogTable.userId2)
        let channelId = logRow.get(ActivityLogTable.channelId3)
        let photoId = logRow.get(ActivityLogTable.photoId6)
        let author = logRow.get(ActivityLogTable.author4)
        let entryDate = logRow.get(ActivityLogTable.entryDate10)
        
        let type = ActivityType(rawValue: logRow.get(ActivityLogTable.type5))!
        switch type {
            case .comment:
                return
                    CommentActivityLog(id: id, userId: userId, channelId: channelId, photoId: photoId,
                                       comment: logRow.get(ActivityLogTable.comment8)!, author: author, entryDate: entryDate)
            case .photo:
                return
                    PhotoActivityLog(id: id, userId: userId, channelId: channelId, photoId: photoId,
                                     image: logRow.get(ActivityLogTable.thumbnail7)!, author: author, entryDate: entryDate)
            case .hashtag:
                return
                    HashtagActivityLog(id: id, userId: userId, channelId: channelId, photoId: photoId,
                                       hashtags: logRow.get(ActivityLogTable.hashtags9)!, author: author, entryDate: entryDate)
        }
        
    }

}
