//
//  RedditService.swift
//  RedditFrontPage
//
//  Created by Kevin Tsai on 8/13/19.
//  Copyright © 2019 Kevin Tsai. All rights reserved.
//

import Foundation
import UIKit

class RedditService {
    
    class func getPosts(after: String?, completion: @escaping (_ error: Error?, _ after: String?, _ posts: [Post]?)->Void) {
        let redditURL = "http://www.reddit.com/.json"
        var dataTask: URLSessionDataTask?
        
        if var urlComponents = URLComponents(string: redditURL) {
            if let lastPost = after {
                urlComponents.query = "after=t3_\(lastPost)"
            }
            guard let url = urlComponents.url else { return }
            
            dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    let decoder = JSONDecoder()
                    let postService = try? decoder.decode(PostService.self, from: data)
                    completion(error, postService?.data.after, postService?.data.children)
                } else {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
            }
            dataTask?.resume()
        }
    }
    
    class func getThumbnail(for post: Post, completion: @escaping (_ error: Error?, _ image: UIImage?)->Void ) {
        var thumbnail: UIImage?
        let url = post.data.thumbnail
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                thumbnail = UIImage(data: data)
            }
            
            completion(error, thumbnail)
        }
        task.resume()
    }
}
