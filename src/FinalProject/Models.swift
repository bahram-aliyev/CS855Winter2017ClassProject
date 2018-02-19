//
//  Models.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-09.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

final class Models {
    
    private init() { }
    
    static let userProvider: UserProvider = GenericUserProvider(authService: AuthenticationServiceFIR())
    
    static let imageConverter: ImageConverter = GenericImageConverter()
    
    static let channelEndpoint: ChannelEndpoint = ChannelEndpointFIR()
    
    static let contactsEndpoint: ContactsEndpoint = ContactsEndpointFIR()
    
    static let activityLogEndpoint: ActivityLogEndpoint = ActivityLogEndpointFIR()
    
    static let channelAccessor: ChannelAccessor = ChannelAccessorSQLite()
    
    static let photoAccessor: PhotoAccessor = PhotoAccessorSQLite()
    
    static let activityLogAccessor: ActivityLogAccessor = ActivityLogAccessorSQLite()
    
    static let transactionScope: TransactionScope = TransactionScopeSQLite()
    
    static let authenticationService: AuthenticationService  = AuthenticationServiceFIR()
    
    static let imageRecognizer: ImageRecognizer = OnlineImageRecognizer()
    
    static let activityPublisherFactory = ActivityPublisherFactory(
                                                    activityLogEndpoint: activityLogEndpoint,
                                                    photoAccessor: photoAccessor,
                                                    activityLogAccessor: activityLogAccessor,
                                                    transactionScope: transactionScope,
                                                    imageConverter: imageConverter,
                                                    imageRecognizer: imageRecognizer)
    
    static func initSignupModel(delegate: SignupModelDelegate?) -> SignupModel {
        let model = SignupModel(authService: self.authenticationService)
        model.delegate = delegate
        return model
    }
    
    static func initLoginModel(delegate: LoginModelDelegate?) -> LoginModel {
        let model =  LoginModel(authService: self.authenticationService)
        model.delegate = delegate
        return model
    }
    
    static func initContactsListModel(delegate: ContactsListModelDelegate) ->  ContactsListModel {
        let model = ContactsListModel(endpoint: self.contactsEndpoint, userProvider: self.userProvider)
        model.delegate = delegate
        return model
    }
    
    static func initChannelEntryModel(delegate: ChannelEntryModelDelegate) -> ChannelEntryModel {
        let model = ChannelEntryModel(channelEndpoint: self.channelEndpoint, userProvider: self.userProvider,
                                      activityLogMediator: ActivityLogMediator.current)
        model.delegate = delegate
        return model
    }
    
    static func initChannelsListModel(delegate: ChannelsListModelDelegate) -> ChannelsListModel {
        let model =
                ChannelsListModel(endpoint: self.channelEndpoint, userProvider: self.userProvider,
                                  publisherFactory: self.activityPublisherFactory, channelAccessor: self.channelAccessor)
        model.delegate = delegate
        return model
    }
    
    static func initActivityLogModel() -> ActivityLogModel {
        return ActivityLogModel(userProvider: self.userProvider, accessor: self.activityLogAccessor)
    }
    
    static func initPhotoContentModel(delegate: PhotoContentModelDelegate) -> PhotoContentModel {
        let model = PhotoContentModel(photoAccess: self.photoAccessor, userProvider: self.userProvider,
                                      publisherFactory: self.activityPublisherFactory)
        
        model.delegate = delegate
        return model
    }
    
    static func initPhotoCollectionModel(delegate: PhotoCollectionModelDelegate) -> PhotoCollectionModel {
        let model =  PhotoCollectionModel(userProvider: self.userProvider, accessor: self.photoAccessor,
                                          publisherFactory: self.activityPublisherFactory)
        model.delegate = delegate
        return model
    }
    
    static func initChannelParticipantsModel(dataLoadFinished: ((String?) -> Void)!) -> ChannelParticipantsModel {
        let model = ChannelParticipantsModel(channelEndpoint: self.channelEndpoint, userProvider: self.userProvider)
        model.participantsLoadFinished = dataLoadFinished
        return model
    }
    
}
