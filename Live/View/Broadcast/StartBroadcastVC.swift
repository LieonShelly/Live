//
//  StartBroadcastVC.swift
//  Live
//
//  Created by lieon on 2017/7/6.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable variable_name

import UIKit
import Device
import AVKit
import AVFoundation
import SnapKit
import RxSwift
import RxCocoa
import PromiseKit

class StartBroadcastVC: BaseViewController {
    fileprivate lazy var broacastVM: BroacastViewModel =  BroacastViewModel()
    fileprivate lazy var nameTF = UITextField()
    fileprivate lazy var topicTF = UITextView()
    fileprivate lazy var coverImageView: UIImageView = UIImageView()
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "common_close@3x"), for: .normal)
        btn.setImage(UIImage(named: "common_close@3x"), for: .highlighted)
        return btn
    }()
    
    fileprivate lazy var videoParentView: UIImageView = UIImageView(frame: self.view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let userVM = UserInfoManagerViewModel()
        userVM.requstUserInfo()
            .then { _ -> Void in
                if let coverURL = URL(string: CustomKey.URLKey.baseImageUrl + (userVM.userInfo?.avatar ?? "")) {
                    self.coverImageView.kf.setImage(with: coverURL, placeholder: UIImage(named: "gou"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }.catch { _ in
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension StartBroadcastVC {
    fileprivate func setupUI() {
        // MARK: - UI
        videoParentView.image = UIImage(named: "broadcatBg.jpg")
        view.addSubview(videoParentView)
        broacastVM.videoParentView = videoParentView
        
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.top.equalTo(30)
            maker.size.equalTo(CGSize(width: 15, height: 16))
        }
        
        closeBtn.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        })
            .disposed(by: disposeBag)
        
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        view.addSubview(coverView)
        coverView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(116)
            maker.right.equalTo(0)
            maker.height.equalTo(125)
        }
        
        coverImageView.image = UIImage(named: "gou")
        coverImageView.isUserInteractionEnabled = true
        coverView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(12)
            maker.size.equalTo(CGSize(width: 90, height: 90))
        }
        
        let coverImageViewtap = UITapGestureRecognizer()
        coverImageView.addGestureRecognizer(coverImageViewtap)
        
        let editIcon = UIImageView(image: UIImage(named: "edit"))
        editIcon.sizeToFit()
        coverView.addSubview(editIcon)
        editIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.bottom.equalTo(-8)
        }
        
        let editLabel = UILabel()
        editLabel.font = UIFont.systemFont(ofSize: 12)
        editLabel.text = "修改封面"
        editLabel.textColor = .white
        coverView.addSubview(editLabel)
        
        editLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(editIcon.snp.right).offset(10)
            maker.centerY.equalTo(editIcon.snp.centerY)
        }
        
        nameTF.placeholder = "有趣的标题更加吸引观众哦"
        nameTF.textColor = UIColor(hex: 0xcccccc)
        nameTF.font = UIFont.sizeToFit(with: 14)
        nameTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        nameTF.returnKeyType = .done
        nameTF.setValue(UIColor(hex: 0xcccccc), forKeyPath: "_placeholderLabel.textColor")
        coverView.addSubview(nameTF)
        
        nameTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(coverImageView.snp.right).offset(29)
            maker.top.equalTo(29)
            maker.height.equalTo(26)
            maker.right.equalTo(-40)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor(hex: 0xe6e6e6).withAlphaComponent(0.5)
        coverView.addSubview(line)
        
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(coverImageView.snp.right).offset(8)
            maker.right.equalTo(-12)
            maker.top.equalTo(nameTF.snp.bottom).offset(12)
            maker.height.equalTo(0.5)
        }
        
        topicTF.backgroundColor = .clear
        topicTF.textColor = UIColor(hex: 0xcccccc)
        topicTF.font = UIFont.systemFont(ofSize: 14)
        topicTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        topicTF.returnKeyType = .done
        topicTF.setValue(UIColor(hex: 0xcccccc), forKeyPath: "_placeholderLabel.textColor")
        coverView.addSubview(topicTF)
        topicTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTF.snp.left)
            maker.right.equalTo(nameTF.snp.right)
            maker.bottom.equalTo(-5)
            maker.top.equalTo(line.snp.bottom).offset(12)
        }
        
        let textViewPlaceHolderLabel = UILabel()
        textViewPlaceHolderLabel.font = UIFont.systemFont(ofSize: 16)
        textViewPlaceHolderLabel.text = "#添加话题"
        textViewPlaceHolderLabel.textColor = UIColor(hex: 0xcccccc)
        coverView.addSubview(textViewPlaceHolderLabel)
        
        textViewPlaceHolderLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(topicTF.snp.left).offset(3)
            maker.centerY.equalTo(topicTF.snp.centerY).offset(-5)
            maker.height.equalTo(28)
        }
        
        let countLabel = UILabel()
        countLabel.isHidden = false
        countLabel.font = UIFont.systemFont(ofSize: 13)
        countLabel.text = "30"
        countLabel.textColor = UIColor(hex: 0xcccccc)
        coverView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(topicTF.snp.centerY)
            maker.right.equalTo(-12)
        }
        
        let startBtn = UIButton()
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        startBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        startBtn.setTitle("开始直播", for: .normal)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.layer.cornerRadius = 22
        startBtn.alpha = 0.8
        startBtn.layer.masksToBounds = true
        startBtn.isEnabled = false
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(37)
            maker.right.equalTo(-37)
            maker.top.equalTo(438)
            maker.height.equalTo(44)
        }
        // MARK: - Action
        
        coverImageViewtap.rx.event
            .subscribe(onNext: { [unowned self] _ in
                self.coverImageTapAction()
            })
            .disposed(by: disposeBag)
    
        let titlevalid = nameTF.rx.text.orEmpty
            .map { $0.characters.count >= 1 }
            .shareReplay(1)
        
        titlevalid
            .bind(to: startBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        topicTF.isUserInteractionEnabled = false
        
        startBtn.rx.tap
            .subscribe(onNext: {[unowned self] _ in
                self.startLive()
            })
            .disposed(by: disposeBag)
        
        nameTF.rx.text.orEmpty
            .map { (text) -> String in
                /// 012345678901234567890123456789 这个字符串仅仅只是为了创建一个30个字符大小的字符串
                return text.characters.count <= 30 ? text: text.substring(to: "012345678901234567890123456789".endIndex)
            }
            .shareReplay(1)
            .bind(to: nameTF.rx.text)
            .disposed(by: disposeBag)
        
        nameTF.rx.text.orEmpty
            .map { "\(30 - $0.characters.count)" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
            .subscribe(onNext: { (note) in
                if  let begin = note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect, let end =  note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                    if begin.size.height > 0 && begin.origin.y - end.origin.y > 0 {
                        UIView.animate(withDuration: 0.25, animations: {
                            startBtn.snp.updateConstraints({ (maker) in
                                maker.top.equalTo(318)
                            })
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
            .subscribe(onNext: { (note) in
                if  let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                    print(duration)
                    UIView.animate(withDuration: duration, animations: {
                        startBtn.snp.updateConstraints { (maker) in
                            maker.top.equalTo(438)
                        }
                    })
                }
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func coverImageTapAction() {
        let alterVC = UIAlertController(title: "", message: "操作", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "拍照上传", style: .default) { _ in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                return
            }
            UIImagePickerController.rx.createWithParent(self) { picker in
                picker.sourceType = .camera
                picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
                .map { info in
                    return info[UIImagePickerControllerOriginalImage] as? UIImage
                }
                .bind(to: self.coverImageView.rx.image)
                .disposed(by: self.disposeBag)
            
        }
        let photo = UIAlertAction(title: "手机相册上传", style: .default) { _ in
            UIImagePickerController.rx.createWithParent(self) { picker in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
                .map { info in
                    return info[UIImagePickerControllerOriginalImage] as? UIImage
                }
                .bind(to: self.coverImageView.rx.image)
                .disposed(by: self.disposeBag)
        }
        let canle = UIAlertAction(title: "取消 ", style: .cancel) { _ in }
        
        alterVC.addAction(camera)
        alterVC.addAction(photo)
        alterVC.addAction(canle)
        self.present(alterVC, animated: true, completion: nil)
    }
    
    fileprivate func startLive() {
        guard let image =  coverImageView.image, let imageData = UIImageJPEGRepresentation(image, 0.1) else {  return }
        HUD.show(true, show: "", enableUserActions: false, with: self)
        broacastVM.uploadCoverImage(with: imageData)
            .then { coverStr -> Promise<Bool> in
                let param = BroadcastParam()
                param.cover = coverStr
                param.name = self.nameTF.text ?? " "
                param.latitude = LocationViewModel.share.latitude
                param.longitude = LocationViewModel.share.longitude
                param.city = LocationViewModel.share.cityName
                return self.broacastVM.startLive(with: param)
            }
            .then(execute: { [unowned self] isSuccess -> Void in
                if isSuccess {
                    let vcc = BroadcastViewController()
                    vcc.broacastVM = self.broacastVM
                    self.present(vcc, animated: true, completion: nil)
                }
            })
            .always {
                HUD.show(false, show: "", enableUserActions: false, with: self)
            }
            .catch { error  in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
        }
    }
}
