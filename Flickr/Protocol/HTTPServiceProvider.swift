//
//  HTTPServiceProvider.swift
//  Flickr
//
//  Created by Mijin Cho on 23/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Foundation
import RxSwift

protocol HTTPServiceProvider: class {
    func data(fromUrlString urlString: String) -> Observable<Any>
}
