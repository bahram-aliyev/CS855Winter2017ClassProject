//
//  PhotoContentModelDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-30.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol PhotoContentModelDelegate {
    
    func hashTagsUpdated()
    
    func commentAdded()
    
    func dataLoaded(bundle: (photo:Photo, comments:[Comment]?))
}
