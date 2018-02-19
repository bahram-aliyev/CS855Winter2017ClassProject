//
//  ActivityLogViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-29.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class ActivityLogViewController: UITableViewController {

    private let TagLogReuseIdentifier = "TagLogViewCell"
    private let PhotoLogReuseIdentifier = "PhotoLogViewCell"
    private let CommentLogReuseIdentifier = "CommentLogViewCell"
    
    private let subscriberTicket = "ActivityLogViewController"
    
    private var model: ActivityLogModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        
        self.model = Models.initActivityLogModel()
        
        if let channelInfo = (self.tabBarController as? ChannelContentViewController)?.channel {
            self.model.sourceChannel = channelInfo
            self.navigationItem.title = channelInfo.name
        }

        self.model.activityLogReloaded = { self.tableView.reloadData() }
        self.model.beginListenActivityChanges()
        
        self.model.loadActivityLog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.model.itemsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var logViewCell: ActivityLogViewCell!
        let activityLog = model.getItem(itemIndex: indexPath.row)
        
        switch activityLog.type {
            case .hashtag:
                logViewCell =
                    tableView.dequeueReusableCell(withIdentifier: self.TagLogReuseIdentifier,
                                                    for: indexPath) as! TagLogViewCell
            case .photo:
                logViewCell =
                    tableView.dequeueReusableCell(withIdentifier: self.PhotoLogReuseIdentifier,
                                                    for: indexPath) as! PhotoLogViewCell
            default:
                logViewCell =
                    tableView.dequeueReusableCell(withIdentifier: self.CommentLogReuseIdentifier,
                                                    for: indexPath) as! CommentLogViewCell
        }
        
        // Configure the cell...
        logViewCell.configureActivityLog(log: activityLog)
        return logViewCell
    }
    
    // MARK: Helper Methods
    
    private func configureTableView() {
        self.tableView.register(UINib(nibName: self.TagLogReuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: self.TagLogReuseIdentifier)
        self.tableView.register(UINib(nibName: self.PhotoLogReuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: self.PhotoLogReuseIdentifier)
        self.tableView.register(UINib(nibName: self.CommentLogReuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: self.CommentLogReuseIdentifier)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 144
    }
    
    deinit {
        self.model?.stopListenActivityChanges()
    }
}
