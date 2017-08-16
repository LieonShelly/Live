//
//  PageContentView.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit

private let cellID = "cell"
class PageContentView: UIView {

    var tapAction:((_ progress: CGFloat, _ sourceIndex: Int, _ targetIndx: Int) -> Void)?
    fileprivate var childVCs: [UIViewController]
    fileprivate var startOffsetX: CGFloat = 0.0
    fileprivate var  isForbiden: Bool = false
    fileprivate weak var parentVC: UIViewController?
    fileprivate lazy var collectView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
        }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageContentView {
    fileprivate  func setupUI() {
        for childVC in childVCs {
            parentVC!.addChildViewController(childVC)
        }
        collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(collectView)
    }
}

extension PageContentView {
    func selected(index: Int) {
        isForbiden = true
        let offsetX = CGFloat(index) * bounds.width
        collectView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
}

extension PageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbiden = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbiden {
            return
        }
        let currentOffsetX = scrollView.contentOffset.x
        var targetIndex: Int = 0
        var sourceIndex: Int = 0
        var progress: CGFloat = 0.0
        let scrollViewWidth = scrollView.frame.width
        if currentOffsetX > startOffsetX {
            progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth)
            sourceIndex = Int(currentOffsetX / scrollViewWidth)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            if currentOffsetX - startOffsetX == scrollViewWidth {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            progress = 1 - currentOffsetX/scrollViewWidth  + floor(currentOffsetX / scrollViewWidth)
            targetIndex = Int(currentOffsetX / scrollViewWidth)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        if let block = tapAction {
            block(progress, sourceIndex, targetIndex)
        }
    }
}
