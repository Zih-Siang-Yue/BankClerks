//
//  Clerk.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/2.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import Foundation

enum ClerkState: Equatable {
    case idle
    case processing(number: Int)
    
    var desc: String {
        switch self {
        case .idle: return "idle"
        case .processing(let n): return "\(n)"
        }
    }
}

struct Clerk {
    var name: String
    var performance: Double
}

