//
//  ImageCaching.swift
//  Flickr
//
//  Created by Mijin Cho on 24/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//


import Foundation
import UIKit

class ImageCaching: Caching {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func value(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString) ?? nil
    }
    
    func setValue(value: UIImage, forKey key: String) {
        imageCache.setObject(value, forKey: key as NSString)
    }
}
