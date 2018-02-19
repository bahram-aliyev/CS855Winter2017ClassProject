//
//  HashtagViewController.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-10.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit
import ActiveLabel

class HashtagViewController: UIViewController, UITextFieldDelegate, PhotoContentModelConsumer {

    @IBOutlet weak var hashtagsTxt: UITextField!
    @IBOutlet weak var hashtagLbl: ActiveLabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var modalView: UIView!
    
    var photoContentModel: PhotoContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.photoContentModel.publishActionResponder = self.publishHashtagResponder
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string == " ") {
            if let rawHastag = textField.text {
                
                let hashtag =
                        rawHastag.components(separatedBy: CharacterSet.alphanumerics.inverted)
                                    .joined(separator: "")
                
                if !hashtag.isEmpty {
                    if let currentText = self.hashtagLbl.text {
                        self.hashtagLbl.text =
                                currentText.isEmpty ? "#\(hashtag)"
                                                    : "#\(hashtag) " + currentText
                    }
                    else {
                        self.hashtagLbl.text = "#\(hashtag)"
                    }
                }
            }
            self.hashtagsTxt.text = nil
        }
        return true
    }
    
    // MARK: Action Handlers
    
    @IBAction func submitHandler(_ sender: Any) {
        if !(hashtagLbl.text?.isEmpty ?? true) {
            self.submitBtn.isEnabled = false
            self.photoContentModel.addHashTags(hashTags: hashtagLbl.text!)
        }
    }
    
    @IBAction func cancelHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: publishActionResponder
    
    func publishHashtagResponder(error: Error?) {
        if let error = error {
            self.submitBtn.isEnabled = true
            ViewUtil.showAlert(parentCtrl: self, message: error.localizedDescription)
            return
        }
        
        self.performSegue(withIdentifier: Segues.ReturnFromTagging, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Helper Hethods
    
    func configureView() {
        hashtagLbl.layer.borderWidth = 0.4
        hashtagLbl.layer.borderColor = UIColor.blue.cgColor
        
        submitBtn.layer.borderWidth = 0.4
        submitBtn.layer.borderColor = UIColor.blue.cgColor
        
        cancelBtn.layer.borderWidth = 0.4
        cancelBtn.layer.borderColor = UIColor.blue.cgColor
        
        modalView.layer.borderColor = modalView.backgroundColor?.cgColor
        modalView.layer.cornerRadius = 8
        modalView.layer.borderWidth = 4
        
        self.hashtagsTxt.becomeFirstResponder()
    }

}
