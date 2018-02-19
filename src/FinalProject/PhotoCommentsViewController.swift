//
//  PhotoCommentsViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-31.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class PhotoCommentsViewController: UITableViewController, PhotoContentModelConsumer {

    var photoContentModel: PhotoContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.photoContentModel.loadComments()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoContentModel.commentsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoContentViewController.CommentReuseIdentifier, for: indexPath)
        
        if let commentCell = cell as? CommentLogViewCell {
            commentCell.configureComment(comment: self.photoContentModel.getComment(index: indexPath.row), truncateContent: false)
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var consumer = segue.destination as? PhotoContentModelConsumer {
            consumer.photoContentModel = self.photoContentModel
        }
    }
    
    // MARK: Helper Hethods
    
    private func configureTableView() {
        let reuseIdentifier = PhotoContentViewController.CommentReuseIdentifier
        self.tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 144
    }
}
