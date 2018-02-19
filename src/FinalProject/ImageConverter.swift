//
//  ThumbnailGenerator.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ImageConverter {
    func thumbnail(rawImage: Data) -> Data
}
