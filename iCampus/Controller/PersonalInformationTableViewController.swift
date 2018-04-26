//
//  PersonalInformationTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/25.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PersonalInformationTableViewController: UITableViewController {
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var classIdLabel: UILabel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let member = iCampusPersistence().getMember() {
            self.userIdLabel.text = member.userId ?? ""
            self.nameLabel.text = member.name ?? "未填写"
            self.phoneLabel.text = member.phone ?? ""
            self.classIdLabel.text = member.classId ?? "未填写"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            // swiftlint:disable force_cast
            let editTableViewController = segue.destination as! EditTableViewController
            editTableViewController.editText = cell.detailTextLabel?.text
            switch segue.identifier {
            case "EditNameSegue":
                editTableViewController.index = tableView.indexPathForSelectedRow?.row
                editTableViewController.navigationItem.title = "修改姓名"
            case "EditClassIdSegue":
                editTableViewController.index = 3
                editTableViewController.navigationItem.title = "修改班级"
            default:
                break
            }
        }
    }
    
}
