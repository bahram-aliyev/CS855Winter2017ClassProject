//
//  ContactsListModel.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ContactsListModel {
    
    private let endpoint: ContactsEndpoint
    private let userProvider: UserProvider
    
    private var _contacts: [User]!
    private var _filteredContacts: [User]!
    
    var contacts: [User]! {
        get {
            return self._filteredContacts ?? self._contacts
        }
    }
    
    private var selectedContactsIndxs: Set<Int> = Set<Int>()
    
    var delegate: ContactsListModelDelegate!
    
    init(endpoint: ContactsEndpoint, userProvider: UserProvider) {
        self.endpoint = endpoint
        self.userProvider = userProvider
    }
    
    var itemsCount: Int {
        get {
            return self.contacts?.count ?? 0
        }
    }
    
    func loadItems() {
        let getContactsRq = GetContactsRequest(data: self.userProvider.currentUser.id)
        self.endpoint.getContacts(rq: getContactsRq) {
            if case let ResponseStatus.failure(cause) = $0.status {
                self.delegate.contactsLoadFailed(cause: cause)
            }
            else {
                self._contacts = $0.data
                self.delegate?.contactsLoaded()
            }
        }

    }
    
    func togleSelectionAtIndex(index: Int) {
        if self.isValidIndex(index) {
            if self.selectedContactsIndxs.contains(index) {
                self.selectedContactsIndxs.remove(index)
            }
            else {
                self.selectedContactsIndxs.insert(index)
            }
        }
    }
    
    func isItemSelectedAtIndex(index: Int) -> Bool {
        return self.selectedContactsIndxs.contains(index)
    }
    
    func getSelectedItems() -> [User] {
        var selectedItems = [User]()
        self.selectedContactsIndxs.forEach { selectedItems.append(self.contacts[$0]) }
        return selectedItems
    }
    
    func hasSelectedItems() -> Bool {
        return self.selectedContactsIndxs.count > 0
    }
    
    func filterContacts(filter: String) {
        let filter = filter.trimmingCharacters(in: .whitespaces)
        
        if !filter.isEmpty {
            self._filteredContacts = self.contacts.filter({ $0.name.hasPrefix(filter) || $0.email.hasPrefix(filter) })
        }
        else {
            self._filteredContacts = nil
        }
        self.delegate?.contactsLoaded()
    }
    
    private func isValidIndex(_ index:Int) -> Bool {
        return index >= 0 && index < self.contacts.count
    }
    
}
