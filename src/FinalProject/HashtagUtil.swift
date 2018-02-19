//
//  HashtagUtil.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-09.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

final class HashtagUtil {
    
    static func mergeHashtags(currentHtgs: String!, newHtgs: String) -> (uniqueHtgs: String, mergedHtgs: String) {
        var currentHtgsArr = self.splitHashtags(rawHtgs: currentHtgs ?? "")
        if !currentHtgsArr.isEmpty { currentHtgsArr.removeFirst() }
        
        let newHtgsArr = self.splitHashtags(rawHtgs: newHtgs)
        
        let uniqueHtgsArr = newHtgsArr.filter { !currentHtgsArr.contains($0) }
        let mergedHtgsArr = uniqueHtgsArr + currentHtgsArr
        
        return (
            uniqueHtgs: self.joinHashtags(htgsArr: uniqueHtgsArr),
            mergedHtgs: self.joinHashtags(htgsArr: mergedHtgsArr)
        )
    }
    
    private static func splitHashtags(rawHtgs: String) -> [String] {
        return rawHtgs.components(separatedBy: "#")
            .map({$0.trimmingCharacters(in: .whitespaces)})
    }

    static func joinHashtags(htgsArr: [String]) -> String {
        var hashtags = htgsArr.joined(separator: " #")
                                .trimmingCharacters(in: .whitespaces)
        
        if !hashtags.isEmpty && !hashtags.hasPrefix("#") {
            hashtags = "#" + hashtags
        }
        
        return hashtags
    }
}
