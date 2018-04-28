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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var mainTextView: UITextView!
    
    private let bag = DisposeBag()
    private let informationViewModel = InformationViewModel()
    
    var informationId: Int?
    var information: Information?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        informationViewModel
            .getInformation(by: informationId!)
            .share(replay: 1)
            .subscribe(onNext: { information in
                self.information = information
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        return []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let informationReminderTableViewController = segue.destination as! InformationReminderTableViewController
        informationReminderTableViewController.information = self.information
    }
    
}
