//
//  TestViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/11.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift

class TestViewController: UIViewController {
	private let bag = DisposeBag()
	private let memberViewModel = MemberViewModel()
	
	@IBAction func act(_ sender: UIButton) {
		memberViewModel.getMember(userId: "515030910477")
			.subscribe { event in
				switch event {
				case .next(let member):
					print(member)
				case .error(let error):
					print(error)
				case .completed:
					return
				}
			}
			.disposed(by: bag)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
