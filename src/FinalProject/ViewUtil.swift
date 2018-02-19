//
//  Util.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-13.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class ViewUtil {
    
    private static var dateFormatter: DateFormatter!
    
    private static let leftAndRightPaddings: CGFloat = 2.0
    private static let numberOfItemsPerRow: CGFloat = 3.0
    
    static func formatDate(_ date: Date) -> String {
        if self.dateFormatter == nil {
            let dueDateFormatter = DateFormatter()
            dueDateFormatter.dateStyle = .medium
            dueDateFormatter.timeStyle = .short
            self.dateFormatter = dueDateFormatter
        }
        
        return self.dateFormatter.string(from: date)
    }
    
    static func circularImage(_ imageView: UIImageView) {
        self.prepareImage(imageView)
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    static func roundedCornerImage(_ imageView: UIImageView) {
        self.prepareImage(imageView)
        imageView.layer.cornerRadius = 10.0
    }
    
    // http://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    static func resizeImage(image: UIImage, width: Float, height: Float, quality: Float = 1) -> Data {
        let size = image.size
        
        let widthRatio  = CGFloat(width)  / image.size.width
        let heightRatio = CGFloat(height) / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageJPEGRepresentation(newImage!, CGFloat(quality))!
    }
    
    // Quality reference
    // http://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
    
    static func resizeForTransfer(image: UIImage) -> Data {
        // 1.3 MP http://www.discount-security-cameras.net/cctv-video-resolutions.aspx
        return self.resizeImage(image: image, width: 1280, height: 1024, quality: 0.5)
    }
    
    static func resizeForThumbnail(image: UIImage) -> Data {
        // CIF http://www.discount-security-cameras.net/cctv-video-resolutions.aspx
        return self.resizeImage(image: image, width: 352, height: 240, quality: 0.75)
    }
    
    static func configureFlowLayout(collectionView: UICollectionView) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let viewWidth = collectionView.frame.width
        let itemSize = round((viewWidth - self.leftAndRightPaddings) / self.numberOfItemsPerRow) - 1
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
    
    static func showAlert(parentCtrl: UIViewController, title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        parentCtrl.present(alertController, animated: true, completion: nil)
    }
    
    static func showImagePicker(imagePickerDelegate: UIViewController,
                                sourceType: UIImagePickerControllerSourceType = .camera) {
        // prepare image picker to show up
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = imagePickerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerController.sourceType =
            (!UIImagePickerController.isSourceTypeAvailable(.camera)) ? .photoLibrary : .camera
        
        imagePickerDelegate.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Helper Methods
    private static func prepareImage(_ imageView: UIImageView) {
        let layer = imageView.layer
        layer.borderWidth = 1
        layer.masksToBounds = false
        imageView.clipsToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
    }
    

    
}
