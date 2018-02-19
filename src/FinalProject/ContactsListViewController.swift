//
//  ContactListViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class ContactsListViewController: UITableViewController, UISearchBarDelegate, ContactsListModelDelegate {
   
    //MARK: Outlets
    @IBOutlet var contactsTable: UITableView!
    @IBOutlet weak var nextBtn: UIBarButtonItem!

    private let reuseIdentifier = "ContactsListItem"
    private var model: ContactsListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model = Models.initContactsListModel(delegate: self)
        self.view.makeToastActivity(.center)
        self.model.loadItems()
    }

    // MARK: ContactsListModelDelegate
    
    func contactsLoaded() {
        self.tableView.reloadData()
        self.view.hideToastActivity()
    }
    
    func contactsLoadFailed(cause: String) {
        self.view.hideToastActivity()
        ViewUtil.showAlert(parentCtrl: self, message: cause)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.itemsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
                as! ContactListItemView
        
        cell.configureContactView(contact: self.model.contacts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactsTable.deselectRow(at: indexPath, animated: true)
        
        if let cell = self.contactsTable.cellForRow(at: indexPath) {
            self.model.togleSelectionAtIndex(index: indexPath.row)
            self.defineCellAccessory(cell, index: indexPath.row)
            self.updateNextButtonState()
        }
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ChannelEntry {
            if let channeEntryCtrl = segue.destination as? ChannelEntryViewController {
                channeEntryCtrl.selectedContacts = self.model.getSelectedItems()
            }
        }
    }
    
    // MARK: Action Handlers
    
    @IBAction func cancelActionHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.model.filterContacts(filter: searchText)
    }
    
    // MARK: Utility methods
    
    private func defineCellAccessory(_ cell: UITableViewCell, index: Int) {
        cell.accessoryType =
            model.isItemSelectedAtIndex(index: index)
            ? .checkmark
            : .none
    }
    
    private func updateNextButtonState() {
        self.nextBtn.isEnabled = self.model.hasSelectedItems()
    }

}
