//
//  SignupViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/24.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CryptoSwift
import PKHUD

class SignupViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private let bag = DisposeBag()
    private let memberViewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupButton.layer.cornerRadius = 5.0
        signupButton.layer.masksToBounds = true
        
        let phoneValidator = phoneTextField.rx.text
            .orEmpty
            .map { $0.count == 11 }
            .share(replay: 1)
        
        let userIdValidator = userIdTextField.rx.text
            .orEmpty
            .map { $0.count == 10 || $0.count == 12 }
            .share(replay: 1)
        
        let passwordValidator = passwordTextField.rx.text
            .orEmpty
            .map { $0.count >= 4 }
            .share(replay: 1)
        
        let validator = Observable
            .combineLatest(phoneValidator, userIdValidator, passwordValidator) { $0 && $1 && $2 }
            .share(replay: 1)
        
        validator
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: bag)
        
        validator
            .subscribe(onNext: { [unowned self] valid in
                self.signupButton.alpha = valid ? 1 : 0.5
            })
            .disposed(by: bag)
        
        signupButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in self.signup() })
            .disposed(by: bag)
        
        backButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in self.dismiss(animated: true, completion: nil) })
            .disposed(by: bag)
    }
    
    fileprivate func signup() {
        memberViewModel
            .signup(userId: userIdTextField.text!, password: passwordTextField.text!.md5(), phone: phoneTextField.text!)
            .subscribe()
            .disposed(by: bag)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
