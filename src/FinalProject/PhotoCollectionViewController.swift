//
//  PhotoCollectionViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-27.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import Toast_Swift

class PhotoCollectionViewController: UICollectionViewController,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate,
        PhotoCollectionModelDelegate,
        UISearchBarDelegate {
    
    private let reuseIdentifier = "PhotoItem"
    
    private let subscriberTicket = "PhotoCollectionViewController"
    
    private var model: PhotoCollectionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = Models.initPhotoCollectionModel(delegate: self)
        
        self.model.sourceChannel =
                (self.tabBarController as? ChannelContentViewController)?.channel
        self.configureView(chnlInfo: self.model.sourceChannel)
        
        self.model.beginListenActivityChanges()
        self.model.loadPhotos()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.PhotoContent {
            var photoContentController: PhotoContentViewController!
            
            if let photoContentCtrlTmp = segue.destination as? PhotoContentViewController {
                photoContentController = photoContentCtrlTmp
            }
            else if let navigationCtrl = segue.destination as? UINavigationController,
                let photoContentCtrlTmp = navigationCtrl.viewControllers.first as? PhotoContentViewController {
                photoContentController = photoContentCtrlTmp
                photoContentController.setupBackButton()
            }
            
            let indexPath = self.collectionView?.indexPath(for: sender as!PhotoItemViewCell)
            
            let photoInfo = model.getItem(itemIndex: indexPath!.row)
            self.model.clearPhotoPending(photoInfo: photoInfo)
            self.collectionView?.reloadItems(at: [indexPath!])
            photoContentController?.photoInfo = model.getItem(itemIndex: indexPath!.row)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.itemsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
        
        // Configure the cell
        (cell as? PhotoItemViewCell)?.configurePhoto(photoInfo: model.getItem(itemIndex: indexPath.row))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.performSegue(withIdentifier: Segues.PhotoContent, sender: collectionView.cellForItem(at: indexPath))
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("The appication was not able to retrive the selected image due to the follwing reason: '\(info)'")
        }
        
        self.model.publishPhoto(rawImage:  ViewUtil.resizeForTransfer(image: image))
        self.view.makeToastActivity(.center)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.model.searchByTags(searchClause: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.model.reloadPhotos()
    }
    
    // MARK: - PhotoCollectionModelDelegate
    
    func photosReloaded() {
        self.collectionView?.reloadData()
    }
    
    func photosLoaded() {
        self.collectionView?.reloadData()
    }
    
    // MARK: - PhotoCollectionModelDelegate: PhotoPublisherDelegate
    
    func photoPublisingCompleted(error: Error!) {
        self.view.hideToastActivity()
        if let error = error {
            ViewUtil.showAlert(parentCtrl: self, message: error.localizedDescription)
        }
        else {
            self.view.makeToast(UIMessages.photoPublished)
            self.model.loadPhotos()
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - Action Handlers
    
    @IBAction func addImageHandler(_ sender: Any) {
        ViewUtil.showImagePicker(imagePickerDelegate: self)
    }
    
    // MARK: - Helper Methods
    
    func configureView(chnlInfo: ChannelInfo!) {
        
        self.collectionView!.register(UINib(nibName: "PhotoItemViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: self.reuseIdentifier)
        ViewUtil.configureFlowLayout(collectionView: self.collectionView!)
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search in " + (chnlInfo != nil ? chnlInfo.name :  self.navigationItem.title!)
        self.navigationItem.titleView = searchBar
    }
    
    // MARK: deinit - unsibscribe from the mediator
    deinit {
        self.model?.stopListenActivityChanges()
    }
}
