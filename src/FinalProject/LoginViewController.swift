//
//  LoginViewController.swift
//  FinalProject
//
//  Created by gursimran on 2017-03-31.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, LoginModelDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    private var model: LoginModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = Models.initLoginModel(delegate: self)
    }
    
    // MARK: LoginModelDelegate
    
    func loginFailed(cause: String) {
        self.stopProcessIndication()
        ViewUtil.showAlert(parentCtrl: self, message: cause)
    }
    
    // MARK: LoginModelDelegate : AuthenticationDelegate
    
    func authSucceed(currentUser: User) {
        self.stopProcessIndication()
        self.performSegue(withIdentifier: Segues.MainView, sender: self)
    }
    
    func authFailed(){
        self.stopProcessIndication()
        ViewUtil.showAlert(parentCtrl: self, message: UIMessages.unableToAuth)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Navigation
    
    @IBAction
    func unwindToLogin(sender: UIStoryboardSegue) {
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
        self.loginActivityIndicator.stopAnimating()
    }

    // MARK: Actions
    
    @IBAction func logInHandler(_ sender: Any) {
        self.model.email = self.emailTextField.text
        self.model.password = self.passwordTextField.text
        
        self.startProcessIndication()
        self.model.login()
    }
    
    // MARK: Helper Hethods
    
    private func startProcessIndication() {
        loginBtn.isEnabled = false
        signUpBtn.isEnabled = false
        loginActivityIndicator.startAnimating()
    }
    
    private func stopProcessIndication() {
        loginActivityIndicator.stopAnimating()
        loginBtn.isEnabled = true
        signUpBtn.isEnabled = true
    }
}
    

