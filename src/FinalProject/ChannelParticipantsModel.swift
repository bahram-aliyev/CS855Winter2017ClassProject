//
//  ChannelParticipantsMode.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-11.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ChannelParticipantsModel {
    
    private let channelEndpoint: ChannelEndpoint
    private let userProvider: UserProvider
    
    var participantsLoadFinished: ((_ error: String?)->Void)!
    
    private(set) var participants: [User]!
    
    init(channelEndpoint: ChannelEndpoint, userProvider: UserProvider) {
        self.channelEndpoint = channelEndpoint
        self.userProvider = userProvider
    }
    
    func loadParticipants(channelInfo: ChannelInfo) {
        let retrieveRq = RetrieveParticipantsRequest(data: channelInfo.id)
        self.channelEndpoint.retrieveChannelParticipants(rq: retrieveRq) {
            (rs) in
                if case let ResponseStatus.failure(cause) = rs.status {
                    self.participantsLoadFinished(cause)
                }
                else {
                    self.participants = rs.data
                    self.participantsLoadFinished(nil)
            }
        }
    }
    
    var itemsCount: Int {
        get {
            return participants?.count ?? 0
        }
    }
    
    func getItem(index: Int) -> User {
        return self.participants[index]
    }
    
    func isCurrentUser(participant: User) -> Bool {
        return participant.id == self.userProvider.currentUser.id
    }
}
