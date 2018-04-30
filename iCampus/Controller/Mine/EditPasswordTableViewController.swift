//
//  EditPasswordTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/30.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditPasswordTableViewController: UITableViewController {

    @IBOutlet weak var submitButtonItem: UIBarButtonItem!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    
    private let bag = DisposeBag()
    private let memberViewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordValidationLabel.text = "确认密码与新密码不一致"
        oldPasswordTextField.becomeFirstResponder()
        
        let oldPasswordValidator = oldPasswordTextField.rx.text
            .orEmpty
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let newPasswordValidator = newPasswordTextField.rx.text
            .orEmpty
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let confirmPasswordValidator = confirmPasswordTextField.rx.text
            .orEmpty
            .map { $0.count > 0 && $0 == self.newPasswordTextField.text }
            .share(replay: 1)
        
        let validator = Observable
            .combineLatest(oldPasswordValidator, newPasswordValidator, confirmPasswordValidator) { $0 && $1 && $2 }
            .share(replay: 1)
        
        confirmPasswordTextField.rx.text
            .orEmpty
            .map { $0.isEmpty || $0.count > 0 && $0 == self.newPasswordTextField.text }
            .share(replay: 1)
            .bind(to: passwordValidationLabel.rx.isHidden)
            .disposed(by: bag)
        
        validator
            .bind(to: submitButtonItem.rx.isEnabled)
            .disposed(by: bag)
        
        if let member = iCampusPersistence().getMember() {
            submitButtonItem.rx.tap
                .flatMapLatest { [unowned self] _ -> Observable<Bool> in
                    if self.oldPasswordTextField.text?.md5() == member.password {
                        member.password = self.newPasswordTextField.text?.md5()
                        return self.memberViewModel.updateMember(member: member)
                    } else {
                        return Observable.of(false)
                    }
                }
                .bind { [unowned self] valid in
                    if valid {
                        iCampusPersistence().saveMember(member)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        ErrorHandler().showErrorHUD(subtitle: "原密码输入错误")
                    }
                }
                .disposed(by: bag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
