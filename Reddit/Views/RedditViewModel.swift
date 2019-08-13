//
//  RedditViewModel.swift
//  RedditFrontPage
//
//  Created by Kevin Tsai on 8/13/19.
//  Copyright © 2019 Kevin Tsai. All rights reserved.
//

import Foundation
import UIKit

protocol RedditViewDelegate: class {
    func reloadTable()
}

class RedditViewModel {
    typealias PostId = String
    typealias ImageDictionary = [PostId:UIImage?]
    
    weak var delegate: RedditViewDelegate?
    
    var posts: [Post]?
    var images: ImageDictionary?
    var after: String?
    
    init(delegate: RedditViewDelegate) {
        // fetch first batch of posts from reddit
        self.delegate = delegate
        posts = []
        images = [:]
        updatePosts(refresh: false)
    }
    
    func updatePosts(refresh: Bool) {
        if refresh {
//            after = nil
//            posts = []
        }
        RedditService.getPosts(after: after) { [weak self] (error, after, posts) in
            guard let strongSelf = self else { return }
            strongSelf.after = after
            if let posts = posts {
                strongSelf.posts?.append(contentsOf: posts)
            }
            strongSelf.delegate?.reloadTable()
        }
    }
    
    func fetchImage(for post: Post) -> UIImage? {
        var thumbnail = UIImage(named: "no-image-icon")
        //fetch image from local memory
        if let image = images?[post.data.id] {
            thumbnail = image
        } else {
            //fetch image via url
            RedditService.getThumbnail(for: post) { [weak self] (error, image) in
                guard let strongSelf = self else { return }
                if let image = image {
                    strongSelf.images?[post.data.id] = image
                    strongSelf.delegate?.reloadTable()
                } else {
                    strongSelf.images?[post.data.id] = UIImage(named: "no-image-icon")
                }
            }
        }
        return thumbnail
    }
}
