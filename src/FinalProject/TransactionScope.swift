//
//  TransactionScope.swift
//  FinalProject
//
//  Created by Bahram Aliyev on 2017-04-08.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

protocol TransactionScope {
    func execute(context: @escaping () -> Void, completion: @escaping (Error?) -> Void)
}
