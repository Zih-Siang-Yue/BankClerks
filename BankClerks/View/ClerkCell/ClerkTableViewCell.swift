//
//  ClerkTableViewCell.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/2.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import UIKit

class ClerkTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var processedLabel: UILabel!
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: ClerkTableViewCellVM? {
        didSet {
            self.binding()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binding() {
        guard let vm = self.viewModel else { return }
        let output = vm.transform(input: ClerkTableViewCellVM.Input())
        
        output.nameStr
            .drive(self.nameLabel.rx.text)
            .disposed(by: self.rx.reuseBag)
        
        output.processingStr
            .drive(self.processingLabel.rx.text)
            .disposed(by: self.rx.reuseBag)
        
        output.processedStr
            .drive(self.processedLabel.rx.text)
            .disposed(by: self.rx.reuseBag)
    }
}

