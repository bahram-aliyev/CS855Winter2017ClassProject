//
//  CommentLogViewCell.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-12.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class CommentLogViewCell: ActivityLogViewCell {
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var entryDateLbl: UILabel!
    @IBOutlet weak var activityTitle: UILabel!

    var isConfiguredForComment = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configureActivityLog(log: ActivityLog) {
        if let commentLog = log as? CommentActivityLog {
            self.authorLbl.text = commentLog.author
            self.commentLbl.text = commentLog.comment
            self.commentLbl.sizeToFit()
            self.entryDateLbl.text = ViewUtil.formatDate(commentLog.entryDate)
        }
    }
    
    func configureComment(comment: Comment, truncateContent: Bool = true) {
        if !self.isConfiguredForComment {
            self.activityTitle.isHidden = true
            if truncateContent {
                self.commentLbl.numberOfLines = 2
                self.commentLbl.lineBreakMode = .byTruncatingTail
            }
            self.isConfiguredForComment = true
        }
        
        self.authorLbl.text = comment.author
        self.commentLbl.text = comment.text
        self.entryDateLbl.text = ViewUtil.formatDate(comment.entryDate)

    }
    
}
