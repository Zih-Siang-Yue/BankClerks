//
//  UITableViewCell+Reactive.swift
//  BankClerks
//
//  Created by Sean.Yue on 2021/1/6.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UITableViewCell {
    public var prepareForReuse: RxSwift.Observable<Void> {
        var prepareForReuseKey: Int8 = 0
        if let prepareForReuseOB = objc_getAssociatedObject(base, &prepareForReuseKey) as? Observable<Void> {
            return prepareForReuseOB
        }

        let prepareForReuseOB = Observable.of(
            sentMessage(#selector(Base.prepareForReuse)).map { _ in }
            , deallocated)
            .merge()
        objc_setAssociatedObject(base, &prepareForReuseKey, prepareForReuseOB, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        return prepareForReuseOB
    }
    
    public var reuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        var prepareForReuseBag: Int8 = 0
        if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = sentMessage(#selector(Base.prepareForReuse))
            .subscribe(onNext: { [weak base] _ in
                let newBag = DisposeBag()
                guard let base = base else {return}
                objc_setAssociatedObject(base, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })
        return bag
    }
}
