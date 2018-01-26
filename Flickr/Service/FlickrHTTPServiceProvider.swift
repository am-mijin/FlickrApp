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
enum HTTPServiceProviderError: Error {
    case unhandledResponse
    case general
}

class FlickrHTTPServiceProvider: HTTPServiceProvider {
    func data(fromUrlString urlString: String) -> Observable<Any> {
        return RxAlamofire.requestData(.get,urlString)
            .map {$1}
    }
}
