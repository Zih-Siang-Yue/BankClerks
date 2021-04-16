//
//  Dispatchable.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/23.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation

protocol Dispatchable {
    var tasks: ThreadSafetyArray<Taskable> { get set }
    var takers: ThreadSafetyArray<TaskAcceptable> { get set }
    var disposeBag: DisposeBag { get set }
    
    func setupTakers(_ takers: [TaskAcceptable])
}

