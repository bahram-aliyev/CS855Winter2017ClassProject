//
//  ParticipantsListViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import Toast_Swift

class ParticipantsListViewController: UITableViewController {

    private let reuseIdentifier = "ParticipantItemView"
    
    private var sourceChannel: ChannelInfo!
    
    private var model: ChannelParticipantsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: self.reuseIdentifier, bundle: nil),
                                forCellReuseIdentifier: self.reuseIdentifier)

        self.sourceChannel = (self.tabBarController as! ChannelContentViewController).channel
        self.navigationItem.title = sourceChannel.name
        
        self.model = Models.initChannelParticipantsModel(dataLoadFinished: dataLoadFinished)
        
        self.model.loadParticipants(channelInfo: sourceChannel)
        self.view.makeToastActivity(.center)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
        
        let participant = self.model.getItem(index: indexPath.row)
        
        (cell as! ParticipantItemView).participantName = participant.name
        cell.accessoryType = self.model.isCurrentUser(participant: participant) ? .checkmark : .none
        
        return cell
    }

    // MARK: - Helper Methods
    
    private func dataLoadFinished(error: String!) {
        self.view.hideToastActivity()
        if let error = error {
            ViewUtil.showAlert(parentCtrl: self, message: error)
            return
        }
        
        self.tableView.reloadData()
    }
}
