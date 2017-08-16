//
//  GiftView.swift
//  Live
//
//  Created by lieon on 2017/7/24.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

private let cellID = "GitftCell"
class GiftView: UIView {
    var models: [Gitft] = [] {
        didSet {
            collectView.reloadData()
            pageCount = models.count
            while pageCount % 8 != 0 {
                pageCount += 1
            }
            if models.count % 8 == 0 {
                pageControl.numberOfPages = models.count / 8
            } else {
                pageControl.numberOfPages = models.count / 8 + 1
            }
            
        }
    }
    
    var sendGiftAction: ((Gitft) -> Void)?
    fileprivate var pageCount: Int = 0
    fileprivate var selectedGift: Gitft?
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy var collectView: UICollectionView = { [weak self] in
        let layout = CollectionViewHorizontalLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        return collectionView
        }()

    fileprivate lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.numberOfPages = 3
        return view
    }()
    
     lazy  var sendBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("发送", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 16.5
        loginBtn.layer.masksToBounds = true
        loginBtn.isEnabled = false
        return loginBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = collectView.collectionViewLayout as? CollectionViewHorizontalLayout else { return }
        layout.itemSize = CGSize(width: bounds.width * 0.25, height: (bounds.height - 60) * 0.5)
        collectView.collectionViewLayout = layout
        
    }
}

extension GiftView {
    fileprivate  func setupUI() {
        collectView.register(GitftCell.self, forCellWithReuseIdentifier: cellID)
        collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        addSubview(collectView)
        addSubview(pageControl)
        addSubview(sendBtn)
        collectView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.height.equalTo(245 - 60)
        }

        pageControl.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(collectView.snp.centerX)
            maker.top.equalTo(collectView.snp.bottom).offset(-5)
        }
        
        sendBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.size.equalTo(CGSize(width: 64, height: 33))
            maker.bottom.equalTo(-5)
        }
        collectView.dataSource = self
        collectView.delegate = self
        weak var wekaSelf = self
        sendBtn.rx.tap
            .subscribe(onNext: { (value) in
                if let selectedGift = wekaSelf?.selectedGift {
                    wekaSelf?.sendBtn.addFaveAnimation()
                    wekaSelf?.sendGiftAction?(selectedGift)
                }
            })
            .disposed(by: self.disposeBag)
    }
}

extension GiftView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item >= models.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        } else {
            let cell: GitftCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.config(models[indexPath.item])
            return cell
        }
    }
}

extension GiftView: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let contentOffsetX = offSetX + self.collectView.bounds.width * 0.5
        let currentPage = Int(contentOffsetX / self.collectView.bounds.width)
         pageControl.currentPage = Int(currentPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.collectView.cellForItem(at: indexPath) as? GitftCell else {    return }
        self.selectedGift = cell.gift
        if cell.isEmptyData {
            sendBtn.isEnabled = false
            cell.bgView.isHidden = true
        } else {
            self.sendBtn.isEnabled = true
            cell.bgView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = self.collectView.cellForItem(at: indexPath) as? GitftCell else {    return }
        if cell.isEmptyData {
            sendBtn.isEnabled = false
            cell.bgView.isHidden = true
        } else {
            sendBtn.isEnabled = false
            cell.bgView.isHidden = true
        }
    }
}

class GitftCell: UICollectionViewCell, ViewNameReusable {
    var isEmptyData: Bool = false
    var gift: Gitft?
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy var avtarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "caomei@3x")
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0xffffff)
        label.text = "大宝剑"
        label.sizeToFit()
        return label
    }()
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
//        label.textAlignment = .center
        label.text = "10哆豆"
          label.sizeToFit()
        label.textColor = UIColor.gray
        return label
    }()
    lazy var bgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rect@3x")
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(bgView)
        contentView.addSubview(avtarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.backgroundColor = .clear
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(5)
            maker.right.equalTo(-5)
            maker.top.equalTo(5)
            maker.bottom.equalTo(0)
        }
        avtarImage.snp.makeConstraints { (maker) in
            maker.top.equalTo(9.5)
            maker.centerX.equalTo(self.snp.centerX)
            maker.size.equalTo(CGSize(width: 28, height: 36))
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(avtarImage.snp.bottom).offset(10)
            maker.centerX.equalTo(avtarImage.snp.centerX)
            maker.height.equalTo(12)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameLabel.snp.bottom).offset(8)
            maker.centerX.equalTo(nameLabel.snp.centerX)
        }
      
    }
    
    func config(_ gift: Gitft) {
        self.gift = gift
        if let _ = gift.name {
            isEmptyData = false
            isUserInteractionEnabled = true
            avtarImage.isHidden = false
            nameLabel.isHidden = false
            priceLabel.isHidden = false
            bgView.isHidden = true
            if let url = URL(string: CustomKey.URLKey.baseImageUrl + (gift.picture ?? "")) {
                avtarImage.kf.setImage(with: url, placeholder:  UIImage(named: "rect@3x"), options: nil, progressBlock: nil, completionHandler: nil)
                nameLabel.text = gift.name ?? ""
                priceLabel.text = "\(gift.pointCount )" + "哆豆"
            }
        } else {
            isEmptyData = true
            isUserInteractionEnabled = false
            avtarImage.isHidden = true
            nameLabel.isHidden = true
            priceLabel.isHidden = true
            bgView.isHidden = true
        }
      
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
