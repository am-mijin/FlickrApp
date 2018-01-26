//
//  FeedSpec.swift
//  FlickrTests
//
//  Created by Mijin Cho on 26/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import UIKit

@testable import Flickr
class FeedSpec: QuickSpec {
    private var defaultFeed: Feed {
        var expected = Feed(dictionary: [:])
        expected.title = ""
        expected.description = ""
        expected.tags = ""
        expected.mediaUrl = ""
        return expected
    }
    
    override func spec() {
        describe("init(dictionary:)") {
            context("the dictionary is empty") {
                it("creates a Feed with correct defaults") {
                    let feed = Feed(dictionary: [:])
                    expect(feed) == self.defaultFeed
                }
            }
            
            context("the dictionary contains unsupported entries") {
                it("creates a Feed ignoring unsupported entries") {
                    let entries: [String : Any] = [
                        "unsupportedKey1": "unsupportedVal1",
                        "unsupportedKey2": "unsupportedVal2"
                    ]
                    let feed = Feed(dictionary: entries)
                    expect(feed) == self.defaultFeed
                }
            }
            context("mediaUrl is invalid") {
                it("creates a Feed ignoring unsupported entries") {
                    let entries: [String : Any] = [
                        "media": ["unsupportedKey1":"unsupportedVal1"]
                    ]
                    let feed = Feed(dictionary: entries)
                    expect(feed) == self.defaultFeed
                }
            }
        }
    }
}
