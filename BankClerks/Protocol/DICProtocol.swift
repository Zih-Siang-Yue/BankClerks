//
//  DICProtocol.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/23.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation

typealias FactoryClosure = (DIC) -> AnyObject

protocol DICProtocol: HasDispatchable, HasNameDataProtocol {
    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure)
    func resolve<Service>(type: Service.Type) -> Service?
}

protocol HasDispatchable {
    var dispatcher: Dispatchable { get }
}

protocol HasNameDataProtocol {
    var nameData: NameDataProtocol { get }
}
