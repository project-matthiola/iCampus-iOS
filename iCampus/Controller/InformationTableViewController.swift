//
//  InformationTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/17.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PKHUD

class InformationTableViewController: UITableViewController {

	private let bag = DisposeBag()
	private let informationViewModel = InformationViewModel()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let dataSource = RxTableViewSectionedReloadDataSource<SectionOfInformation>(configureCell: { (_, tv, ip, item) in
			let cell = tv.dequeueReusableCell(withIdentifier: "InformationTableViewCell", for: ip)
			cell.textLabel?.text = item.title
			return cell
		})
		
		informationViewModel.getInformations()
			.subscribe { event in
				switch event {
				case .next(let information):
					print(information)
				case .error(let error):
					HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 2.0)
				case .completed:
					return
				}
			}
			.disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
