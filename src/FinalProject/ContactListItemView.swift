//
//  ContactListItemController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-13.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class ContactListItemView: UITableViewCell {
    
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureContactView(contact: User) {
        self.fullNameLbl.text = contact.name
        self.phoneNumberLbl.text = contact.email
    }

}
