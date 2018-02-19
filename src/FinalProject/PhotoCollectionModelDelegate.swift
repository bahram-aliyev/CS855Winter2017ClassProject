//
//  PhotoCollectionModelDelegate.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-11.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol PhotoCollectionModelDelegate : PhotoPublisherDelegate {
    func photosReloaded()
    
    func photosLoaded()
}
