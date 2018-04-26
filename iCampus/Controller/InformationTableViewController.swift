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

class InformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
}

class InformationTableViewController: UITableViewController {
    
    private let bag = DisposeBag()
    private let informationViewModel = InformationViewModel()
    private var sections = BehaviorRelay<[SectionOfInformation]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = nil
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfInformation>(configureCell: { (_, tv, ip, item) in
            // swiftlint:disable force_cast
            let cell = tv.dequeueReusableCell(withIdentifier: "InformationTableViewCell", for: ip) as! InformationTableViewCell
            cell.titleLabel.text = item.title
            cell.sourceLabel.text = item.source
            cell.timeLabel.text = CustomDateTransform().transformToJSON(item.informationTime)
            cell.locationLabel.text = item.place
            return cell
        })
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe { [unowned self] _ in
                self.getInformations()
                refreshControl.endRefreshing()
            }
            .disposed(by: bag)
        
        getInformations()
        sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    fileprivate func getInformations() {
        informationViewModel.getInformations()
            .subscribe { event in
                switch event {
                case .next(let information):
                    self.sections.accept([SectionOfInformation(items: information)])
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
}
