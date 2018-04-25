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
			.subscribe(onNext: { [unowned self] _ in
				self.memberViewModel.login(userId: self.userIdTextField.text!, password: self.passwordTextField.text!)
					.subscribe(onNext: { member in
						if self.passwordTextField.text!.md5() == member.password {
							iCampusPersistence().saveId(member.id)
							UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "iCampusTabBarController")
						} else {
							HUD.flash(.labeledError(title: "错误", subtitle: "学号或密码错误"), delay: 2.0)
						}
					}, onError: { _ in
						HUD.flash(.labeledError(title: "错误", subtitle: "学号或密码错误"), delay: 2.0)
					})
					.disposed(by: self.bag)
			})
			.disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
