//
//  ImageLoaderSpec.swift
//  FlickrTests
//
//  Created by Mijin Cho on 26/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import Foundation

import Quick
import Nimble
import RxSwift
import UIKit

@testable import Flickr
class ImageLoaderSpec: QuickSpec {
    private let disposeBag = DisposeBag()
    
    private var imageLoader = {
        return ImageLoader()
    }

    override func spec() {
        describe("ImageLoader"){
            context("imageData is valid"){
                it("retuns image"){
                    let data = UIImagePNGRepresentation(UIImage(named:"testImage")!)
                    let httpServiceProviderMock = HTTPServiceProviderMock(stubResponse: data)
                    self.imageLoader().loadImage(fromUrlString: "testImage",
                                                 httpServiceProvider: httpServiceProviderMock)
                        .subscribe(onNext: { image in
                            let imageData = UIImagePNGRepresentation(image!)
                            expect(imageData) == data
                        }).disposed(by: self.disposeBag)
                }
            }
            
            context("imageData is invalid"){
                it("retuns nil"){
                    let httpServiceProviderMock = HTTPServiceProviderMock(stubResponse: [])

                    self.imageLoader().loadImage(fromUrlString: "testImage",
                                                 httpServiceProvider: httpServiceProviderMock)
                        .subscribe(onNext: { image in
                            expect(image).to(beNil())
                            
                        }).disposed(by: self.disposeBag)
                }
            }
        }
    }

    
    private class HTTPServiceProviderMock: HTTPServiceProvider {
        
        private let stubResponse: Any?
        init(stubResponse: Any?) {
            self.stubResponse = stubResponse
        }
        
        func data(fromUrlString urlString: String) -> Observable<Any> {
            guard let stubResponse = stubResponse else {
                return Observable.error(ErrorMock.general)
            }
            return Observable.just(stubResponse)
        }
    }
    
    private enum ErrorMock: Error {
        case general
    }
}

