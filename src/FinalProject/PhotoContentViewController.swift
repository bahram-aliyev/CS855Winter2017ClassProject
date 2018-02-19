//
//  PhotoContentViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-03-28.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import ActiveLabel
import Toast_Swift

class PhotoContentViewController: UITableViewController, PhotoContentModelDelegate {
    
    static let CommentReuseIdentifier = "CommentLogViewCell"
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var entryDateLbl: UILabel!
    @IBOutlet weak var tagsActiveLbl: ActiveLabel!
    @IBOutlet weak var topCommentsTbl: UITableView!
    
    private var model: PhotoContentModel!
    private var topCommentsController: TopCommentsTableViewController!

    var photoInfo: PhotoInfo!
    
    let sectionsToCells = [
        // IMAGE
        0 : 2,
        // TOP COMMENTS
        1 : 2,
    ]
    
    let commentsCellPath = IndexPath(row: 0, section: 1)
    
    private var rowToDimention = [IndexPath: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = Models.initPhotoContentModel(delegate: self)
        
        self.configureDynamicRowHeght()
        
        let reuseIdentifier = PhotoContentViewController.CommentReuseIdentifier
        self.topCommentsTbl.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        // preliminary view
        self.photoImg.image = UIImage(data: self.photoInfo.thumbnail)
        
        self.model.loadData(photoInfo: self.photoInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToCells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsToCells[section]!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == commentsCellPath {
            return self.topCommentsTbl.frame.height
        }
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var consumer = segue.destination as? PhotoContentModelConsumer {
           consumer.photoContentModel = self.model
        }
    }
    
    @IBAction
    func unwindToPhotoContent(sender: UIStoryboardSegue) {
        self.model.publishActionResponder = nil
        if let identifier = sender.identifier {
            switch identifier {
                case Segues.ReturnFromCommenting:
                    self.view.makeToast(UIMessages.commentAdded)
                    break
                case Segues.ReturnFromTagging:
                    self.view.makeToast(UIMessages.tagsAdded)
                    break
                default:
                    break
            }
            //self.model.loadData(photoInfo: self.photoInfo)
        }
    }
    
    // MARK: - PhotoContentModelDelegate
    
    func hashTagsUpdated() {
        self.model.loadData(photoInfo: self.photoInfo)
    }
    
    func commentAdded() {
        self.model.loadData(photoInfo: self.photoInfo)
    }
    
    func dataLoaded(bundle: (photo:Photo, comments:[Comment]?)) {
        let photo = bundle.photo
        self.photoImg.image = UIImage(data: photo.rawImage)
        self.authorLbl.text = photo.author
        self.entryDateLbl.text = ViewUtil.formatDate(photo.entryDate)
        self.tagsActiveLbl.text = photo.hashTags
        self.topCommentsTbl.reloadData()
        self.tableView.reloadData()
    }
    
    // MARK: Helper Methods
    
    private func configureDynamicRowHeght() {
        self.topCommentsController = TopCommentsTableViewController(contentModel: self.model)
        self.topCommentsTbl.delegate = self.topCommentsController
        self.topCommentsTbl.dataSource = self.topCommentsController
        self.topCommentsTbl.rowHeight = UITableViewAutomaticDimension
        self.topCommentsTbl.estimatedRowHeight = 144
    }
    
    func setupBackButton() {
        self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(title: "Back", style: .plain, target: self,
                                action: #selector(backBtnActionHandler))
    }

    func backBtnActionHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TopComments Table Controller
    
    class TopCommentsTableViewController : NSObject, UITableViewDelegate, UITableViewDataSource {
        
        private var contentModel: PhotoContentModel
        
        init(contentModel: PhotoContentModel) {
            self.contentModel = contentModel
            super.init()
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return
                self.contentModel.commentsCount
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentReuseIdentifier, for: indexPath)
            
            if let commentCell = cell as? CommentLogViewCell {
                commentCell.configureComment(comment: self.contentModel.getComment(index: indexPath.row))
            }
            
            return cell
        }
    }
}
