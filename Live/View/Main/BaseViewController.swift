//
//  BaseViewController.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PromiseKit

class BaseViewController: UIViewController {
  lazy var animator: TransitionAnimator = {
        let animator = TransitionAnimator()
        var x: CGFloat = 30
        var height: CGFloat = 135
        var y: CGFloat = self.view.bounds.size.height * 0.5 - height * 0.5
        var width: CGFloat = self.view.bounds.size.width - 30 * 2
        animator.presentFrame = CGRect(x: x, y: y, width: width, height: height)
    return animator
    }()
    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
          setBackBarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         view.endEditing(true)
    }
    
    func setBackBarButton() {
        let image = UIImage(named: "new_nav_arrow_white")
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        let backBarItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarItem
        view.backgroundColor = UIColor(hex: CustomKey.Color.viewBackgroundColor)
        automaticallyAdjustsScrollViewInsets = false
    }

}
