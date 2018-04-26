//
//  PersonalInformationTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/25.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PersonalInformationTableViewController: UITableViewController {
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var classIdLabel: UILabel!
    
    private let bag = DisposeBag()
    private let memberViewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = iCampusPersistence().getId() {
            memberViewModel.getMember(id: id)
                .subscribe(onNext: { [unowned self] member in
                    self.userIdLabel.text = member.userId ?? ""
                    self.nameLabel.text = member.name ?? "未填写"
                    self.phoneLabel.text = member.phone ?? ""
                    self.classIdLabel.text = member.classId ?? "未填写"
                })
                .disposed(by: bag)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
