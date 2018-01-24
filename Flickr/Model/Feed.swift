//
//  Feed.swift
//  Flickr
//
//  Created by Mijin Cho on 23/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Foundation

struct Feed {
    let title: String
    let description: String
    let mediaUrl: String
    //var published: Date
    let tags: String 

    init?(dictionary: [String: Any]) {
        guard
            let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let media = dictionary["media"] as? [String: Any],
            let tags = dictionary["tags"] as? String
        else {
            return nil
        }
        self.title = title
        self.description = description
        self.mediaUrl = media ["m"] as? String ?? ""
        self.tags = tags
    }
}
