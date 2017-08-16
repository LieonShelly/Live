//
//  ViewerView.swift
//  Live
//
//  Created by lieon on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

private let cellID = "ViewerCell"
class ViewerView: UIView {
    fileprivate var disposeBag = DisposeBag()
    fileprivate lazy var collectView: UICollectionView = { [weak self] in

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         addSubview(collectView)
        collectView.backgroundColor = .clear
        collectView.register(ViewerCell.self, forCellWithReuseIdentifier: cellID)
        collectView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = collectView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: bounds.width * 0.25, height: bounds.width * 0.25)
        collectView.collectionViewLayout = layout
        
    }
    
    func config(_ items: Observable<[UserInfo]>) {
        items
            .bind(to: collectView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ViewerCell else { return UICollectionViewCell() }
                cell.backgroundColor = UIColor.clear
                cell.config(element)
                return cell
            }
            .disposed(by: disposeBag)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ViewerCell: UICollectionViewCell {
    
    fileprivate lazy var avtarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholderImage_avatar")
        imageView.sizeToFit()
        imageView.layer.cornerRadius = (self.bounds.height - 2 - 2) * 0.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var beanLable: UILabel = {
        let beanLable = UILabel()
        beanLable.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        beanLable.textAlignment = .center
        beanLable.font = UIFont.systemFont(ofSize: 9)
        beanLable.textColor = UIColor(hex: CustomKey.Color.mainColor)
        beanLable.layer.cornerRadius = 12 * 0.5
        beanLable.layer.masksToBounds = true
        return beanLable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(avtarImage)
        contentView.backgroundColor = .clear
        avtarImage.snp.makeConstraints { (maker) in
            maker.left.equalTo(2)
            maker.right.equalTo(-2)
            maker.top.equalTo(2)
            maker.bottom.equalTo(-2)
        }
        contentView.addSubview(beanLable)
        beanLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(12)
        }
    }
    
    func config(_ user: UserInfo) {
        if let avaatrURL = URL(string: CustomKey.URLKey.baseImageUrl + (user.avatar ?? "")) {
            avtarImage.kf.setImage(with: avaatrURL, placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        if let str = user.giveOut {
            beanLable.text = str
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
