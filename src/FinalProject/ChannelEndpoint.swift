//
//  ChannelEndpoint.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ChannelEndpoint {
    
    func publishChannel(rq: PublishChannelRequest, _ rsClb: @escaping (Response) -> Void)
    
    func retrieveChannels(rq: RetrieveChannelsRequest, _ rsClb: @escaping (RetrieveChannelsResponse) -> Void)
    
    func retrieveChannelParticipants(rq: RetrieveParticipantsRequest, _ rsClb: @escaping (RetrieveParticipantsResponse) -> Void)

}

class PublishChannelRequest : Request<Channel> { }

class RetrieveChannelsRequest : Request<String> { }

class RetrieveChannelsResponse : ResponseData<[ChannelInfo]> { }

class RetrieveParticipantsRequest : Request<String> { }

class RetrieveParticipantsResponse : ResponseData<[User]> { }
