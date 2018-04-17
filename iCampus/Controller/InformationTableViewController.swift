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
	private var sections = [SectionOfInformation]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.dataSource = nil
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionOfInformation>(configureCell: { (_, tv, ip, item) in
			let cell = tv.dequeueReusableCell(withIdentifier: "InformationTableViewCell", for: ip)
			cell.textLabel?.text = item.title
			return cell
		})
		
		informationViewModel.getInformations()
			.subscribe { event in
				switch event {
				case .next(let information):
					self.sections.append(SectionOfInformation(items: information))
				case .error(let error):
					HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 2.0)
				case .completed:
					Observable.just(self.sections)
						.bind(to: self.tableView.rx.items(dataSource: dataSource))
						.disposed(by: self.bag)
				}
			}
			.disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
