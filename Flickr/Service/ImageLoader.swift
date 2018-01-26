//
//  ImageLoader.swift
//  Flicker
//
//  Created by Mijin Cho on 26/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ImageLoader {
    private lazy var caching : Caching = {
        return ImageCaching()
    }()
    
    func loadImage(fromUrlString urlString: String,
                   httpServiceProvider:HTTPServiceProvider) -> Observable<UIImage?> {
        if let cachedImage = self.caching.value(forKey: urlString) {
            return Observable.just(cachedImage)
        }
        
        return httpServiceProvider.data(fromUrlString: urlString)
            .map {[weak self] data in
                guard let imageData = data as? Data else {
                    return nil
                }
                guard let image = UIImage(data: imageData) else {
                    return nil
                }
                self?.caching.setValue(value: image, forKey: urlString)
                return image
        }
    }
}
