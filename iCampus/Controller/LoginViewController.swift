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

class LoginViewController: UIViewController {

	@IBOutlet weak var phoneTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	private let bag = DisposeBag()
	private let memberViewModel = MemberViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()

		loginButton.layer.cornerRadius = 5.0
		loginButton.layer.masksToBounds = true
		
		loginButton.rx.tap
			.subscribe(onNext: { [unowned self] _ in
				self.memberViewModel.login(userId: self.phoneTextField.text!, password: self.passwordTextField.text!)
					.subscribe(onNext: { member in
						if self.passwordTextField.text!.md5() == member.password {
							iCampusPersistence().saveId(member.id)
							UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "iCampusTabBarController")
						}
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
