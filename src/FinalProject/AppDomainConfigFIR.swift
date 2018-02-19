//
//  AppDomainConfigFIR.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-05.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation
import Firebase

class AppDomainConfigFIR : AppDomainConfig {
    func configure() {
        //For configuration of Firebase in the application
        FIRApp.configure()
        
        //Enables disk persistence
        FIRDatabase.database().persistenceEnabled = true
    }
}
