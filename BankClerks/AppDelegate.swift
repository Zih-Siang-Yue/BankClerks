//
//  AppDelegate.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/2.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white

        let dic: DICProtocol = self.registerPropertiesIntoDIC()
        let vm = BankViewModel(with: dic)
        let vc = BankViewController(vm: vm)

        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func registerPropertiesIntoDIC() -> DICProtocol {
        let dic = DIC()
        dic.register(type: Dispatchable.self) { (_) in return Dispatcher() }
        dic.register(type: NameDataProtocol.self) { (_) in return NameData() }
        return dic
    }

}

