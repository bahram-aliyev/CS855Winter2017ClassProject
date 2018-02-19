//
//  ParticipantItemView.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-13.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class ParticipantItemView: UITableViewCell {

    @IBOutlet weak var participantNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var participantName: String! {
        get {
            return self.participantNameLbl.text
        }
        set {
            self.participantNameLbl.text = newValue
        }
    }
    
}
