//
//  FeedLoaderViewController.swift
//  FeedLoaderComposition
//
//  Created by areej sadaqa on 18/04/2026.
//

import UIKit

protocol FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void)
}

final class FeedLoaderViewController: UIViewController { //inheritance
    var loader: FeedLoader! // we depend (strong dependency) on FeedLoader using composition and dependency injection
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadFeed { loadedItems in
            // updateUI
        }
    }
}

class RemoteFeedLoader: FeedLoader { //confrom to/ implement
    func loadFeed(completion: @escaping ([String]) -> Void) {
        
    }
}

class LocalFeedLoader: FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void) {
        
    }
}

struct Reachability {
    static let networkAvailable = false
}

class RemoteWithLocalFallbackFeedLoader: FeedLoader { // conform to  FeedLoader
    let remote: RemoteFeedLoader // strongly depend on using compostions
    let local: LocalFeedLoader // strongly depend on using compostions
    
    init(remote: RemoteFeedLoader, local: LocalFeedLoader) {
        self.remote = remote
        self.local = local
    }
    
    func loadFeed(completion: @escaping ([String]) -> Void) {
        let load = Reachability.networkAvailable ? remote.loadFeed : local.loadFeed
        load(completion)
    }
}

//The Use - it doesnt really matter where it comes and if we change anything inside it won't matter we have SRP and separations of concerns 
let vc1 = FeedLoaderViewController(loader: RemoteFeedLoader())
let vc2 = FeedLoaderViewController(loader: LocalFeedLoader())
let vc3 = FeedLoaderViewController(loader: RemoteWithLocalFallbackFeedLoader(
    remote: RemoteFeedLoader(),
    local: LocalFeedLoader())
)
