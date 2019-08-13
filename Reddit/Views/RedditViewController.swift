//
//  RedditViewController.swift
//  Reddit
//
//  Created by Kevin Tsai on 8/13/19.
//  Copyright © 2019 Kevin Tsai. All rights reserved.
//

import UIKit

class RedditViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: RedditViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = RedditViewModel(delegate: self)
    }

}

extension RedditViewController: RedditViewDelegate {
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RedditViewController: UITableViewDelegate {
    
}

extension RedditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.posts?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        guard let post = viewModel.posts?[indexPath.row] else {
            cell.textLabel?.text = "This is cell number \(indexPath.row)"
            return cell
        }
        
        cell.textLabel?.text = post.data.title
        cell.imageView?.image = viewModel.fetchImage(for: post)?.scaleImageToSize(newSize: CGSize(width: 80.0, height: 80.0))

        return cell
    }
    
}
