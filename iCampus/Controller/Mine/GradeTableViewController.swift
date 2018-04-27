//
//  GradeTableViewController.swift
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

class GradeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseIdLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
}

class GradeTableViewController: UITableViewController {

    private let bag = DisposeBag()
    private let gradeViewModel = GradeViewModel()
    private var sections = BehaviorRelay<[SectionOfGrade]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfGrade>(configureCell: { (_, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "GradeTableViewCell", for: ip) as! GradeTableViewCell
            cell.courseIdLabel.text = item.courseId
            cell.courseNameLabel.text = item.courseName
            cell.scoreLabel.text = String(item.score ?? 0)
            return cell
        })
        
        sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        if let member = iCampusPersistence().getMember() {
            gradeViewModel
                .getGrades(userId: member.userId!)
                .flatMap(gradeViewModel.getCourseNames)
                .subscribe(onNext: { self.sections.accept([SectionOfGrade(items: $0)]) })
                .disposed(by: bag)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
}
