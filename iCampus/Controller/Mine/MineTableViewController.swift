//
//  MineTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/25.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MineTableViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    private let memberViewModel = MemberViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = 10.0
        avatarImageView.layer.masksToBounds = true
        
        if let member = iCampusPersistence().getMember() {
            memberViewModel
                .getAvatar(id: member.id)
                .bind(to: avatarImageView.rx.image)
                .disposed(by: bag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let member = iCampusPersistence().getMember() {
            self.configureLabel(member.name ?? "未填写", member.userId!)
        }
    }
    
    fileprivate func configureLabel(_ name: String, _ userId: String) {
        nameLabel.text = name
        userIdLabel.text = userId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
