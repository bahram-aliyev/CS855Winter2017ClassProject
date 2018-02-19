//
//  AppDomainConfigSQLite.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-07.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import SQLite
import os.log

class AppDomainConfigSQLite : AppDomainConfig {

    func configure() {
        
        if SQLiteDb.isCreated { return }
        
        do {
            
            let db = SQLiteDb.instance
            
            try db.run(ActivityLogTable.table
                .create(ifNotExists: true,
                        block: { (t) in
                            t.column(ActivityLogTable.id1)
                            t.column(ActivityLogTable.userId2)
                            t.column(ActivityLogTable.channelId3)
                            t.column(ActivityLogTable.author4)
                            t.column(ActivityLogTable.type5)
                            t.column(ActivityLogTable.photoId6)
                            t.column(ActivityLogTable.thumbnail7)
                            t.column(ActivityLogTable.comment8)
                            t.column(ActivityLogTable.hashtags9)
                            t.column(ActivityLogTable.entryDate10)
                            t.unique(ActivityLogTable.id1, ActivityLogTable.userId2)
                }))
            
            try db.run(ChannelNotifTable.table
                .create(ifNotExists: true,
                        block: { (t) in
                            t.column(ChannelNotifTable.channelId1)
                            t.column(ChannelNotifTable.userId2)
                            t.column(ChannelNotifTable.pendign3, defaultValue: 0)
                            t.column(ChannelNotifTable.lastActivity4)
                            t.unique(ChannelNotifTable.channelId1, ChannelNotifTable.userId2)
                }))
            
            try db.run(PhotosTable.table
                .create(ifNotExists: true,
                        block: { (t) in
                            t.column(PhotosTable.id1, primaryKey: true)
                            t.column(PhotosTable.userId2)
                            t.column(PhotosTable.channelId3)
                            t.column(PhotosTable.thumbnail4)
                            t.column(PhotosTable.rawImage5)
                            t.column(PhotosTable.hashtags6)
                            t.column(PhotosTable.author7)
                            t.column(PhotosTable.entryDate8)
                            t.column(PhotosTable.pendign9, defaultValue: 0)
                            t.unique(PhotosTable.id1, PhotosTable.userId2)
                }))
            
            try db.run(CommentsTable.table
                .create(ifNotExists: true,
                        block: { (t) in
                            t.column(CommentsTable.id1, primaryKey: true)
                            t.column(CommentsTable.userId2)
                            t.column(CommentsTable.photoId3)
                            t.column(CommentsTable.comment4)
                            t.column(CommentsTable.author5)
                            t.column(CommentsTable.entryDate6)
                            t.unique(CommentsTable.id1, CommentsTable.userId2)
                }))
        }
        catch {
            os_log("DB initialization failed.", log: OSLog.default, type: .error)
        }
    }
}
