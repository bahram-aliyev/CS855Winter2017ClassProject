//
//  ChannelsViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class ChannelsListViewController: UITableViewController,
            UIImagePickerControllerDelegate,
            UINavigationControllerDelegate,
            ChannelsListModelDelegate,
            UISearchBarDelegate {

    private let reuseIdentifier = "ChannelsListItem"
    private let subscriberTicket = "ChannelsListViewController"
    
    private var model: ChannelsListModel!
    
    private var photoActivityReceiver: ChannelInfo!
    
    //private var activityListeningStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChannelListItemView.addNewPhotoGlobalHandler = addNewPhotoHandler
        
        self.model = Models.initChannelsListModel(delegate: self)
        self.view.makeToastActivity(.center)
        self.model.loadItems()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! ChannelListItemView
        
        cell.configureChannelView(model.items[indexPath.row])
        
        return cell
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.photoActivityReceiver = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("The appication was not able to retrive the selected image due to the follwing reason: '\(info)'")
        }
        
        let channel = self.photoActivityReceiver!
        self.photoActivityReceiver = nil
        
        self.model.publishPhoto(bundle: (channel, ViewUtil.resizeForTransfer(image: image)))
    }
    
    // MARK: - ChannelsListModelDelegate
    
    func channelsLoaded() {
        self.tableView.reloadData()
        self.view.hideToastActivity()
        
//        if !self.activityListeningStarted {
//            self.activityListeningStarted = true
//            self.model.beginListenActivityChanges()
//        }
    }
    
    func channlesLoadingFailed(cause: String) {
        self.view.hideToastActivity()
        ViewUtil.showAlert(parentCtrl: self, message: cause)
    }

    // MARK: ChannelsListModelDelegate : PhotoPublisherDelegate
    
    func photoPublisingCompleted(error: Error!) {
        if let error = error {
            ViewUtil.showAlert(parentCtrl: self, message: error.localizedDescription)
        }
        else {
            self.view.makeToast(UIMessages.photoPublished)
        }
    }

    // MARK: Action Handlers
    
    func addNewPhotoHandler(channel: ChannelInfo) {
        self.photoActivityReceiver = channel
        ViewUtil.showImagePicker(imagePickerDelegate: self)
    }
    
    
    @IBAction func logoutHandler(_ sender: Any) {
        self.model.logout()
        self.performSegue(withIdentifier: Segues.Logout, sender: sender)
    }
    
    // MARK: - Navigation
    
    @IBAction
    func unwindToChannelsList(sender: UIStoryboardSegue) {
        if sender.identifier == Segues.ChannelsList {
            self.view.makeToast(UIMessages.channelCreated)
            self.model.loadItems()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ChannelContent {
            if let contentViewCtrl = segue.destination as? ChannelContentViewController {
                let indexPath = self.tableView.indexPath(for: sender as! ChannelListItemView)
                
                contentViewCtrl.selectedIndex = 0
                
                let channelInfo = self.model.items[indexPath!.row]
                contentViewCtrl.channel = channelInfo
                self.model.clearChannelPending(channelInfo: channelInfo)
                self.tableView.reloadRows(at: [indexPath!], with: .automatic)
            }
        }
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.model.filerChannels(filter: searchText)
    }
    
    // MARK: deinit - unsibscribe from the mediator
    
//    deinit {
//        self.model?.stopListenActivityChanges()
//    }

}
