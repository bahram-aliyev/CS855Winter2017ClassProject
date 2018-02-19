//
//  ActivityLogMediator.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-10.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityLogMediator {
    
    private(set) static var current: ActivityLogMediator!
    
    private var dispatcherFactory: ActivityDispatcherFactory!
    
    private var listeners: [String : (Error?) -> Void] = [String : (Error?) -> Void]()
    
    private var config: ActivityLogMediatorConfig
    
    static func configure(config: ActivityLogMediatorConfig) {
        let dispatcherFactory =
                ActivityDispatcherFactory(
                    userProvider: config.userProvider,
                    photoAccessor: config.photoAccessor,
                    activityLogAccessor: config.activityLogAccessor,
                    imageConverter: config.imageConverter,
                    transactionScope: config.transactionScope,
                    channelAccessor: config.channelAccessor)
        
        self.current = ActivityLogMediator(dispatcherFactory, config)
        self.current.listenActivityLog()
    }
    
    func subscribe(listener: (ticket: String, handler: (Error?) -> Void)) {
        listeners[listener.ticket] = listener.handler
    }
    
    func unsubscribe(ticket: String) {
        listeners.removeValue(forKey: ticket)
    }
    
    func registerPublisher(channelId: String) {
        config.registerActivityLogPublisher(channelId: channelId, listener: self.activityLogListener(rawActivityLog:error:))
    }
    
    func stopListening(userId: String) {
        self.config.unregisterFromLogListening(userId: userId)
        self.listeners = [String : (Error?) -> Void]()
    }
    
    private init(_ dispatcherFactory: ActivityDispatcherFactory, _ config: ActivityLogMediatorConfig) {
        self.dispatcherFactory = dispatcherFactory
        self.config = config
    }
    
    private func listenActivityLog() {
        self.config.registerActivityLogListener(self.activityLogListener(rawActivityLog:error:))
    }
    
    private func activityLogListener(rawActivityLog: NSDictionary?, error: Error?) {
        if let rawActivityLog = rawActivityLog,
            let activityTypeRaw = rawActivityLog["type"] as? String,
                let activityType = ActivityType(rawValue: activityTypeRaw) {
            
                let authorId = rawActivityLog["authorId"] as! String
                if authorId == dispatcherFactory.userProvider.currentUser.id {
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.listeners.values.forEach({
                            (listener) in listener(nil)
                        })
                    }

                    return
                }
            
                self.dispatcherFactory
                     .getDispatcher(activityType: activityType)
                        .dispatch(activityLogRaw: rawActivityLog, completion: {
                            (dispatchError) in
                            DispatchQueue.global(qos: .background).async {
                                self.listeners.values.forEach({
                                    (listener) in listener(dispatchError)
                                })
                            }
                        })
        }
    }
}
