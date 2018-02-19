//
//  ChannelListItemController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-13.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import BadgeSwift

class ChannelListItemView: UITableViewCell {

    static let channelPlaceholderImage = UIImage(named: "channel_placeholder")
    
    static var addNewPhotoGlobalHandler: ((ChannelInfo) -> Void)!
    
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastActivityLbl: UILabel!
    @IBOutlet weak var pendingLbl: BadgeSwift!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    private(set) var channelInfo: ChannelInfo!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ViewUtil.roundedCornerImage(self.thumbnailImg)
        self.addPhotoBtn.setImage(UIImage(named: "camera"), for: .normal)
        self.addPhotoBtn.setImage(UIImage(named: "camera_highlited"), for: .highlighted)
    }
    
    func configureChannelView(_ item: ChannelInfo) {
        self.channelInfo = item
        
        nameLbl.text = item.name
        lastActivityLbl.text =
            item.lastActivity != nil
                ? ViewUtil.formatDate(item.lastActivity)
                : ""
        
        pendingLbl.isHidden = (item.pending == 0)
        if !pendingLbl.isHidden {
            pendingLbl.text =
                item.pending < 9
                    ? String(item.pending)
                    : "!"
        }
        
        thumbnailImg?.image =
                item.thumbnail != nil
                    ? UIImage(data: item.thumbnail)
                    : ChannelListItemView.channelPlaceholderImage
    }

    @IBAction func addNewPhotoHandler(_ sender: UIButton) {
        ChannelListItemView.addNewPhotoGlobalHandler?(self.channelInfo)
    }
}
