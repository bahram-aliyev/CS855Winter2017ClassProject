//
//  ActivityLogModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityLogModel : ActivityListener {
    
    private var accessor: ActivityLogAccessor
    private var userProvider: UserProvider
    
    private var logItems: [ActivityLog]!
    
    var sourceChannel: ChannelInfo!
    
    private(set) var activityType: ActivityType!
    
    var activityLogReloaded: ((Void) -> Void)!
    
    init(userProvider: UserProvider, accessor: ActivityLogAccessor) {
        self.userProvider = userProvider
        self.accessor = accessor
        
        super.init()
        self.activityListenerCallback = self.reloadActivityLog
    }
    
    public func loadActivityLog(activityType: ActivityType? = nil) {
        self.activityType = activityType
        let clause = GetActivityLogClause(userId: self.userProvider.currentUser.id,
                                          channelId: self.sourceChannel?.id, activityType: activityType)
        self.logItems = self.accessor.getActivityLog(clause: clause)
    }
    
    public func reloadActivityLog() {
        let clause =
                GetActivityLogClause(userId: self.userProvider.currentUser.id,
                                        channelId: self.sourceChannel?.id, activityType: activityType)
        self.logItems = self.accessor.getActivityLog(clause: clause)
        activityLogReloaded?()
    }
    
    func itemsCount() -> Int {
        return self.logItems?.count ?? 0
    }
    
    func getItem(itemIndex: Int) -> ActivityLog {
        return self.logItems[itemIndex]
    }
    
    // MARK: Activity Listener
    
    override func getSubscriberTicket() -> String {
        return "ActivityLogModel"
    }
    
    override func beginListenActivityChanges() {
        if self.sourceChannel == nil {
            super.beginListenActivityChanges()
        }
    }
    
    override func stopListenActivityChanges() {
        if self.sourceChannel == nil {
            super.stopListenActivityChanges()
        }
    }
}
