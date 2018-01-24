//
//  FlickrHTTPServiceProvider.swift
//  Flickr
//
//  Created by Mijin Cho on 23/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//


import Foundation
import RxSwift
import RxAlamofire

///
/// A `HTTPServiceProvider` that fetches data from Flickr api.
///
class FlickrHTTPServiceProvider: HTTPServiceProvider {
    func data(fromUrlString urlString: String) -> Observable<Any> {
        return RxAlamofire.requestData(.get,urlString)
            .map { response, data in
                do {
                    //Flickr JSON output is invalid.
                    let invalidDataStr = String(data: data, encoding: .utf8)
                    let validDataStr = invalidDataStr?.replacingOccurrences(of: "\\'", with: "'")
                    let jsonData = validDataStr?.data(using: .utf8)
                    if let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any] {
                        return json
                    }
                }
               return []
            }
    }
}
