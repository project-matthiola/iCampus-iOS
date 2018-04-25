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
	
	private let bag = DisposeBag()
	private let memberViewModel = MemberViewModel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		signupButton.layer.cornerRadius = 5.0
		signupButton.layer.masksToBounds = true
		
		signupButton.rx.tap
			.subscribe { event in
				switch event {
				case .next():
					self.signup()
				case .error(let error):
					HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 2.0)
				case .completed:
					return
				}
			}
			.disposed(by: bag)
    }

	func signup() {
		memberViewModel.signup(userId: userIdTextField.text!, password: passwordTextField.text!.md5(), phone: phoneTextField.text!)
			.subscribe()
			.disposed(by: bag)
		self.dismiss(animated: true, completion: nil)
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
