//
//  Post.swift
//  RedditFrontPage
//
//  Created by Kevin Tsai on 8/13/19.
//  Copyright © 2019 Kevin Tsai. All rights reserved.
//

import Foundation

struct PostService: Decodable {
    let data: Data
    
    struct Data: Decodable{
        let children: [Post]
        let after: String
    }
}

struct Post: Decodable {
    let kind: String
    let data: Data
    
    struct Data: Decodable {
        var title: String
        var thumbnail: URL
        var id: String
    }
}
