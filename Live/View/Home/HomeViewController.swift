//
//  HomeViewController.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: BaseViewController {
    fileprivate lazy var searchBtn: UIButton = {
        let searchBtn = UIButton()
        searchBtn.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
        searchBtn.setImage(UIImage(named: "home_nav_search_white"), for: .normal)
        searchBtn.addTarget(self, action: #selector(self.searchTapAction), for: .touchUpInside)
        return searchBtn
    }()
    fileprivate lazy var moreBtn: UIButton = {
        let moreBtn = UIButton()
        moreBtn.frame = CGRect(x:UIScreen.width - 44, y: 20, width: 44, height: 44)
        moreBtn.setImage(UIImage(named: "home_nav_more"), for: .normal)
        moreBtn.addTarget(self, action: #selector(self.moreTapAction(btn:)), for: .touchUpInside)
        return moreBtn
    }()
    fileprivate lazy var pageTitleView: PageTitleView = {
        let pvc = PageTitleView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width - 80 * 2, height: 44), titles: ["最新", "热门", " 附近"])
        return pvc
    }()
    fileprivate lazy var pageContenView: PageContentView  = { [unowned self] in
        var childVCs = [UIViewController]()
        let latestVC = LatestViewController()
        let popularVC = PopularViewController()
        let nearVC = NearViewController()
        childVCs.append(latestVC)
        childVCs.append(popularVC)
        childVCs.append(nearVC)
        let pageContenView = PageContentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), childVCs: childVCs, parentVC: self)
        return pageContenView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tapAction()
        checkAvailableBrocadcast()
    }
    
    private  func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageContenView)
        let title = UIView()
        title.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        title.backgroundColor = .yellow
        self.navigationItem.titleView = pageTitleView
        
        let leftBtnItem = UIBarButtonItem(customView: searchBtn)
        self.navigationItem.leftBarButtonItem = leftBtnItem
        
        let rightBtnItem = UIBarButtonItem(customView: moreBtn)
        self.navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc fileprivate  func searchTapAction() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    @objc fileprivate  func moreTapAction(btn: UIButton) {
        let point = CGPoint(x: btn.frame.origin.x + btn.bounds.width * 0.5, y: btn.frame.maxY + 12)
        YBPopupMenu.show(at: point, titles: ["    全部", "  只看男", "  只看女"], icons: nil, menuWidth: 92) { menu in
            menu?.arrowDirection = .top
            menu?.rectCorner = UIRectCorner.bottomRight
            menu?.delegate = self
        }
    }
    
    private  func tapAction() {
        
        pageTitleView.titleTapAction = {[weak self] seletedIndex in
            self?.pageContenView.selected(index: seletedIndex)
        }
        pageContenView.tapAction = {[weak self] (progress, souceIndex, targetIndex) in
            self?.pageTitleView.setTitle(progress: progress, sourceIndex: souceIndex, targetIndex: targetIndex)
        }
    }
    
    private func checkAvailableBrocadcast() {
        let broadVM = BroacastViewModel()
        broadVM.checkAvailableBroadcast()
        .then(on: DispatchQueue.main, execute: { (info) -> Void in
            HUD.showAlert(from: self, title: "继续上次直播吗?", mesaage: "您的粉丝还在等你哟", doneActionTitle: "继续", handle: {
                let vcc = BroadcastViewController()
                vcc.broacastVM.liveInfo = info
                self.present(vcc, animated: true, completion: nil)
            })
        })
        .catch { _ in }
    }
}

extension HomeViewController: YBPopupMenuDelegate {
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
         guard let vcc: HomeBaseCollectionVC = currentChildVC(pageTitleView.currentIndex) else { return }
        switch index {
        case 1: /// 只看男
            vcc.param.sex = .male
        case 2: /// 只看女
             vcc.param.sex = .female
        default: /// 全部
             vcc.param.sex = nil
            break
        }
        vcc.collectionView.mj_header.beginRefreshing()
    }
    
    private func currentChildVC<T: HomeBaseCollectionVC>(_ index: Int) -> T? {
        guard let vcc = childViewControllers[index] as? T else {
            return nil
        }
        return vcc
    }
}
