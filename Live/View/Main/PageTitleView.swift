//
//  PageTitleView.swift
//  AdForMerchant
//
//  Created by lieon on 2017/4/18.
//  Copyright © 2017年 Windward. All rights reserved.
//

import UIKit

private let scrollowLineH: CGFloat = 2.0
private let zoomScale: CGFloat = 1.2
private let labelCountPerPage: Int = 3
private let normalColor: (CGFloat, CGFloat, CGFloat) = (255, 255, 255)
private let selectColor: (CGFloat, CGFloat, CGFloat) = (255, 171, 51)

class  PageTitleView: UIView {
    var titleTapAction: ((_ index: Int) -> Void)?
    var currentIndex: Int = 0 {
        didSet {
            self.scrollRectToVisibleCentered(on: self.titleLabels[currentIndex].frame, isAnimate: true)
        }
    }
    fileprivate var labelWidth: CGFloat = 0.0
    fileprivate var titles: [String]
    fileprivate lazy var colorLineWidths: [CGFloat] = [CGFloat]()
    fileprivate var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.scrollsToTop = false
        sv.bounces = true
        return sv
    }()
    fileprivate lazy var colorLine: UIView = {
        let colorLine = UIView()
        colorLine.backgroundColor = UIColor(red: selectColor.0 / 255.0, green: selectColor.1 / 255.0, blue: selectColor.2 / 255.0, alpha: 1)
        return colorLine
    }()

    fileprivate lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = self.backgroundColor
        return scrollLine
    }()
    
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension  PageTitleView {
    func setTitle(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        if sourceIndex >= titleLabels.count || targetIndex >= titleLabels.count {
            return
        }
        let souceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        let offsetX = targetLabel.frame.origin.x  - souceLabel.frame.origin.x
        let totalX = offsetX * progress
        scrollLine.frame.origin.x = souceLabel.frame.origin.x + totalX
        let colorDelta = (selectColor.0 - normalColor.0, selectColor.1 - normalColor.1, selectColor.2 - normalColor.2)
        souceLabel.textColor = UIColor(red: (selectColor.0 - colorDelta.0 * progress) / 255.0, green: (selectColor.1 - colorDelta.1 * progress) / 255.0, blue: (selectColor.2 - colorDelta.2 * progress) / 255.0, alpha: 1)
        targetLabel.textColor = UIColor(red: (normalColor.0 + colorDelta.0 * progress) / 255.0, green: (normalColor.1 + colorDelta.1 * progress) / 255.0, blue: (normalColor.2 + colorDelta.2 * progress) / 255.0, alpha: 1)
        currentIndex = targetIndex
    }
}

extension  PageTitleView {
    fileprivate  func setupUI() {
        addSubview(scrollView)
        colorLine.isHidden = true
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: CGFloat(titles.count) * frame.width / CGFloat(labelCountPerPage), height: bounds.height)
        setupTtitleLabels()
        setupBottomLineAndScrollLine()
        caculateColorLineWidth()
    }
    
    fileprivate  func setupTtitleLabels() {
        let labelW: CGFloat = frame.width / CGFloat(labelCountPerPage)
        labelWidth = labelW
        let labelH: CGFloat = frame.height
        let labelY: CGFloat = 0.0
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            if UIScreen.main.bounds.width <= 320 {
                label.font = UIFont.systemFont(ofSize: 13.0)
            } else {
                label.font = UIFont.systemFont(ofSize: 15.0)
            }
            label.textColor = UIColor(red: normalColor.0 / 255.0, green: normalColor.1 / 255.0, blue: normalColor.2 / 255.0, alpha: 1)
            label.tag = index
            label.textAlignment = .center
            label.text = title
            label.font = UIFont.systemFont(ofSize: 16)
            let labelX = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            titleLabels.append(label)
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabellCilck(tap:)))
            label.addGestureRecognizer(tap)
        }
    }
    
    fileprivate  func setupBottomLineAndScrollLine() {
        guard let firtLabel = titleLabels.first else { return  }
        firtLabel.textColor = UIColor(red: selectColor.0 / 255.0, green: selectColor.1 / 255.0, blue: selectColor.2 / 255.0, alpha: 1)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: 0, y: frame.height - scrollowLineH, width: firtLabel.frame.width, height: scrollowLineH)
        scrollLine.addSubview(colorLine)
    }
    
    fileprivate func caculateColorLineWidth() {
        titles.forEach { text in
            let width = caculatetextWidth(text: text)
            self.colorLineWidths.append(width)
        }
        if let colorLineWidth = colorLineWidths.first {
            colorLine.frame = CGRect(x: scrollLine.bounds.width * 0.5 - colorLineWidth * 0.5, y: 0, width: colorLineWidth, height: scrollowLineH)
        }
        
    }
    
    fileprivate func scrollRectToVisibleCentered(on visibleRect: CGRect, isAnimate: Bool) {
        let centeredRect = CGRect(x: visibleRect.origin.x + visibleRect.size.width / 2.0 - self.scrollView.frame.size.width / 2.0, y: visibleRect.origin.y + visibleRect.size.height / 2.0 - self.scrollView.frame.size.height / 2.0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
        self.scrollView.scrollRectToVisible(centeredRect, animated: isAnimate)
    }
    
    @objc  private  func titleLabellCilck(tap: UITapGestureRecognizer) {
        guard let selectedLabel = tap.view as? UILabel else { return  }
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = UIColor(red: normalColor.0 / 255.0, green: normalColor.1 / 255.0, blue: normalColor.2 / 255.0, alpha: 1)
        selectedLabel.textColor = UIColor(red: selectColor.0 / 255.0, green: selectColor.1 / 255.0, blue: selectColor.2 / 255.0, alpha: 1)
        currentIndex = selectedLabel.tag
        let offsetX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.1) {
            self.scrollLine.frame.origin.x = offsetX
            let colorLineWidth = self.colorLineWidths[selectedLabel.tag]
            self.colorLine.frame = CGRect(x: self.scrollLine.bounds.width * 0.5 - colorLineWidth * 0.5, y: 0, width: colorLineWidth, height: scrollowLineH)
        }
        if let block = titleTapAction {
            block(selectedLabel.tag)
        }
    }
    
    private func caculatetextWidth(text: String) -> CGFloat {
        let nsstr = NSString(string: text)
        let maxSize = CGSize(width: frame.width / CGFloat(labelCountPerPage), height: 40)
        let size = nsstr.boundingRect(with: maxSize, options: .usesDeviceMetrics, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
        return size.width + 10
    }
}
