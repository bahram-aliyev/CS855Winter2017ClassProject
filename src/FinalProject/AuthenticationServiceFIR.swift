//
//  FirebaseAuthenticationService.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase


class AuthenticationServiceFIR : AuthenticationService {
    
    func logout() {
        _ = try? FIRAuth.auth()?.signOut()
    }

    
    var authHandle: FIRAuthStateDidChangeListenerHandle!
    
    func signUp(request: SignupRequest, authCallback: @escaping (AuthResponse) -> Void) {
        FIRAuth.auth()?
                .createUser(withEmail: request.email, password: request.password,
                                completion: {
                                    (user, error) in
                                        if let user = user {
                                            FIRDatabase.users.child(user.uid).setValue(
                                                [
                                                    "email" : request.email,
                                                    "name": request.name
                                                ]
                                            )
                                        
                                            let currentUser = User(id: user.uid, email: request.email, name: request.name)
                                            authCallback(AuthResponse(user: currentUser))
                                        }
                                        else {
                                            authCallback(AuthResponse(erroMessage: error?.localizedDescription))
                                        }
                                    })
    }

    func signIn(request: SigninRequest, authCallback: @escaping (AuthResponse) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: request.email, password: request.password,
                                    completion: {
                                        (user, error) in
                                            if let user = user {
                                                self.fetchUser(uid: user.uid, callback: authCallback)
                                            }
                                            else {
                                                authCallback(AuthResponse(erroMessage: error?.localizedDescription))
                                            }
                                    })
    }
    
    func signIn(authCallback: @escaping (AuthResponse) -> Void) {
        self.authHandle = FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if self.authHandle != nil {
                if let currentUser = user {
                    self.fetchUser(uid: currentUser.uid, callback: authCallback)
                } else {
                    authCallback(AuthResponse())
                }
            }
        }
    }
    
    private func fetchUser(uid: String, callback: @escaping (AuthResponse) -> Void) {
        if self.authHandle != nil {
            FIRAuth.auth()?.removeStateDidChangeListener(self.authHandle)
            self.authHandle = nil
        }
        
        FIRDatabase
            .users
                .child(uid)
                    .observeSingleEvent(of:.value, with: {
                                        (result) in
                                            if let rawUser = result.value as? NSDictionary {
                                                let userEmail = rawUser["email"] as? String ?? ""
                                                let userName = rawUser["name"] as? String ?? ""
                                                let currentUser = User(id: uid, email: userEmail, name: userName)
                                                callback(AuthResponse(user: currentUser))
                                            }
                                            else {
                                                callback(AuthResponse(erroMessage: "Relogin required."))
                                            }
                                    }, withCancel: {
                                        (error) in
                                            callback(AuthResponse(erroMessage: error.localizedDescription))
                                    })
    }
}
