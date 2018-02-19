//
//  GenericImageConverter.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import UIKit

class GenericImageConverter : ImageConverter {
    func thumbnail(rawImage: Data) -> Data {
       return ViewUtil.resizeForThumbnail(image: UIImage(data: rawImage)!)
    }
}
