//
//  ActivityListener.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ActivityListener {
    
    func getSubscriberTicket() -> String {
            preconditionFailure("ActiviPublisher.publish method must be overridden")
    }
    
    var activityListenerCallback: ((Void) -> Void)!
    
    func beginListenActivityChanges() {
        ActivityLogMediator.current
            .subscribe(listener: (self.getSubscriberTicket(), {_ in self.activityListenerCallback?() }))
    }
    
    func stopListenActivityChanges() {
        ActivityLogMediator.current.unsubscribe(ticket: self.getSubscriberTicket())
    }
    
    deinit {
        self.stopListenActivityChanges()
    }
}
