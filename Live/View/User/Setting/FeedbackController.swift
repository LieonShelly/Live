//
//  FeedbackController.swift
//  Live
//
//  Created by fanfans on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable force_unwrapping

import UIKit
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift
import PromiseKit

class FeedbackController: BaseViewController {
    fileprivate lazy var feedbackVM: FeedBackViewModel = FeedBackViewModel()
    fileprivate lazy var showImages: [UIImage] = [UIImage(named: "upload_camre_icon")!]
    fileprivate lazy var realImgs = [UIImage]()
    fileprivate let collectionViewCellHight = (UIScreen.width  - 24 - 6) / 3
    fileprivate lazy var bgScrollView: UIScrollView = {
        let bgScrollView: UIScrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: UIScreen.width, height:UIScreen.height - 64))
        bgScrollView.contentSize = CGSize(width: UIScreen.width, height: UIScreen.height - 64)
        return bgScrollView
    }()
    fileprivate lazy var inputTextView: UITextView = {
        let inputTextView: UITextView = UITextView(frame:CGRect(x: 12, y: 15, width: UIScreen.width - 24, height:130))
        inputTextView.placeholder = "请尽可能详细描述问题原因、现象等信息"
        inputTextView.maxHeight = 130
        inputTextView.placeholderColor = UIColor(hex: 0x808080)
        inputTextView.textAlignment = .left
        inputTextView.font = UIFont.systemFont(ofSize: 13)
        return inputTextView
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame:CGRect(x: 12, y: 15 + 130 + 15, width: UIScreen.width - 24, height: self.collectionViewCellHight), collectionViewLayout:UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(FeedbackImgVCell.self, forCellWithReuseIdentifier: "FeedbackImgVCell")
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    fileprivate lazy var commitBtn: UIButton = {
        let commitBtn: UIButton = UIButton(frame:CGRect(x: 35, y: 15 + 130 + 15 + self.collectionViewCellHight + 25, width: UIScreen.width - 70, height: 40))
        commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        commitBtn.setTitle("提交", for: .normal)
        commitBtn.setTitleColor(UIColor.white, for: .disabled)
        commitBtn.setTitleColor(UIColor.white, for: .normal)
        commitBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        commitBtn.layer.cornerRadius = 40 * 0.5
        commitBtn.layer.masksToBounds = true
        commitBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        commitBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        commitBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        return commitBtn
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈"
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        
        self.view.addSubview(bgScrollView)
        self.bgScrollView.addSubview(inputTextView)
        self.bgScrollView.addSubview(collectionView)
        self.bgScrollView.addSubview(commitBtn)
        inputTextView.rx.text.orEmpty
            .map { !$0.characters.isEmpty}
            .bind(to: commitBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        commitBtn.rx.tap
            .subscribe(onNext: { [weak  self] in
                var imgDatas = [Data]()
                guard let weakSelf = self else { return }
                HUD.show(true, show: "", enableUserActions: true, with: weakSelf)
                if weakSelf.realImgs.isEmpty { /// 没有图片直接传文字
                    let param = FeedbackRequstParam()
                    param.content = weakSelf.inputTextView.text
                    weakSelf.feedbackVM.requestFeedback(with: param)
                        .then(execute: { response -> Void in
                            if response.result == .success {
                                weakSelf.navigationController?.popViewController(animated: true)
                            }
                        })
                        .always {
                         HUD.show(false, show: "", enableUserActions: true, with: weakSelf)
                        }
                        .catch(execute: { error in
                            if let eror = error as? AppError {
                                weakSelf.view.makeToast(eror.message)
                            }
                        })
                } else {
                    for image in weakSelf.realImgs {
                        if let data = UIImageJPEGRepresentation(image, 0.5) {
                            imgDatas.append(data)
                        }
                    }
                    weakSelf.feedbackVM.uploadCoverImage(with: imgDatas)
                        .then(execute: { (imgeURLs) -> Promise<NullDataResponse> in
                            let param = FeedbackRequstParam()
                            param.content = weakSelf.inputTextView.text
                            param.pictures = imgeURLs
                            return  weakSelf.feedbackVM.requestFeedback(with: param)
                        })
                        .then(execute: { response -> Void in
                            if response.result == .success {
                                weakSelf.navigationController?.popViewController(animated: true)
                            }
                        })
                        .always {
                            HUD.show(false, show: "", enableUserActions: true, with: weakSelf)
                        }
                        .catch(execute: { error in
                            if let eror = error as? AppError {
                                weakSelf.view.makeToast(eror.message)
                            }
                        })
                }
            })
            .disposed(by: disposeBag)
    }
}

extension FeedbackController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewCellHight, height: self.collectionViewCellHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
}

extension FeedbackController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realImgs.count == 9 ? 9 : showImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeedbackImgVCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.cover.image = showImages[indexPath.row]
        cell.removeBtnAction = {
            self.realImgs .remove(at: indexPath.row)
            self.showImages .remove(at: indexPath.row)
            self.collectionView.reloadData()
            self.configLayout()
        }
        cell.removeBtn.isHidden = indexPath.row == showImages.count - 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == realImgs.count {
            let viewController: RITLPhotoNavigationViewController = RITLPhotoNavigationViewController()
            let viewModel = viewController.viewModel
            viewModel.maxNumberOfSelectedPhoto = 9 - self.realImgs.count
            viewModel.completeUsingImage = {(images) in // 返回选中的图片数组 realImgs 真实的图片数组 showImages展示的图片数组
                self.realImgs.append(contentsOf: images)
                guard let cameraIcon = self.showImages.last else { return }
                self.showImages.remove(at: self.showImages.count - 1)
                self.showImages.append(contentsOf: images)
                self.showImages.append(cameraIcon)
                self.configLayout()
                self.collectionView.reloadData()
            }
            viewModel.completeUsingData = {(datas) in
                print("data = \(datas)")
            }
            self.present(viewController, animated: true) {}
        }
    }
    //更新布局 
    func configLayout() {
        var frame = self.collectionView.frame
        frame.size.height = self.collectionViewCellHight * CGFloat((self.realImgs.count/3) + 1 > 3 ? 3 : (self.realImgs.count/3) + 1)
        self.collectionView.frame = frame
        
        var commitBtnFrame = self.commitBtn.frame
        commitBtnFrame.origin.y = frame.origin.y + frame.size.height + 25
        self.commitBtn.frame = commitBtnFrame
        self.bgScrollView.contentSize = CGSize(width: UIScreen.width, height:130 + 60 + frame.size.height + 50)
    }
    
}
