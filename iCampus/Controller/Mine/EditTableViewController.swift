//
//  EditTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/26.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditTableViewController: UITableViewController {
    
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private let bag = DisposeBag()
    private let memberViewModel = MemberViewModel()
    
    var index: Int?
    var editText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextField.text = editText
        editTextField.becomeFirstResponder()
        editTextField.rx.text
            .orEmpty
            .map { [unowned self] in $0.count > 0 && $0 != self.editText }
            .share(replay: 1)
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        if let member = iCampusPersistence().getMember() {
            saveButton.rx.tap
                .flatMapLatest { [unowned self] _ -> Observable<Bool> in
                    switch self.index {
                    case 1:
                        member.name = self.editTextField.text
                    case 3:
                        member.classId = self.editTextField.text
                    default:
                        break
                    }
                    return self.memberViewModel.updateMember(member: member)
                }
                .bind { [unowned self] _ in
                    iCampusPersistence().saveMember(member)
                    self.editTextField.resignFirstResponder()
                    self.navigationController?.popViewController(animated: true)
                }
                .disposed(by: bag)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
