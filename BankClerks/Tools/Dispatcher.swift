//
//  Dispatcher.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/2.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Dispatcher {
    var tasks: ThreadSafetyArray<Taskable>
    var takers: ThreadSafetyArray<TaskAcceptable>
    private var disposeBag: DisposeBag = DisposeBag()
    
    //MARK: Init
    init() {
        self.tasks = ThreadSafetyArray()
        self.takers = ThreadSafetyArray()
    }
    
    public func setupTakers(_ takers: [TaskAcceptable]) {
        self.disposeBag = DisposeBag()
        self.tasks.removeAll()
        self.takers.removeAll()
        
        self.takers.set(elements: takers)
        self.subscribeTaskAssignment()
        self.subscribeTakersState(takers)
    }
    
    private func subscribeTaskAssignment() {
        let assignmentQueue = DispatchQueue(label: "assignmentQueue")
        let scheduler = SerialDispatchQueueScheduler(queue: assignmentQueue, internalSerialQueueName: "assignmentQueue")
        
        Observable
            .combineLatest(self.takers.changedObservable, self.tasks.changedObservable)
            .observeOn(scheduler)
            .filter({ [unowned self] (_) -> Bool in
                return self.takers.count > 0 && self.tasks.count > 0
            })
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self,
                      let firstTaker = self.takers.removeFirst(),
                      let firstTask = self.tasks.removeFirst() else { return }
                firstTaker.accept(task: firstTask)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func subscribeTakersState(_ takers: [TaskAcceptable]) {
        takers.forEach { (taker) in
            taker.stateOb
                .observeOn(self.takers.scheduler)
                .skip(1)
                .filter({ (state) -> Bool in
                    state == .idle
                })
                .subscribe(onNext: { [unowned self] (_) in
                    self.takers.push(element: taker)
                })
                .disposed(by: self.disposeBag)
        }
    }
}
