//
//  InformationDetailViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EventKit
import PKHUD

class InformationDetailTableViewController: UITableViewController {

    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var mainTextView: UITextView!
    
    private let bag = DisposeBag()
    private let informationViewModel = InformationViewModel()
    
    var informationId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let information = informationViewModel
            .getInformation(by: informationId!)
            .share(replay: 1)

        information.subscribe(onNext: { information in
                self.titleLabel.text = information.title
                self.timeLabel.text = CustomDateTransform().transformToJSON(information.informationTime)
                self.placeLabel.text = information.place
                self.sourceLabel.text = information.source
                
                if information.text == nil {
                    self.mainTextView.backgroundColor = .none
                    if let cell = self.mainTextView.superview?.superview as? UITableViewCell {
                        cell.backgroundColor = .none
                    }
                } else {
                    self.mainTextView.text = information.text
                }
                self.mainTextView.text = information.text ?? ""
            }, onCompleted: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
            .disposed(by: bag)
        
        calendarButton.rx.tap
            .flatMapLatest { return information }
            .subscribe(onNext: { [unowned self] in self.addEvent($0) })
            .disposed(by: bag)
    }

    fileprivate func addEvent(_ information: Information) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                eventStore.addEvent(title: information.title!, source: information.source, startDate: information.informationTime!, endDate: information.informationTime!, location: information.place)
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
