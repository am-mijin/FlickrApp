//
//  Feed.swift
//  Flickr
//
//  Created by Mijin Cho on 23/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Foundation

struct Feed {
    var title: String = ""
    var description: String  = ""
    var mediaUrl: String = ""
    //var published: Date
    var tags: String = ""

    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.tags = dictionary["tags"] as? String ?? ""
        guard let media = dictionary["media"] as? [String: Any] else {
            return
        }
        self.mediaUrl = media ["m"] as? String ?? ""
    }
}

extension Feed: Equatable {}
func ==(lhs: Feed, rhs: Feed) -> Bool {
    return lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.tags == rhs.tags &&
        lhs.mediaUrl == rhs.mediaUrl
}
