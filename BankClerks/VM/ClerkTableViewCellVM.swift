//
//  BCTableViewCellViewModel.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/2.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ClerkTableViewCellVM: ViewModelType {

    typealias Input = ClerkCellInput
    typealias Output = ClerkCellOutput
    
    //MARK: Properties
    private let clerk: Clerk
    private let acceptTaskQueue: DispatchQueue
    private let acceptTaskScheduler: SerialDispatchQueueScheduler
    private let processedRelay: BehaviorRelay<String>
    private let stateRelay: BehaviorRelay<ClerkState>
    
    //MARK: Input & Output structure
    struct ClerkCellInput {}
    
    struct ClerkCellOutput {
        var nameStr: Driver<String>
        var processingStr: Driver<String>
        var processedStr: Driver<String>
    }
    
    //MARK: Init
    init(with clerk: Clerk) {
        self.clerk = clerk
        
        let identifier: String = "acceptTaskQueue"
        self.acceptTaskQueue = DispatchQueue(label: identifier)
        self.acceptTaskScheduler = SerialDispatchQueueScheduler(queue: self.acceptTaskQueue, internalSerialQueueName: identifier)
        self.processedRelay = BehaviorRelay(value: "")
        self.stateRelay = BehaviorRelay(value: .idle)
    }
        
    func transform(input: Input) -> Output {
        let nameDriver: Driver<String> = Driver.just(self.clerk.name)
        
        let processingDriver: Driver<String> = self.stateRelay
            .subscribeOn(self.acceptTaskScheduler)
            .map { (state) -> String in
                return state.desc
            }
            .asDriver(onErrorJustReturn: "-")
        
        return Output(nameStr: nameDriver, processingStr: processingDriver, processedStr: processedRelay.asDriver())
    }
}

extension ClerkTableViewCellVM: TaskAcceptable {
    var stateOb: Observable<ClerkState> {
        return self.stateRelay.subscribeOn(self.acceptTaskScheduler)
    }
    
    var serialNo: Int {
        return self.clerk.serialNo
    }
    
    func accept(task: Task) {
        self.stateRelay.accept(.processing(number: task.number))
        self.acceptTaskQueue.asyncAfter(deadline: .now() + self.clerk.performance) { [weak self] in
            guard let self = self else { return }
            let str = self.processedRelay.value == "" ? String(task.number) : "\(self.processedRelay.value), \(String(task.number))"
            self.processedRelay.accept(str)
            self.stateRelay.accept(.idle)
        }
    }
}
