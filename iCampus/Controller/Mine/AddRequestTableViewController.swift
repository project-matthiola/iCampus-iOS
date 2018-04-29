//
//  AddRequestTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/29.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddRequestTableViewController: UITableViewController {

    @IBOutlet weak var submitButtonItem: UIBarButtonItem!
    @IBOutlet weak var requestTypeLabel: UILabel!
    @IBOutlet weak var requestTextView: UITextView!
    
    private let bag = DisposeBag()
    private let requestViewModel = RequestViewModel()
    
    var requestType: RequestType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTypeLabel.text = requestType?.text
        
        requestTextView.becomeFirstResponder()
        requestTextView.rx.text
            .orEmpty
            .map {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                return $0.count > 0
            }
            .share(replay: 1)
            .bind(to: submitButtonItem.rx.isEnabled)
            .disposed(by: bag)
        
        if let member = iCampusPersistence().getMember() {
            submitButtonItem.rx.tap
                .do(onNext: { [unowned self] in
                    self.requestViewModel
                        .addRequest(requestType: self.requestType!, text: self.requestTextView.text, userId: member.userId!)
                        .subscribe()
                        .disposed(by: self.bag)
                })
                .subscribe(onNext: { [unowned self] in self.navigationController?.popViewController(animated: true) })
                .disposed(by: bag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
