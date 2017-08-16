//
//  TabBarController.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarController: UITabBarController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupUI()
        loadUserInfo()
    }
 
    fileprivate func loadUserInfo() {
        let userInfoVM = UserInfoManagerViewModel()
        userInfoVM.requstUserInfo().catch { _ in}
    }
    
    fileprivate func setupUI() {
        let tabbar = TabBar()
        self.setValue(tabbar, forKey: "tabBar")
        let homeVC = HomeViewController()
        let broacastVC = StartBroadcastVC()
        let userVC = UserViewController()
        broacastVC.view.backgroundColor = .white
        userVC.view.backgroundColor = .yellow
        add(childVC: homeVC, normalImageName: "tab_live", selectedImageName: "tab_live_p")
        add(childVC: userVC, normalImageName: "tab_me", selectedImageName: "tab_me_p")
        tabbar.centerBtn.rx.tap
            .subscribe(onNext: {
            self.present(broacastVC, animated: true, completion: nil)
        })
            .disposed(by: disposeBag)
    }
    
}

extension TabBarController {
    fileprivate func add(childVC: UIViewController, normalImageName: String, selectedImageName: String) {
        let navi = NavigationController(rootViewController: childVC)
        navi.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: normalImageName), selectedImage: UIImage(named: selectedImageName))
        navi.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        addChildViewController(navi)
    }
}
