//
//  LoginViewController.swift
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
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let bag = DisposeBag()
    private let memberViewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.masksToBounds = true
        
        let context = LAContext()
        var authError: NSError?
        var localizedReasonString: String?
        
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if iCampusPersistence().isLogin(), context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                if #available(iOS 11.0, *) {
                    switch context.biometryType {
                    case .none:
                        break
                    case .touchID:
                        localizedReasonString = "使用 Touch ID 登录"
                    case .faceID:
                        localizedReasonString = "使用 Face ID 登录"
                    }
                } else {
                    localizedReasonString = "使用 Touch ID 登录"
                }
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonString ?? "") { [unowned self] success, error in
                    if success {
                        self.navigateToTabBarController()
                    } else {
                        HUD.flash(.labeledError(title: "错误", subtitle: error?.localizedDescription), delay: 2.0)
                    }
                }
            } else {
                if let error = authError {
                    HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 2.0)
                } else {
                    prepareForLogin()
                }
            }
        }
    }
    
    fileprivate func navigateToTabBarController() {
        DispatchQueue.main.async {
            UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "iCampusTabBarController")
        }
    }
    
    fileprivate func prepareForLogin() {
        let userIdValidator = userIdTextField.rx.text
            .orEmpty
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let passwordValidator = passwordTextField.rx.text
            .orEmpty
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let validator = Observable
            .combineLatest(userIdValidator, passwordValidator) { $0 && $1 }
            .share(replay: 1)
        
        validator
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: bag)
        
        validator
            .subscribe(onNext: { [unowned self] valid in
                self.loginButton.alpha = valid ? 1 : 0.5
            })
            .disposed(by: bag)
        
        loginButton.rx.tap
            .do(onNext: {
                HUD.show(.labeledProgress(title: "登录中", subtitle: nil))
            })
            .flatMapLatest { [unowned self] _ in
                return self.memberViewModel.login(userId: self.userIdTextField.text!, password: self.passwordTextField.text!)
            }
            .subscribe(onNext: { [unowned self] member in
                HUD.hide()
                if self.passwordTextField.text!.md5() == member.password {
                    iCampusPersistence().saveMember(member)
                    self.navigateToTabBarController()
                } else {
                    HUD.flash(.labeledError(title: "错误", subtitle: "学号或密码错误"), delay: 2.0)
                }
            }, onError: { _ in
                HUD.flash(.labeledError(title: "错误", subtitle: "学号或密码错误"), delay: 2.0)
            })
            .disposed(by: bag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
