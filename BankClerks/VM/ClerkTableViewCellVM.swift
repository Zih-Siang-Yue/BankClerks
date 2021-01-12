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
    
    private let clerk: Clerk
    var stateRelay: BehaviorRelay<ClerkState>
    var processedRelay: BehaviorRelay<String>
    
    
    struct ClerkCellInput {}
    
    struct ClerkCellOutput {
        var nameStr: Driver<String>
        var processingStr: Driver<String>
        var processedStr: Driver<String>
    }
    
    init(with clerk: Clerk) {
        self.clerk = clerk
        self.stateRelay = BehaviorRelay(value: .idle)
        self.processedRelay = BehaviorRelay(value: "")
    }
        
    func transform(input: Input) -> Output {
        let nameDriver: Driver<String> = Driver.just(self.clerk.name)
        
        let processingDriver: Driver<String> = self.stateRelay    
            .observeOn(MainScheduler.asyncInstance)
            .map { (state) -> String in
                return state.desc
            }
            .asDriver(onErrorJustReturn: "-")
        
        return Output(nameStr: nameDriver, processingStr: processingDriver, processedStr: processedRelay.asDriver())
    }

    //Public func
    func accept(task: Task) {
        let queue = DispatchQueue(label: "acceptTaskQueue")
        queue.sync {
            self.stateRelay.accept(.processing(number: task.number))
            DispatchQueue.main.asyncAfter(deadline: .now() + self.clerk.performance) { [weak self] in
                guard let self = self else { return }
                let str = self.processedRelay.value == "" ? String(task.number) : "\(self.processedRelay.value), \(String(task.number))"
                self.processedRelay.accept(str)
                self.stateRelay.accept(.idle)
            }
        }
    }
}
