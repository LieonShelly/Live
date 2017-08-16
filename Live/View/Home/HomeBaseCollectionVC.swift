//
//  HomeBaseCollectionVC.swift
//  Live
//
//  Created by lieon on 2017/7/6.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class HomeBaseCollectionVC: BaseViewController, UICollectionViewDelegate {
        var  param: LiveListRequstParam = LiveListRequstParam()
      lazy var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.itemSize = CGSize(width: (UIScreen.width - 3) * 0.5, height: 250)
        let collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height), collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CommonLiveCollectionViewCell.self, forCellWithReuseIdentifier: "CommonLiveCollectionViewCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBarBackgroundColor(UIColor.black)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setStatusBarBackgroundColor(UIColor.clear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -5 {
            navigationController?.setNavigationBarHidden(true, animated: true)
            setTabbarHidden(true)
        } else if velocity > 5 {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.isNavigationBarHidden = false
//            UINavigationBar.appearance().barStyle = .black
//            UINavigationBar.appearance().barTintColor = UIColor.black
//            UINavigationBar.appearance().tintColor = UIColor.white
//            UINavigationBar.appearance().isTranslucent = false
            setTabbarHidden(false)
        } else if velocity == 0 {
        }
    }
    
    private func setTabbarHidden( _ ishidden: Bool) {
        guard  let tab = self.tabBarController?.view else { return }
        var tabRect = tabBarController?.tabBar.frame
        if tab.subviews.count < 2 {
            return
        }
        var view = UIView()
        guard let subView =  tab.subviews.first  else {
            return
        }
        if subView.isKind(of: UITabBar.self) {
            view = tab.subviews[1]
        } else {
            view = tab.subviews[0]
        }
        if ishidden {
            view.frame = tab.bounds
            tabRect?.origin.y = UIScreen.height + (tabBarController?.tabBar.frame.height ?? 0)
        } else {
            view.frame = CGRect(x: tab.bounds.origin.x, y: tab.bounds.origin.y, width: tab.bounds.width, height: tab.bounds.height)
            tabRect?.origin.y = UIScreen.height -  (tabBarController?.tabBar.frame.height ?? 0)
        }
        UIView.animate(withDuration: 0.25) {
            guard let rect = tabRect  else { return }
            self.tabBarController?.tabBar.frame = rect
        }
    }
    
    private  func setStatusBarBackgroundColor(_ color: UIColor) {
        if let window = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow, let statusBar = window.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
    }
}
