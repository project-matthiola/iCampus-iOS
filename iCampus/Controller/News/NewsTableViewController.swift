//
//  NewsTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/26.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PKHUD

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
}

class NewsTableViewController: UITableViewController {

    private let bag = DisposeBag()
    private let newsViewModel = NewsViewModel()
    private var sections = BehaviorRelay<[SectionOfNews]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = nil
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfNews>(configureCell: { (_, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: ip) as! NewsTableViewCell
            cell.titleLabel.text = item.title
            cell.timeLabel.text = CustomDateTransform().transformToJSON(item.newsTime)
            return cell
        })
        
        sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        getNews()
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe { [unowned self] _ in
                self.getNews()
                refreshControl.endRefreshing()
            }
            .disposed(by: bag)
    }
    
    fileprivate func getNews() {
        newsViewModel
            .getNews()
            .subscribe(onNext: {
                self.sections.accept([SectionOfNews(items: $0)])
            }, onError: { error in
                ErrorHandler().showErrorHUD(subtitle: error.localizedDescription)
            })
            .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }

}
