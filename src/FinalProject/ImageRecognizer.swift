//
//  ImageRecognizer.swift
//  FinalProject
//
//  Created by gursimran on 2017-04-11.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol ImageRecognizer {
    func recognize(rawImg: Data, callback: @escaping (Error?, [String]?) -> Void)
}
