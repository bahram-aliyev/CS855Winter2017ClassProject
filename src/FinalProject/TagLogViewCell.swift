//
//  TagLogViewCell.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import ActiveLabel

class TagLogViewCell: ActivityLogViewCell {

    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var entryDateLbl: UILabel!
    @IBOutlet weak var hastagsLbl: ActiveLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configureActivityLog(log: ActivityLog) {
        if let hashtagLog = log as? HashtagActivityLog {
            self.authorLbl.text = hashtagLog.author
            self.hastagsLbl.text = hashtagLog.hashtags
            self.entryDateLbl.text = ViewUtil.formatDate(hashtagLog.entryDate)
        }
    }
    
}
