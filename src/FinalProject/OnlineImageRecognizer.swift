//
//  ImageRecognizer.swift
//  FinalProject
//
//  Created by gursimran on 2017-04-10.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class OnlineImageRecognizer : ImageRecognizer {
    
    let googleAPIKey = "AIzaSyB_jN_w86PWAGDu7w2kAiw-1Oubpkecyfc"

    var googleURL: URL {
        get {
            return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
        }
    }
    
    func recognize(rawImg: Data, callback: @escaping (Error?, [String]?) -> Void) {
        let recognitionRq = self.createRecognitionRequest(rawImg.base64EncodedString())
        self.executeRequest(request: recognitionRq!, clb: callback)
    }
    
    private func createRecognitionRequest(_ imgBase64: String) -> URLRequest! {
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imgBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 3
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 3
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return nil
        }
        
        request.httpBody = data
        return request
    }
    
    private func executeRequest(request: URLRequest, clb: @escaping (Error?, [String]?) -> Void) {
            // run the request
            let task =
                    URLSession.shared.dataTask(with: request) {
                            (data, response, error) in
                                if error != nil {
                                    clb(error, nil)
                                }
                                else {
                                    clb(nil, self.parseTags(rsData: data!))
                                }
            }
            task.resume()
    }

    private func parseTags(rsData: Data) -> [String] {
        
        var tags = [String]()
        let rawRs = JSON(data: rsData)
        
        let annotations = rawRs["responses"][0]["labelAnnotations"]
        let numLabels: Int = annotations.count
        if numLabels > 0 {
            for index in 0..<numLabels {
                tags.append(annotations[index]["description"].stringValue)
            }
        }
        
        return tags
    }
}

        
