//
//  PhotoLogViewCell.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class PhotoLogViewCell: ActivityLogViewCell {
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var entryDateLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configureActivityLog(log: ActivityLog) {
        if let photoLog = log as? PhotoActivityLog {
            self.authorLbl.text = photoLog.author
            self.thumbnailImg.image = UIImage(data: photoLog.image)
            self.entryDateLbl.text = ViewUtil.formatDate(photoLog.entryDate)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ViewUtil.roundedCornerImage(self.thumbnailImg)
    }
    
}
