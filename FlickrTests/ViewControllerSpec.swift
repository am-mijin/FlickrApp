//
//  ViewControllerSpec.swift
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
class ViewControllerSpec: QuickSpec {
    override func spec() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        describe("ViewController") {
            context("request flickr feeds") {
                
                let viewController: ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
               
                let httpServiceProviderMock = HTTPServiceProviderMock(stubResponse: self.validStubResponse)
                viewController.flickrHTTPServiceProvider = httpServiceProviderMock
                
                let tableView: UITableView = UITableView()
                tableView.register(FlickrTableViewCell.self,
                                   forCellReuseIdentifier: "FlickrTableViewCell")
                viewController.tableView = tableView
                viewController.viewWillAppear(true)
                viewController.viewDidLoad()
                
                context("response is valid") {
                    it("returns feeds and should return the right number of rows") {
                        expect(viewController.tableView.numberOfRows(inSection: 0)) == 1
                    }
                }
            }
        }
    }
    private let testObj: UIImage = UIImage(named:"testImage")!
    private var validStubResponse: [String : Any] {
        return [
            "items" :[[
                "title" : "title",
                "description" : "description",
                "tags" : "tags",
                "m" : ["media":"testImage"]]
            ]
        ]
    }
    
    private class HTTPServiceProviderMock: HTTPServiceProvider {
       
        private let stubResponse: Any?
        init(stubResponse: Any?) {
            if stubResponse != nil {
                self.stubResponse = try! JSONSerialization.data(withJSONObject: stubResponse,
                                                           options: .prettyPrinted)
            }else{
                self.stubResponse = stubResponse
            }
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
