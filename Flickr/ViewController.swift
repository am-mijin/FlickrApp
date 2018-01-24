//
//  ViewController.swift
//  Flickr
//
//  Created by Mijin Cho on 23/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    enum HTTPServiceProviderError: Error {
        case unhandledResponse
    }
    
    private let disposeBag = DisposeBag()

    private var feeds: [Feed] = [] {
        didSet {
            //self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFeeds()
            .subscribe(onNext: { feeds in self.feeds = feeds},
                       onError: { error in print(error)
            }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getFeeds() -> Observable<[Feed]> {
        
        let flickrHTTPServiceProvider = FlickrHTTPServiceProvider()
        return flickrHTTPServiceProvider.data(fromUrlString: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")
            .timeout(10, scheduler: MainScheduler.instance)
            .map { data in
                guard let json = data as? [String : Any] else {
                    throw HTTPServiceProviderError.unhandledResponse
                }
                guard let items = json ["items"] as? [Any] else {
                    throw HTTPServiceProviderError.unhandledResponse
                }
                var feeds = [Feed]()
                for dictionary in items {
                    guard let item = dictionary as? [String : Any] else {
                        throw HTTPServiceProviderError.unhandledResponse
                    }
                    let feed = Feed(dictionary: item)
                    if let feed = feed {
                        feeds.append(feed)
                    }
                }
                return feeds }
            .do(onNext: { [weak self] feeds in
                },
                onError: { error in
                    print(error.localizedDescription)
            })
            .catchErrorJustReturn([])
    }
}

