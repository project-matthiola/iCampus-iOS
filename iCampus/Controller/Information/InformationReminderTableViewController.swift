//
//  InformationReminderTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/29.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EventKit
import PKHUD

class InformationReminderTableViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var alertDatePicker: UIDatePicker!
    @IBOutlet weak var submitButtonItem: UIBarButtonItem!
    
    private let bag = DisposeBag()
    private let informationViewModel = InformationViewModel()
    
    var information: Information?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = information?.title
        self.timeLabel.text = CustomDateTransform().transformToJSON(information?.informationTime)
        self.placeLabel.text = information?.place
        self.sourceLabel.text = information?.source
        self.alertDatePicker.date = Date(timeInterval: -30 * 60, since: information!.informationTime!)
        
        submitButtonItem.rx.tap
            .do(onNext: { [unowned self] in self.addEvent(self.information!, alertTime: self.alertDatePicker.date) })
            .subscribe(onNext: { [unowned self] in self.navigationController?.popViewController(animated: true) })
            .disposed(by: bag)
    }

    fileprivate func addEvent(_ information: Information, alertTime: Date?) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                eventStore.addEvent(information: information, alertTime: alertTime)
            } else {
                ErrorHandler().showErrorHUD(subtitle: error?.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
