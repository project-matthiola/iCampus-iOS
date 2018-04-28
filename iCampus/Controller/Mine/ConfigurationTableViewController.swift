//
//  ConfigurationTableViewController.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/25.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConfigurationTableViewController: UITableViewController {
    
    @IBOutlet weak var touchIdSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.rx.tap
            .bind { [unowned self] _ in self.showLogoutAlert() }
            .disposed(by: bag)
    }
    
    fileprivate func logout() {
        guard iCampusPersistence().isLogin() else { return }
        iCampusPersistence().deleteMember()
        UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
    }
    
    fileprivate func showLogoutAlert() {
        let alert = UIAlertController(title: "登出", message: "您确定要登出吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [unowned self] _ in self.logout() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
