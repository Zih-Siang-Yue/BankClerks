//
//  ThreadSafetyArray.swift
//  BankClerks
//
//  Created by Sean.Yue on 2021/1/15.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ThreadSafetyArray<T>: ThreadSafetyCollectable {

    typealias Element = T

    var collection: [T]
    var count: Int {
        return self.collection.count
    }
    
    var queue: DispatchQueue
    var scheduler: SerialDispatchQueueScheduler
    var countRelay: BehaviorRelay<Int>
    var changedObservable: Observable<Int>
    
    init() {
        self.collection = []
        
        let text = String(describing: T.self)
        self.queue = DispatchQueue(label: text, attributes: .concurrent)
        self.scheduler = SerialDispatchQueueScheduler(queue: self.queue, internalSerialQueueName: text)

        self.countRelay = BehaviorRelay(value: 0)
        self.changedObservable = self.countRelay.subscribeOn(self.scheduler).asObservable()
    }
    
    func set(elements: [T]) {
        self.collection = elements
        self.countRelay.accept(elements.count)
    }
    
    func push(element: T) {
        self.queue.async(flags: .barrier) {
            self.collection.append(element)
            self.countRelay.accept(self.collection.count)
        }
    }
    
    func removeFirst() -> T? {
        var element: T? = nil
        self.queue.sync {
            if self.collection.isEmpty {
                return
            }
            element = self.collection.removeFirst()
            self.countRelay.accept(self.collection.count)
        }
        return element
    }
    
    func removeLast() -> T? {
        var element: T? = nil
        self.queue.sync {
            if self.collection.isEmpty {
                return
            }
            element = self.collection.removeLast()
            self.countRelay.accept(self.collection.count)
        }
        return element
    }
    
    func removeAll() {
        self.queue.sync {
            self.collection.removeAll()
            self.countRelay.accept(0)
        }
    }
}


