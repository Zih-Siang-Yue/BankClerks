//
//  BankViewController.swift
//  BankClerks
//
//  Created by Zih-Siang Yue on 2021/1/2.
//  Copyright © 2021 Zih-Siang Yue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BankViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clerkCountTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waitingsLabel: UILabel!
    @IBOutlet weak var numberTakingBtn: UIButton!
    
    private var viewModel: BankViewModel
    
    //MARK: init
    init(vm: BankViewModel) {
        self.viewModel = vm
        super.init(nibName: BankViewController.typeName, bundle: nil)
    }
        
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = BankViewModel(with: Dispatcher(), nameList: NameData.names)
        super.init(coder: aDecoder)
    }

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.basicSetting()
        self.binding()
    }
    
    //MARK: Setting
    private func basicSetting() {
        self.setupTableView()
        self.setupNumberTakingBtn()
        self.setupDismissKeyboard()
    }
        
    private func setupTableView() {
        self.tableView.registerNib(cellType: ClerkTableViewCell.self)
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupNumberTakingBtn() {
        self.numberTakingBtn.layer.cornerRadius = 5
    }
    
    private func setupDismissKeyboard() {
        let tap = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tap)
        _ = tap.rx.event
            .bind(onNext: { [unowned self] (recognizer) in
                self.view.endEditing(true)
            })
            .disposed(by: self.disposeBag)
    }

    //MARK: Binding
    private func binding() {
        let clerkCountTFOb = self.clerkCountTextField.rx.text.orEmpty.asObservable()
        let numberTakingBtnTap = self.numberTakingBtn.rx.tap
        
        let input = BankViewModel.Input(clerkCountStr: clerkCountTFOb, numberTakingBtnTap: numberTakingBtnTap)
        let output = self.viewModel.transform(input: input)
        
        output.btnValid
            .drive(onNext: { [weak self] (valid) in
                guard let self = self else { return }
                let textColor: UIColor = valid ? .white : .lightGray
                let bgColor: UIColor = valid ? .systemPurple : .darkGray
                self.numberTakingBtn.setTitleColor(textColor, for: .normal)
                self.numberTakingBtn.backgroundColor = bgColor
                self.numberTakingBtn.isEnabled = valid
            })
            .disposed(by: self.disposeBag)

        output.btnTitle
            .drive(self.numberTakingBtn.rx.title())
            .disposed(by: self.disposeBag)
        
        output.waitingStr
            .drive(self.waitingsLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.reloadAction
            .drive(onNext: { [unowned self] in
                self.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
}

extension BankViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cellVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ClerkTableViewCell.self, for: indexPath)
        cell.viewModel = self.viewModel.cellVMs[indexPath.row]
        return cell
    }
}

