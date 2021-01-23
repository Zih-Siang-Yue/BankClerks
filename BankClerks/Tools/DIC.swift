//
//  DIC.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/23.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation

class DIC: DICProtocol {
    var services = Dictionary<String, FactoryClosure>()
    
    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure) {
        services["\(type)"] = factoryClosure
    }
    
    func resolve<Service>(type: Service.Type) -> Service? {
        return services["\(type)"]?(self) as? Service
    }
}

extension DIC {
    var dispatcher: Dispatchable {
        return resolve(type: Dispatchable.self)!
    }
    
    var nameData: NameDataProtocol {
        return resolve(type: NameDataProtocol.self)!
    }
}
