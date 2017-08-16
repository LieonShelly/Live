//
//  UserInfoManagerController.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable force_unwrapping

import UIKit
import RxSwift
import RxCocoa

class UserInfoManagerController: BaseViewController {
    var backTopAction: ((Void) -> Void)?
    var param = ModiftUserInfoParam()
    fileprivate lazy var userInfoVM: UserInfoManagerViewModel = UserInfoManagerViewModel()
    fileprivate let tipsItems = [["头像", "昵称"], ["性别", "生日"]]
    fileprivate let placehoderItems = [["", "请填写"], ["请选择", "请选择"]]
    fileprivate lazy var infoItems = [["", ""], ["女", ""]]
    
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(), style: .grouped)
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(UserInfoManagerAvatarCell.self, forCellReuseIdentifier: "UserInfoManagerAvatarCell")
        taleView.register(UserInfoManagerBaseInfoCell.self, forCellReuseIdentifier: "UserInfoManagerBaseInfoCell")
        return taleView
    }()
    fileprivate lazy var markView: UIView = {
        let markView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        markView.backgroundColor = UIColor.black .withAlphaComponent(0.6)
        return markView
    }()
    fileprivate lazy var genderPick: UserInfoGenderPickerView = {
        let genderPick: UserInfoGenderPickerView = UserInfoGenderPickerView(frame: CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 260))
        return genderPick
    }()
    fileprivate lazy var birthDayPick: UserInfoDatePickerView = {
        let birthDayPick: UserInfoDatePickerView = UserInfoDatePickerView(frame: CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 260))
        return birthDayPick
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        /// 请求该用户的多集同类产品的用户信息，用于填充
        let userInfoVM = UserInfoManagerViewModel()
         HUD.show(true, show: "", enableUserActions: false, with: self)
        userInfoVM.requstUserInfo()
            .then(execute: {[weak self] response -> Void in
            self?.infoItems = [["", userInfoVM.userInfo?.nickName ?? ""], [userInfoVM.userInfo?.gender.title ?? "", userInfoVM.userInfo?.birthday ?? ""]]
                self?.param.avatar = userInfoVM.userInfo?.avatar
                self?.tableView.reloadData()
            })
            .always {
                HUD.show(false, show: "", enableUserActions: false, with: self)
            }
            .catch(execute: { error in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
            })
    }
}

extension UserInfoManagerController {
    fileprivate func configUI() {
        title = "完善资料"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let saveBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.rx.tap
            .subscribe(onNext: {[unowned self] _ in
                if let avatar = self.param.avatar, avatar.isEmpty {
                    HUD.show(true, show: "请上传头像", enableUserActions: true, with: self)
                    return
                }
                    HUD.show(true, show: "", enableUserActions: true, with: self)
                    print(self.param)
                    self.userInfoVM.requstModifyUserInfo(with: self.param)
                        .then(execute: { [unowned self] response -> Void in
                            if response.result == .success {
                                /// 有回退操作就执行回退
                                if let action = self.backTopAction {
                                    action()
                                    return
                                }
                                let rootVC = TabBarController()
                                UIView.transition(with: self.view, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                                    self.view.removeFromSuperview()
                                    UIApplication.shared.keyWindow?.addSubview(rootVC.view)
                                }, completion: { (_) in
                                    UIApplication.shared.keyWindow?.rootViewController = rootVC
                                })
                            }
                        })
                        .always {
                            HUD.show(false, show: "", enableUserActions: true, with: self)
                        }
                        .catch(execute: { error  in
                            if let error = error as? AppError {
                                self.view.makeToast(error.message)
                            }
                        })
        })
            .disposed(by: disposeBag)
        let rightBtnItem: UIBarButtonItem = UIBarButtonItem(customView: saveBtn)
        self.navigationItem.rightBarButtonItem = rightBtnItem
        
        tableView.allowsSelection = true
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }
}

extension UserInfoManagerController {
    fileprivate func configData() {
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension UserInfoManagerController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell: UserInfoManagerAvatarCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.avatar.kf.setImage(with: URL(string: CustomKey.URLKey.baseImageUrl + ( self.param.avatar ?? "")), placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell: UserInfoManagerBaseInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.tipLable.text = tipsItems[indexPath.section][indexPath.row]
            cell.inputTextFiled.placeholder = placehoderItems[indexPath.section][indexPath.row]
            cell.inputTextFiled.text = infoItems[indexPath.section][indexPath.row]
            cell.inputTextFiled.isUserInteractionEnabled = indexPath.section == 0 && indexPath.row == 1
            cell.inputTextFiled.delegate = self
            cell.inputTextFiled.returnKeyType = .done
            cell.selectionStyle = .none
            if indexPath.section == 0 && indexPath.row == 1 {
                cell.rightArrow.isHidden = true
                cell.inputTextFiled.rx.text.orEmpty
                    .map { (text) -> String in
                        return text.characters.count <= 11 ? text: text.substring(to: "15608006621".endIndex)
                    }
                    .shareReplay(1)
                    .bind(to: cell.inputTextFiled.rx.text)
                    .disposed(by: disposeBag)
                
                cell.inputTextFiled.rx
                    .text.orEmpty
                    .subscribe(onNext: { (text) in
                        self.param.nickName = text
                    })
                    .disposed(by: disposeBag)
            }
             if indexPath.section == 0 && indexPath.row == 1 {
                cell.line.isHidden = true
            }
            if indexPath.section == 1 && indexPath.row == 1 {
                cell.line.isHidden = true
            }
            return cell
        }
    }
}

// MARK: UITextFieldDelegate
extension UserInfoManagerController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

// MARK: UITableViewDelegate
extension UserInfoManagerController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && indexPath.row == 0 ?  100 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            modifyAvatar()
            return
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            modifyGender()
            return
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            modifyBirthDay()
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

// MARK: 修改头像
extension UserInfoManagerController {
    fileprivate func modifyAvatar() {
        let sheet = UIAlertController(title: "选择头像", message: nil, preferredStyle: .actionSheet)
        let camerAction = UIAlertAction(title: "相机", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.getNewImg(type: UIImagePickerControllerSourceType.camera)
            }
        }
        let photoAction = UIAlertAction(title: "相册", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.getNewImg(type: UIImagePickerControllerSourceType.photoLibrary)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) -> Void in
        }
        sheet.addAction(camerAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        present(sheet, animated: true, completion: nil)
    }
    
    private func getNewImg(type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.cropMode = DZNPhotoEditorViewControllerCropMode.circular
        imagePicker.finalizationBlock = {(picker, info) in
            if let image: UIImage = info?[UIImagePickerControllerEditedImage] as? UIImage {
                print("image: \(image)")
                if  let imgData: Data = UIImageJPEGRepresentation(image, 0.1) {
                    UploadUtils.upLoadMultimedia(with: imgData, success: { (callbackStr) in
                        print("callbackStr:\(String(describing: callbackStr))")
                       self.param.avatar = callbackStr
                        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserInfoManagerAvatarCell else { return }
                        cell.avatar.kf.setImage(with: URL(string: CustomKey.URLKey.baseImageUrl + ( self.param.avatar ?? "")), placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
                    }, fail: { (error) in  }, progress: { (_) in })
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        imagePicker.cancellationBlock = {(picker) in
            self.dismiss(animated: true, completion: nil)
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: 修改性别
extension UserInfoManagerController {
    fileprivate func modifyGender() {
        UIApplication.shared.keyWindow?.addSubview(markView)
        markView.addSubview(genderPick)
        genderPick.callBackBlock = { tag in
             self.hiddenGenderPickView()
            self.param.sex = (Gender(rawValue: tag)) ?? .unknown
            self.infoItems = [["", self.param.nickName ?? ""], [self.param.sex.title, self.param.birthday ?? ""]]
            self.tableView.reloadData()
        }
        markView.alpha = 0
        var frame: CGRect = genderPick.frame
        frame.origin.y = UIScreen.height - 260
        UIView.animate(withDuration: 0.25) {
            self.markView.alpha = 1
            self.genderPick.frame = frame
        }
    }
    private func hiddenGenderPickView() {
        var frame: CGRect = self.genderPick.frame
        frame.origin.y = UIScreen.height
        UIView.animate(withDuration: 0.25, animations: {
            self.markView.alpha = 0
            self.genderPick.frame = frame
        }) { (true) in
            self.genderPick.removeFromSuperview()
            self.markView.removeFromSuperview()
        }
    }
}

extension UserInfoManagerController {
    fileprivate func modifyBirthDay() {
        UIApplication.shared.keyWindow?.addSubview(markView)
        markView.addSubview(birthDayPick)
        birthDayPick.callBackBlock = { (tag, seletcedDateStr) in
            self.hiddenbirthDayPickView()
            self.param.birthday = seletcedDateStr
             self.infoItems = [
                                ["", self.param.nickName ?? ""],
                                [self.param.sex.title, self.param.birthday ?? ""]
                                ]
            self.tableView.reloadData()
        }
        markView.alpha = 0
        var frame: CGRect = birthDayPick.frame
        frame.origin.y = UIScreen.height - 260
        UIView.animate(withDuration: 0.25) {
            self.markView.alpha = 1
            self.birthDayPick.frame = frame
        }
    }
    private func hiddenbirthDayPickView() {
        var frame: CGRect = self.birthDayPick.frame
        frame.origin.y = UIScreen.height
        UIView.animate(withDuration: 0.25, animations: {
            self.markView.alpha = 0
            self.birthDayPick.frame = frame
        }) { (true) in
            self.birthDayPick.removeFromSuperview()
            self.markView.removeFromSuperview()
        }
    }
}
