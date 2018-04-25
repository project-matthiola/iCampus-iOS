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

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var userIdLabel: UILabel!
	
	private let bag = DisposeBag()
	private let memberViewModel = MemberViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if let id = iCampusPersistence().getId() {
			memberViewModel.getMember(id: id)
				.subscribe(onNext: { member in
					self.configureLabel(member.name ?? "", member.userId!)
				})
				.disposed(by: bag)
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
