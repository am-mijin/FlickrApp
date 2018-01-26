//
//  ViewController.swift
//  Flickr
//
//  Created by Mijin Cho on 23/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    let feeds: Variable<[Feed]> = Variable([])
    private let disposeBag = DisposeBag()
    lazy var flickrHTTPServiceProvider: HTTPServiceProvider = {
        return FlickrHTTPServiceProvider()
    }()
 
    private lazy var imageLoader: ImageLoader = {
        return ImageLoader()
    }()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCellConfiguration()
        setupCellTapHandling()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        getFeeds()
            .subscribe(onNext: { [weak self] feeds in
                   self?.feeds.value = feeds},
                   onError: { error in print(error)})
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    private func setup() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupCellConfiguration () {
        feeds.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "FlickrTableViewCell", cellType: FlickrTableViewCell.self)) { [weak self](_, feed, cell) in
                
                guard let strongSelf = self else { return }
                cell.titleLabel.text = feed.title
                cell.mediaImageView.image = nil
                strongSelf.imageLoader.loadImage(fromUrlString: feed.mediaUrl,
                                                 httpServiceProvider: strongSelf.flickrHTTPServiceProvider)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { image in
                        if let image = image {
                            cell.mediaImageView.image = image
                            cell.updateConstraintsIfNeeded()
                            cell.setNeedsUpdateConstraints()
                        }
                    })
                    .disposed(by: strongSelf.disposeBag)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCellTapHandling() {
        tableView.rx
            .modelSelected(Feed.self)
            .subscribe(onNext: {feed in
                if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                    if let cell = self.tableView.cellForRow(at: selectedIndexPath) as? FlickrTableViewCell,
                       let image = cell.mediaImageView.image {
                            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Saved!", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
    
    private func getFeeds() -> Observable<[Feed]> {
        return flickrHTTPServiceProvider.data(fromUrlString: "https://api.flickr.com/services/feeds/photos_public.gne?tags=food&tagmode=any&format=json&nojsoncallback=1")
            .timeout(8, scheduler: MainScheduler.instance)
            .map { data in
                guard let invalidData = data as? Data else {
                    throw HTTPServiceProviderError.unhandledResponse
                }
                // Flickr JSON output is invalid. To make it valid, remove "\\"
                let invalidDataStr = String(data: invalidData, encoding: .utf8)
                let validDataStr = invalidDataStr?.replacingOccurrences(of: "\\'", with: "'")
                guard let jsonData = validDataStr?.data(using: .utf8) else{
                    throw HTTPServiceProviderError.unhandledResponse
                }
              
                guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                    throw HTTPServiceProviderError.unhandledResponse
                }
                
                guard let items = json ["items"] as? [Any] else {
                    throw HTTPServiceProviderError.unhandledResponse
                }
                
                var feeds = [Feed]()
                for item in items {
                    guard let dictionary = item as? [String : Any] else {
                        throw HTTPServiceProviderError.unhandledResponse
                    }
                    let feed = Feed(dictionary: dictionary)
                    feeds.append(feed)
                }
                return feeds
            }
            .do( //onNext: {  [weak self]  feeds in
                //                },
                onError: { error in
                    print(error.localizedDescription)
            })
            .catchErrorJustReturn([])
    }
}

