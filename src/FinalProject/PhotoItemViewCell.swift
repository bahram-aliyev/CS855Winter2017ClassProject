//
//  ImageCollectionViewCell.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-27.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import BadgeSwift

class PhotoItemViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var pendingLbl: BadgeSwift!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurePhoto(photoInfo: PhotoInfo) {
        pendingLbl.isHidden = (photoInfo.pending == 0)
        if !pendingLbl.isHidden {
            pendingLbl.text =
                photoInfo.pending < 9
                ? String(photoInfo.pending)
                : "!"
        }
        
        thumbnailImg?.image = UIImage(data: photoInfo.thumbnail)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ViewUtil.roundedCornerImage(self.thumbnailImg)
    }

}
