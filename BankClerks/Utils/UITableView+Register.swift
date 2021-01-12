//
//  UITableView+Register.swift
//  BankCounter
//
//  Created by Sean.Yue on 2020/12/30.
//

import UIKit

public extension UITableView {
    
    func registerNib<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.typeName, bundle: nil)
        register(nib, forCellReuseIdentifier: cellType.typeName)
    }
    
    func registerNib<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { registerNib(cellType: $0) }
    }
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.typeName)
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.typeName, for: indexPath) as! T
    }
    
}
