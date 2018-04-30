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
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var classIdLabel: UILabel!
    
    private let memberViewModel = MemberViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = self.tableView.backgroundColor
        
        avatarImageView.layer.cornerRadius = 10.0
        avatarImageView.layer.masksToBounds = true
        
        if let member = iCampusPersistence().getMember() {
            memberViewModel
                .getAvatar(id: member.id)
                .bind(to: avatarImageView.rx.image)
                .disposed(by: bag)
        }
        
        avatarButton.rx.tap
            .bind { [unowned self] in self.showSheet() }
            .disposed(by: bag)
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
    
    fileprivate func showSheet() {
        let sheet = UIAlertController(title: "修改头像", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "相机胶卷", style: .default) { [unowned self] _ in self.pickImage(sourceType: .photoLibrary) })
        sheet.addAction(UIAlertAction(title: "拍照", style: .default) { [unowned self] _ in self.pickImage(sourceType: .camera) })
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }

    func pickImage(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let editTableViewController = segue.destination as! EditTableViewController
            editTableViewController.editText = cell.detailTextLabel?.text
            editTableViewController.index = tableView.indexPathForSelectedRow?.row
            editTableViewController.navigationItem.title = "修改\(cell.textLabel?.text ?? "")"
        }
    }
    
}

extension PersonalInformationTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage, let member = iCampusPersistence().getMember() {
            memberViewModel
                .uploadAvatar(id: member.id, image: image)
                .subscribe(onNext: { [unowned self] _ in
                    self.dismiss(animated: true, completion: nil)
                })
                .disposed(by: bag)
        }
    }
}
