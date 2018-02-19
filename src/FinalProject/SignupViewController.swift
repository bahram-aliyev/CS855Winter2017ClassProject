//
//  SignupViewController.swift
//  FinalProject
//
//  Created by gursimran on 2017-03-31.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate, SignupModelDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameValidationLbl: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var pwdValidationLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    private var model: SignupModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = Models.initSignupModel(delegate: self)
    }
    
    // MARK: SignupModelDelegate
    
    func modelValidated(validationResult:[String:String]) {
        let nameKey = "name"
        let emailKey = "email"
        let passwordKey = "password"
        
        self.nameValidationLbl.text = validationResult[nameKey]
        self.nameValidationLbl.isHidden = !validationResult.keys.contains(nameKey)
        
        self.emailValidationLbl.text = validationResult[emailKey]
        self.emailValidationLbl.isHidden = !validationResult.keys.contains(emailKey)
        
        self.pwdValidationLbl.text = validationResult[passwordKey]
        self.pwdValidationLbl.isHidden = !validationResult.keys.contains(passwordKey)
    }
    
    func signUpFailed(cause: String) {
        self.stopProcessIndication()
        ViewUtil.showAlert(parentCtrl: self, message: cause)
    }
    
    func validationFailed() {
        self.stopProcessIndication()
    }
    
    // MARK: SignupModelDelegate : AuthenticationDelegate
    
    func authSucceed(currentUser: User) {
        self.stopProcessIndication()
        self.performSegue(withIdentifier: Segues.MainView, sender: self)
    }
    
    func authFailed() {
        self.stopProcessIndication()
        ViewUtil.showAlert(parentCtrl: self, message: UIMessages.unableToAuth)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    
    @IBAction func signUpHandler(_ sender: UIButton) {
        self.model.name = self.userNameTextField.text
        self.model.email = self.emailTextField.text
        self.model.password = self.passwordTextField.text
        
        self.startProcessIndication()
        model.signUp()
    }
    
    @IBAction func cancelHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: Helper Methods
    
    private func startProcessIndication() {
        signUpBtn.isEnabled = false
        cancelBtn.isEnabled = false
        signUpActivityIndicator.startAnimating()
    }
    
    private func stopProcessIndication() {
        signUpActivityIndicator.stopAnimating()
        signUpBtn.isEnabled = true
        cancelBtn.isEnabled = true
    }
}
