//
//  BankViewModel.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/2.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation

class BankViewModel: ViewModelType {
    
    typealias Input = BankInput
    typealias Output = BankOutput
    typealias Dependencies = HasDispatchable & HasNameDataProtocol
    
    //MARK: Properties
    private let dispatcher: Dispatchable
    private let nameList: [String]
    
    private let numberRelay: BehaviorRelay<Int>
    private let reloadTableViewRelay: PublishRelay<Void>
    private let disposeBag = DisposeBag()
    private var dataBag = DisposeBag()
    
    private var clerks: [Clerk] = []
    var cellVMs: [ClerkTableViewCellVM] = []

    //MARK: Input & Output structure
    struct BankInput {
        var clerkCountStr: Observable<String>
        var numberTakingBtnTap: ControlEvent<Void>
    }
    
    struct BankOutput {
        var waitingStr: Driver<String>
        var btnTitle: Driver<String>
        var btnValid: Driver<Bool>
        var reloadAction: Driver<Void>
    }
    
    //MARK: Init
    init(with dispatcher: Dispatchable, nameList list: NameDataProtocol) {
        self.dispatcher = dispatcher
        self.nameList = list.names
        self.numberRelay = BehaviorRelay(value: 1)
        self.reloadTableViewRelay = PublishRelay()
    }
    
    convenience init(with dependencies: Dependencies) {
        self.init(with: dependencies.dispatcher, nameList: dependencies.nameData)
    }
    
    func transform(input: Input) -> Output {
        let waitingStrDriver: Driver<String> = self.dispatcher.tasks.changedObservable
            .map { (count) -> String in
                return "waitings: \(count)"
            }
            .asDriver(onErrorJustReturn: "waitings: - ")
        
        let btnTitleDriver: Driver<String> = self.numberRelay
            .subscribeOn(MainScheduler.asyncInstance)
            .map { (count) -> String in
                "Next \(count)"
            }
            .asDriver(onErrorJustReturn: "號碼機故障")
        
        let validCount: Observable<Int> = input.clerkCountStr
            .subscribeOn(MainScheduler.asyncInstance)
            .map { (str) -> Int in
                let count = Int(str) ?? 0
                return count > 30 ? 30 : count
            }
            .distinctUntilChanged()
        
        let btnValidDriver: Driver<Bool> = validCount
            .map { (c) -> Bool in
                return c != 0
            }
            .asDriver(onErrorJustReturn: false)
                    
        validCount
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] (c) in
                self.reset(count: c)    
                self.reloadTableViewRelay.accept(())
            })
            .disposed(by: self.disposeBag)
        
        input.numberTakingBtnTap
            .subscribe(onNext: { [unowned self] () in
                self.numberTakingBtnAction()
            })
            .disposed(by: self.disposeBag)
        
        
        let reloadDriver: Driver<Void> = self.reloadTableViewRelay
            .subscribeOn(MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: ())
        
        return Output(waitingStr: waitingStrDriver, btnTitle: btnTitleDriver, btnValid: btnValidDriver, reloadAction: reloadDriver)
    }

}

//MARK: Relate to 'Task'
extension BankViewModel {
    private func numberTakingBtnAction() {
        let task = self.createTask(number: self.numberRelay.value)
        self.dispatcher.tasks.push(element: task)
        self.numberRelay.accept(self.numberRelay.value + 1)
    }
    
    private func createTask(number: Int) -> Task {
        return Task(number: number)
    }
}

//MARK: Relate to 'Model Creation'
extension BankViewModel {
    private func reset(count: Int) {
        self.dataBag = DisposeBag()
        
        self.createClerks(count: count)
        self.createCellVMs(clerks: self.clerks)
        self.dispatcher.setupTakers(self.cellVMs)
        self.numberRelay.accept(1)
    }
    
    private func createClerks(count: Int) {
        self.clerks.removeAll()
        
        for i in 0 ..< count {
            let n = Int.random(in: 0 ..< self.nameList.count)
            let performance = Double.random(in: 0.5...1.5)
            let clerk = Clerk(name: self.nameList[n], performance: performance, serialNo: i)
            self.clerks.append(clerk)
        }
    }
    
    private func createCellVMs(clerks: [Clerk]) {
        self.cellVMs.removeAll()
                
        for clerk in clerks {
            let cellVM = ClerkTableViewCellVM(with: clerk)
            self.cellVMs.append(cellVM)
        }
    }
}
