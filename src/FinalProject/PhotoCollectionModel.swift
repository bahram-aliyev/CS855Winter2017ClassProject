//
//  PhotoReelModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class PhotoCollectionModel : ActivityListener {
    
    private let accessor: PhotoAccessor
    private let userProvider: UserProvider
    private let publisherFactory: ActivityPublisherFactory
    
    var sourceChannel: ChannelInfo!
    
    private var photos: [PhotoInfo]!
    
    private var searchedClause: String = ""
    
    var delegate: PhotoCollectionModelDelegate!
    
    init(userProvider: UserProvider, accessor: PhotoAccessor, publisherFactory: ActivityPublisherFactory) {
        self.accessor = accessor
        self.userProvider = userProvider
        self.publisherFactory = publisherFactory
        
        super.init()
        self.activityListenerCallback = self.reloadPhotos
    }
    
    func loadPhotos() {
        let getClause = GetPhotosClause(userId: userProvider.currentUser.id, channelId: self.sourceChannel?.id)
        self.photos = self.accessor.getPhotos(getClause);
    }
    
    func reloadPhotos() {
        self.loadPhotos()
        self.delegate?.photosReloaded()
    }
    
    var itemsCount: Int {
        return self.photos?.count ?? 0
    }
    
    func getItem(itemIndex: Int) -> PhotoInfo {
        return self.photos[itemIndex]
    }
    
    func publishPhoto(rawImage: Data) {
        let photoActicityLog =
            PhotoActivityLog(userId: self.userProvider.currentUser.id, channelId: self.sourceChannel.id,
                             image: rawImage, author: self.userProvider.currentUser.name)
        self.publisherFactory
            .getPublisher(type: photoActicityLog.type)
            .publish(activityLog: photoActicityLog,
                     completion: { self.delegate?.photoPublisingCompleted(error: $0) })
    }
    
    func searchByTags(searchClause: String) {
        let newClause = searchClause.trimmingCharacters(in: .whitespaces)
        if self.searchedClause != newClause {
           self.searchedClause = newClause
            
            let hashtagsTokens =
                searchClause.components(separatedBy: .whitespaces)
                                .map({$0.trimmingCharacters(in: .whitespaces)})
                                    .filter({ !$0.isEmpty })
            
            let getPhtCls = GetPhotosClause(userId: userProvider.currentUser.id,
                                            channelId: sourceChannel?.id,
                                            hashtags: hashtagsTokens)
            
            self.photos = self.accessor.getPhotos(getPhtCls)
            self.delegate?.photosLoaded()
        }
    }
    
    func clearPhotoPending(photoInfo: PhotoInfo) {
        photoInfo.pending = 0
        self.accessor
                .clearPhotoPending(pdsc: PhotoDescriptor(photoId: photoInfo.id,
                                                         userId: userProvider.currentUser.id))
    }
    
    // MARK: Activity Listener
    
    override func getSubscriberTicket() -> String {
        return "PhotoCollectionModel"
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
