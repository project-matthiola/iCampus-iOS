//
//  RequestTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PKHUD

class RequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var requestStatusLabel: UILabel!
    @IBOutlet weak var requestTypeLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        requestStatusLabel.layer.cornerRadius = 5.0
        requestStatusLabel.layer.masksToBounds = true
        requestTypeLabel.layer.cornerRadius = 5.0
        requestTypeLabel.layer.masksToBounds = true
    }
}

class RequestTableViewController: UITableViewController {

    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    private let bag = DisposeBag()
    private let requestViewModel = RequestViewModel()
    private var sections = BehaviorRelay<[SectionOfRequest]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = nil
        
        addButtonItem.rx.tap
            .bind { [unowned self] in self.showSheet() }
            .disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfRequest>(configureCell: { (_, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "RequestTableViewCell", for: ip) as! RequestTableViewCell
            cell.timeLabel.text = CustomDateTransform().transformToJSON(item.requestTime)
            cell.requestStatusLabel.text = item.status?.text
            cell.requestTypeLabel.text = item.requestType?.text
            cell.mainTextLabel.text = item.text
            
            switch item.status! {
            case .tbd:
                cell.requestStatusLabel.backgroundColor = .gray
            case .approved:
                cell.requestStatusLabel.backgroundColor = .midori
            case .rejected:
                cell.requestStatusLabel.backgroundColor = .red
            }
            
            switch item.requestType! {
            case .scholar:
                cell.requestTypeLabel.backgroundColor = .wasurenagusa
            case .leave:
                cell.requestTypeLabel.backgroundColor = .ake
            }
            
            return cell
        })
        
        sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let member = iCampusPersistence().getMember() {
            requestViewModel
                .getRequests(by: member.userId!)
                .subscribe(onNext: { self.sections.accept([SectionOfRequest(items: $0)]) })
                .disposed(by: bag)
        }
    }
    
    fileprivate func showSheet() {
        let sheet = UIAlertController(title: "新建申请", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "请假", style: .default) { [unowned self] _ in self.performSegue(withIdentifier: "AddRequestSegue", sender: RequestType.leave) })
        sheet.addAction(UIAlertAction(title: "奖学金", style: .default) { [unowned self] _ in self.performSegue(withIdentifier: "AddRequestSegue", sender: RequestType.scholar) })
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRequestSegue" {
            let addRequestTableViewController = segue.destination as! AddRequestTableViewController
            addRequestTableViewController.requestType = (sender as! RequestType)
        }
    }
    
}
