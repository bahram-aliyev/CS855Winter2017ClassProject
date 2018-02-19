//
//  ChannelEndpointFIR.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-07.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import Firebase

class ChannelEndpointFIR : ChannelEndpoint {
    
    func publishChannel(rq: PublishChannelRequest, _ rsClb: @escaping (Response) -> Void) {
        
        let channel = rq.data
        
        var rawChannelInfo = [String:Any]()
        rawChannelInfo["name"] = channel.name
        rawChannelInfo["author"] = channel.author
        rawChannelInfo["thumbnail"] = channel.thumbnail.base64EncodedString()
        rawChannelInfo["entryDate"] = channel.entryDate.timeIntervalSince1970
        
        var participants = channel.participants
        participants.append(AppDomain.currentUser)
        
        let channelFIR = FIRDatabase.channels.child(channel.id)
        channelFIR.setValue(rawChannelInfo) {
            
            (error, _) in
            if let error = error {
                rsClb(Response(requestId: rq.id, status: .failure(error.localizedDescription)))
                return
            }
            
            let participantsFIR = channelFIR.child(FIRGlossary.participants)
            participants.forEach {
                (participant) in
                let rawParticipant = [
                    "name" : participant.name,
                    "email": participant.email
                ]
                
                let currentUserId = AppDomain.currentUser.id
                participantsFIR.child(participant.id).setValue(rawParticipant) {
                    (error, _) in
                    if error == nil {
                        let userChannel = FIRDatabase.users
                            .child(participant.id)
                            .child(FIRGlossary.channels).child(channel.id)
                        
                        if participant.id != currentUserId {
                            userChannel.setValue(rawChannelInfo)
                        }
                        else {
                            userChannel.setValue(rawChannelInfo) {
                                (error, _) in
                                if let error = error {
                                    rsClb(Response(requestId: rq.id, status: .failure(error.localizedDescription)))
                                    return
                                }
                                rsClb(Response(requestId: rq.id, status: .success))
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func retrieveChannels(rq: RetrieveChannelsRequest, _ rsClb: @escaping (RetrieveChannelsResponse) -> Void) {
        let userId = rq.data
        let userChannels = FIRDatabase.users.child(userId).child(FIRGlossary.channels)
        
        userChannels.observeSingleEvent(of: .value, with: {
            (snapshot) in
            var channels = [ChannelInfo]()
            
            if let channelsRaw = snapshot.value as? NSDictionary {
                for entry in channelsRaw {
                    let channelId = entry.key as! String
                    if let channelRaw = entry.value as? NSDictionary {
                        let name = channelRaw["name"] as! String
                        //let author = channelRaw["author"] as! String
                        
                        var thumbnail: Data?
                        if let thumbnailRaw = channelRaw["thumbnail"] as? String {
                            thumbnail = Data(base64Encoded: thumbnailRaw)
                        }
                        
                        let entryDate = Date(timeIntervalSince1970: TimeInterval(channelRaw["entryDate"] as! NSNumber))
                        
                        let channel = ChannelInfo(id: channelId, name: name, lastActivity: entryDate,
                                                  pending: 0, thumbnail: thumbnail)
                        channels.append(channel)
                    }
                }
            }
            rsClb(RetrieveChannelsResponse(requestId: rq.id, data: channels))
        }, withCancel: {
            (error) in
            rsClb(RetrieveChannelsResponse(requestId: rq.id, failureCause: error.localizedDescription))
        })
    }
    
    func retrieveChannelParticipants(rq: RetrieveParticipantsRequest, _ rsClb: @escaping (RetrieveParticipantsResponse) -> Void) {
            let channelParticipantsFIR = FIRDatabase.channels.child(rq.data).child(FIRGlossary.participants)
            channelParticipantsFIR.observeSingleEvent(of: .value, with: {
                (snapshot) in
                
                var participants = [User]()

                if let participantsRaw = snapshot.value as? NSDictionary {
                    for entry in participantsRaw {
                        if let participantRaw = entry.value as? NSDictionary {
                            participants.append(
                                User(id: entry.key as! String,
                                     email: participantRaw["email"] as! String,
                                     name: participantRaw["name"] as! String))
                        }
                    }
                }
                rsClb(RetrieveParticipantsResponse(requestId: rq.id, data: participants))
            }, withCancel: {
                (error) in
                rsClb(RetrieveParticipantsResponse(requestId: rq.id, failureCause: error.localizedDescription))
            })
    }
}
