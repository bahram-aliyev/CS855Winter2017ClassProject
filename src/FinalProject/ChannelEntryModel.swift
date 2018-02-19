//
//  ChannelEntryModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ChannelEntryModel {

    var channelName: String!
    var channelThumbnail: Data!
    var contacts: [User]!
    
    var delegate: ChannelEntryModelDelegate!
    
    private let endpoint: ChannelEndpoint
    private let userProvider: UserProvider
    private let activityLogMediator: ActivityLogMediator
    
    init(channelEndpoint: ChannelEndpoint, userProvider: UserProvider, activityLogMediator: ActivityLogMediator) {
        self.endpoint = channelEndpoint
        self.userProvider = userProvider
        self.activityLogMediator = activityLogMediator
    }
    
    func saveChannel() {
        let channel = Channel(name: self.channelName, author: self.userProvider.currentUser.name)
        channel.thumbnail = channelThumbnail
        contacts?.forEach({ channel.addParticipant(contact: $0) })

        self.endpoint.publishChannel(rq: PublishChannelRequest(data: channel)) {
            if case let .failure(cause) = $0.status {
                self.delegate?.channelPublishingFailed(cause: cause)
            }
            else {
                self.activityLogMediator.registerPublisher(channelId: channel.id)
                self.delegate?.channelPublished(channel: channel)
            }
        }
    }
}
