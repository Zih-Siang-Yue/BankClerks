//
//  Taker.swift
//  BankClerks
//
//  Created by Sean.Yue on 2021/1/13.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation
import RxSwift

protocol TaskAcceptable {
    var serialNo: Int { get }
    var stateOb: Observable<ClerkState> { get }

    func accept(task: Taskable)
}

