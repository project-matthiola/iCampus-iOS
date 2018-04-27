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

class InformationDetailViewController: UIViewController {

    @IBOutlet weak var calendarButton: UIBarButtonItem!
    
    private let bag = DisposeBag()
    private let informationViewModel = InformationViewModel()
    
    var informationId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationViewModel
            .getInformation(by: informationId!)
            .subscribe(onNext: { information in
                
            })
            .disposed(by: bag)
        
        calendarButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.addEvent()
            })
            .disposed(by: bag)

    }

    fileprivate func addEvent() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                eventStore.addEvent(title: "test", startDate: Date(), endDate: Date())
            } else {
                HUD.flash(.labeledError(title: "错误", subtitle: error?.localizedDescription), delay: 2.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
