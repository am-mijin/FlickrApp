//
//  ImageCachingSpec.swift
//  FlickrTests
//
//  Created by Mijin Cho on 23/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import UIKit

@testable import Flickr
class ImageCachingSpec: QuickSpec {
    
    private let testObject = UIImage(named:"testImage")
    override func spec() {
        describe("setValue(_:forKey:)") {
            context("the value is not empty") {
                it("stores an object under the provided key") {
                    let caching = ImageCaching()
                    caching.setValue(value: self.testObject!, forKey: "testObject")
                    
                    let cachedObject = caching.value(forKey: "testObject")
                    let expected = self.testObject
                    expect(cachedObject) == expected
                }
            }
            context("no value exists for the provide key") {
                it("retuns nil") {
                    let caching = ImageCaching()
                    
                    let cachedObject = caching.value(forKey: "testObject")
                    expect(cachedObject).to(beNil())
                }
            }
        }
    }
}
