//
//  ChannelEntryViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import Toast_Swift

class ChannelEntryViewController: UITableViewController,
            UIImagePickerControllerDelegate,
            UINavigationControllerDelegate,
            UITextFieldDelegate,
            ChannelEntryModelDelegate {
    
    //MARK: Outlets
    
    @IBOutlet var channelEntryTbl: UITableView!
    @IBOutlet weak var participantsTable: UITableView!
    @IBOutlet weak var channelTitleTxt: UITextField!
    @IBOutlet weak var channelThumbnailImg: UIImageView!
    @IBOutlet weak var createChannelBtn: UIButton!
    
    static let ParticipantsReuseIdentifier: String = "ParticipantItem"
    
    private var participantsTableViewController : ParticipantsTableViewController!
    
    let sectionsToCells = [
        // CHANNEL
        0 : 2,
        // ARE YOU READY
        1 : 1,
        // PARTICIPANTS
        2 : 1
    ]
    
    var selectedContacts: [User]!
    
    private var model: ChannelEntryModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        participantsTable.register(UINib(nibName: "ParticipantItemView", bundle: nil),
                                   forCellReuseIdentifier: ChannelEntryViewController.ParticipantsReuseIdentifier)
        self.participantsTableViewController = ParticipantsTableViewController(participants: self.selectedContacts!)
        self.participantsTable.delegate = self.participantsTableViewController
        self.participantsTable.dataSource = self.participantsTableViewController
        
        self.model = Models.initChannelEntryModel(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sectionsToCells[section]!
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // just close the image picker, no cnages on cancel
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("The appication was not able to retrive the selected image due to the follwing reason: '\(info)'")
        }
        
        let rawThumbnail = ViewUtil.resizeForThumbnail(image: image)
        
        self.model.channelThumbnail = rawThumbnail
        self.channelThumbnailImg.image = image
    }
    
    // MARK: ChannelEntryModelDelegate
    
    func channelPublished(channel: Channel) {
        self.endChannelPublishing()
        self.performSegue(withIdentifier: Segues.ChannelsList, sender: nil)
    }
    
    func channelPublishingFailed(cause: String) {
        self.endChannelPublishing()
        ViewUtil.showAlert(parentCtrl: self, message: cause)
    }
    
    // MARK: - Action Handlers
    
    @IBAction func imageSelectionHandler(_ sender: Any) {
        ViewUtil.showImagePicker(imagePickerDelegate: self)
    }
    
    @IBAction func createChannelHandler(_ sender: UIButton) {
        self.model.channelName = self.channelTitleTxt.text
        self.model.contacts = self.selectedContacts
        if self.model.channelThumbnail == nil {
           self.model.channelThumbnail =  ViewUtil.resizeForThumbnail(image: channelThumbnailImg.image!)
        }
        
        self.startChannelPulising()
        self.model.saveChannel()
    }
    
    @IBAction func cancelEntryHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Herlper Methods
    
    func startChannelPulising() {
        self.createChannelBtn.isEnabled = false
        self.view.makeToastActivity(.center)
    }
    
    func endChannelPublishing() {
        self.createChannelBtn.isEnabled = true
        self.view.hideToastActivity()
    }
    
    class ParticipantsTableViewController : NSObject, UITableViewDelegate, UITableViewDataSource {
        
        private var participants: [User]
        
        init(participants: [User]) {
            self.participants = participants
            super.init()
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.participants.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsReuseIdentifier, for: indexPath)
            
            (cell as? ParticipantItemView)?.participantName = self.participants[indexPath.row].name
            
            return cell
        }
    }
    
}
