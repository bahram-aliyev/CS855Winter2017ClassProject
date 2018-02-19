//
//  CommentViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-10.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITextViewDelegate, PhotoContentModelConsumer {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var modalView: UIView!

    var photoContentModel: PhotoContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.photoContentModel.publishActionResponder = self.publishCommentResponder
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    @IBAction func submitHandler(_ sender: UIButton) {
        if let comment = commentTxt.text?.trimmingCharacters(in: .whitespaces) {
            if !comment.isEmpty {
                self.photoContentModel.addComment(text: comment)
            }
        }
    }
    
    @IBAction func cancelHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: publishActionResponder
    
    func publishCommentResponder(error: Error?) {
        if let error = error {
            self.submitBtn.isEnabled = true
            ViewUtil.showAlert(parentCtrl: self, message: error.localizedDescription)
            return
        }
        
        self.performSegue(withIdentifier: Segues.ReturnFromCommenting, sender: self)
    }
    
    // MARK: Helper Methods
    
    private func configureView() {
        self.commentTxt.delegate = self
        
        commentTxt.layer.cornerRadius = 5
        commentTxt.layer.borderWidth = 0.4
        commentTxt.layer.borderColor = UIColor(red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0).cgColor
        
        submitBtn.layer.borderWidth = 0.4
        submitBtn.layer.borderColor = UIColor.blue.cgColor
        
        cancelBtn.layer.borderWidth = 0.4
        cancelBtn.layer.borderColor = UIColor.blue.cgColor
        
        modalView.layer.borderColor = modalView.backgroundColor?.cgColor
        modalView.layer.cornerRadius = 8
        modalView.layer.borderWidth = 4
        
        commentTxt.becomeFirstResponder()
    }

}
