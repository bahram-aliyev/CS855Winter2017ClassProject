//
//  ChannelsListModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ChannelsListModel /*: ActivityListener*/ {
    
    private let userProvider: UserProvider
    private let endpoint: ChannelEndpoint
    private let publisherFactory: ActivityPublisherFactory
    private let channelAccessor: ChannelAccessor
   
    private var _items: [ChannelInfo]!
    private var _filteredItems: [ChannelInfo]!
    
    var items: [ChannelInfo]! {
        get {
            return self._filteredItems ?? self._items
        }
    }
    
    var delegate: ChannelsListModelDelegate?
    
    init(endpoint: ChannelEndpoint, userProvider: UserProvider,
         publisherFactory: ActivityPublisherFactory, channelAccessor: ChannelAccessor) {
        self.endpoint = endpoint
        self.userProvider = userProvider
        self.publisherFactory = publisherFactory
        self.channelAccessor = channelAccessor
        
//        super.init()
//        self.activityListenerCallback = self.reloadChannelsPendings
    }
    
    var itemsCount: Int {
        get {
            return items?.count ?? 0
        }
    }
    
    func loadItems() {

        let chnlPndngsMap = self.getChannelsPengingsMap()
        
        let retrieveRq = RetrieveChannelsRequest(data: self.userProvider.currentUser.id)
        self.endpoint.retrieveChannels(rq: retrieveRq) { (rs) in
            if case let .failure(cause) = rs.status {
                self.delegate?.channlesLoadingFailed(cause: cause)
            }
            else {
                rs.data.forEach({
                    if let actvtDsc = chnlPndngsMap[$0.id] {
                        $0.lastActivity = actvtDsc.lastActivity
                        $0.pending = actvtDsc.peding
                    }
                })
                self._items = rs.data
                self.delegate?.channelsLoaded()
            }
        }
    }
    
    func clearChannelPending(channelInfo: ChannelInfo) {
        channelInfo.pending = 0
        let channelDescriptor = ChannelDescriptor(channelId: channelInfo.id, userId:
                                                  self.userProvider.currentUser.id)
        self.channelAccessor
            .clearChannelPending(cdsc: channelDescriptor)
    }
    
    private func reloadChannelsPendings() {
        let chnlPndngsMap = self.getChannelsPengingsMap()
        self._items?.forEach({
            if let actvtDsc = chnlPndngsMap[$0.id] {
                $0.lastActivity = actvtDsc.lastActivity
                $0.pending = actvtDsc.peding
            }
        })
        self.delegate?.channelsLoaded()
    }
    
    private func getChannelsPengingsMap() -> [String: (lastActivity: Date, peding: Int)] {
        let userId = self.userProvider.currentUser.id
        let channelPendings = self.channelAccessor.getChannelPendings(userId: userId)
        
        var chnlPndngsMap = [String: (lastActivity: Date, peding: Int)]()
        channelPendings.forEach({ chnlPndngsMap[$0.channelId] = (lastActivity: $0.lastActivity, peding: $0.peding) })
        
        return chnlPndngsMap
    }
    
    func publishPhoto(bundle: (channel: ChannelInfo, rawPhoto: Data)) {
        let photoActicityLog =
                PhotoActivityLog(userId: self.userProvider.currentUser.id, channelId: bundle.channel.id,
                                 image: bundle.rawPhoto, author: self.userProvider.currentUser.name)
        self.publisherFactory
              .getPublisher(type: photoActicityLog.type)
                .publish(activityLog: photoActicityLog,
                         completion: { self.delegate?.photoPublisingCompleted(error: $0) })
    }
    
    func filerChannels(filter: String) {
        let filter = filter.trimmingCharacters(in: .whitespaces)
        
        if !filter.isEmpty {
            self._filteredItems = self._items.filter({ $0.name.hasPrefix(filter) })
        }
        else {
            self._filteredItems = nil
        }
        self.delegate?.channelsLoaded()
    }
    
    func logout() {
        self.userProvider.logout()
    }
    
    // MARK: ActivityListener
    
//    override func getSubscriberTicket() -> String {
//        return "ChannelsListModel"
//    }
    
}
