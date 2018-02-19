//
//  ActivityLogMediatorConfigFIR.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-11.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ActivityLogMediatorConfigFIR : GenericActivityLogMediatorConfig {
    override func registerActivityLogListener(_ listener: @escaping (NSDictionary?, Error?) -> Void) {
        let userId = AppDomain.currentUser.id
        let userChannels = FIRDatabase.users.child(userId).child(FIRGlossary.channels)
        
        userChannels.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let channelsRaw = snapshot.value as? NSDictionary {
                for entry in channelsRaw {
                    let channelId = entry.key as! String
                    self.registerActivityLogPublisher(channelId: channelId, listener: listener)
                }
            }
        })
    }
    
    override func registerActivityLogPublisher(channelId: String, listener: @escaping (NSDictionary?, Error?) -> Void) {
            FIRDatabase.channels
                .child(channelId)
                    .child(FIRGlossary.activityLog)
                        .observe(.childAdded,
                                 with: { (snapshot) in
                                    let rawActivityLog = snapshot.value as? NSDictionary
                                    rawActivityLog?.setValue(snapshot.key, forKey: "id")
                                    listener(rawActivityLog, nil)
                        },
                                 withCancel: { (error) in
                                    listener(nil, error)
                        })
    }
    
    override func unregisterFromLogListening(userId: String) {
        let userChannels = FIRDatabase.users.child(userId).child(FIRGlossary.channels)
        
        userChannels.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let channelsRaw = snapshot.value as? NSDictionary {
                for entry in channelsRaw {
                    let channelId = entry.key as! String
                    FIRDatabase.channels
                        .child(channelId)
                            .child(FIRGlossary.activityLog).removeAllObservers()
                }
            }
        })
    }
}
