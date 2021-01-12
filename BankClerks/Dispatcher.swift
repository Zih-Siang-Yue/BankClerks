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

    lazy var tasksChanged: Observable<Int> = self.taskCountRelay.asObservable()

    private var tasks: [Task] = []
    private var taskCountRelay: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    private let taskQueue = DispatchQueue(label: "taskQueue", attributes: .concurrent)
    
    func push(_ task: Task) {
        self.taskQueue.sync {
            self.tasks.append(task)
            self.taskCountRelay.accept(self.tasks.count)
        }
    }

    func pop() -> Task? {
        self.taskQueue.sync {
            if self.tasks.isEmpty { return nil }
            let task = self.tasks.removeFirst()
            self.taskCountRelay.accept(self.tasks.count)
            return task
        }
    }

    func removeAllTask() {
        self.taskQueue.sync {
            self.tasks.removeAll()
            self.taskCountRelay.accept(0)
        }
    }
}
