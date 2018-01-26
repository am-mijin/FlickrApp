//
//  Caching.swift
//  Flickr
//
//  Created by Mijin Cho on 24/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Foundation
import UIKit
///
/// An object that is responsible for reading/writing from/to a persistent store.
///
protocol Caching {
    
    func value(forKey key: String) -> UIImage?
    
    func setValue(value: UIImage, forKey key: String)
}