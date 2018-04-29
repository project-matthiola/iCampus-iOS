//
//  NewsDetailTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/29.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class NewsDetailTableViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var mainTextView: UITextView!
    
    private let bag = DisposeBag()
    private let newsViewModel = NewsViewModel()
    
    var newsId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsViewModel
            .getNews(by: newsId!)
            .share(replay: 1)
            .subscribe(onNext: { [unowned self] news in
                self.titleLabel.text = news.title
                self.timeLabel.text = CustomDateTransform().transformToJSON(news.newsTime)
                self.authorLabel.text = news.author
                self.mainTextView.text = news.text
                
                if news.text == nil {
                    self.mainTextView.backgroundColor = .none
                    if let cell = self.mainTextView.superview?.superview as? UITableViewCell {
                        cell.backgroundColor = .none
                    }
                } else {
                    self.mainTextView.text = news.text
                }
            }, onCompleted: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
            .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
