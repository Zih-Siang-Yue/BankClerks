//
//  ThreadSafetyCollectable.swift
//  BankClerks
//
//  Created by Sean.Yue on 2021/1/15.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation

protocol ThreadSafetyCollectable {
    associatedtype Element
    
    var collection: [Element] { get set }
    var count: Int { get }
    var queue: DispatchQueue { get }
    var scheduler: SerialDispatchQueueScheduler { get }
    
    var countRelay: BehaviorRelay<Int> { get }
    var changedObservable: Observable<Int> { get }

    func set(elements: [Element])
    func push(element: Element)
    func removeFirst() -> Element?
    func removeLast() -> Element?
    func removeAll()
}
