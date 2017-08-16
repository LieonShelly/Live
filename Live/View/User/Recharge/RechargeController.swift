//
//  RechargeController.swift
//  Live
//
//  Created by fanfans on 2017/7/19.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import StoreKit
import PromiseKit
import YYText

class RechargeController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    fileprivate let tipsItems = ["220哆豆", "480哆豆", "2660哆豆", "9999哆豆"]
    fileprivate let priceItems = ["6元", "12元", "60元", "188元"]
    fileprivate let productIdItems = ["duo_bean_6", "duo_bean_12", "duo_bean_60", "duo_bean_188"]
    var productId: String = ""
    
    fileprivate lazy var helpBtn: UIButton = {
        let helpBtn = UIButton()
        helpBtn.frame = CGRect(x:UIScreen.width - 44, y: 20, width: 44, height: 44)
        helpBtn.setTitle("帮助", for: .normal)
        helpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        helpBtn.setTitleColor(UIColor.white, for: .normal)
        helpBtn.addTarget(self, action: #selector(self.helpTapAction), for: .touchUpInside)
        return helpBtn
    }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(), style: .plain)
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(AllBeanCell.self, forCellReuseIdentifier: "AllBeanCell")
        taleView.register(BeanProductCell.self, forCellReuseIdentifier: "BeanProductCell")
        return taleView
    }()
    fileprivate lazy var footView: UIView = {
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 80))
        footView.backgroundColor = UIColor(hex: 0xfafafa)
        let deslable: YYLabel = YYLabel(frame: CGRect(x: 0, y: (80 - 25) * 0.5, width: UIScreen.width, height: 25))
        deslable.textColor = UIColor(hex:0x999999)
        deslable.font = UIFont.systemFont(ofSize: 12)
        footView.addSubview(deslable)
        deslable.textAlignment = .center
        let text = NSMutableAttributedString()
        let pad = NSMutableAttributedString(string: " ")
        pad.yy_font = UIFont.systemFont(ofSize: 12)
        text.append(pad)
        let levelStr = NSMutableAttributedString(string: "充值如果有问题请联系客服电话:")
        levelStr.yy_font = UIFont.systemFont(ofSize: 12)
        levelStr.yy_color = UIColor(hex: 0x999999)
        text.append(levelStr)
        text.append(pad)
        let countStr = NSMutableAttributedString(string: "400-189-0090")
        countStr.yy_font = UIFont.systemFont(ofSize: 12)
        countStr.yy_color = UIColor(hex: CustomKey.Color.mainColor)
        text.append(countStr)
        text.yy_alignment = .center
        deslable.attributedText = text
        return footView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        self.title = "充值"
        let rightBtnItem = UIBarButtonItem(customView: helpBtn)
        navigationItem.rightBarButtonItem = rightBtnItem
        
        view.addSubview(tableView)
        tableView.tableFooterView = footView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 4 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: AllBeanCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            let text = NSMutableAttributedString()
            let pad = NSMutableAttributedString(string: " ")
            pad.yy_font = UIFont.systemFont(ofSize: 16)
            text.append(pad)
            let levelStr = NSMutableAttributedString(string: "哆豆")
            levelStr.yy_font = UIFont.systemFont(ofSize: 16)
            levelStr.yy_color = UIColor(hex: 0x222222)
            text.append(levelStr)
            text.append(pad)
            let countStr = NSMutableAttributedString(string: "\(CoreDataManager.sharedInstance.getUserInfo()?.point ?? 0)")
            countStr.yy_font = UIFont.systemFont(ofSize: 16)
            countStr.yy_color = UIColor(hex: CustomKey.Color.mainColor)
            text.append(countStr)
            cell.allBeanLabel.attributedText = text
            return cell
        }
        let cell: BeanProductCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.allBeanLabel.text = tipsItems[indexPath.row]
        cell.rightBtn.setTitle(priceItems[indexPath.row], for: .normal)
        cell.rightBtn.tag = indexPath.row
        cell.rightBtn.addTarget(self, action: #selector(self.buyBtnAction(btn:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 60 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ?  35 : 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let sectionView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 35))
        sectionView.backgroundColor = UIColor(hex: 0xfafafa)
        let tipsLable: UILabel = UILabel(frame: CGRect(x: 12, y: 0, width: UIScreen.width - 12, height: 35))
        tipsLable.text = "充值金额"
        tipsLable.font = UIFont.systemFont(ofSize: 12)
        tipsLable.textColor = UIColor(hex:0x999999)
        sectionView.addSubview(tipsLable)
        return sectionView
    }
    
    // MARK: helpTapAction
    @objc fileprivate  func helpTapAction() {
        let webVC = WebPageController(urlStr: "http://duoji.b0.upaiyun.com/static/point-explain/point_live_ios.html", navTitle: "")
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc fileprivate func buyBtnAction(btn: UIButton) {
        if SKPaymentQueue.canMakePayments() {
            self.productId = productIdItems[btn.tag]
            HUD.show(true, show: "", enableUserActions: true, with: self)
            self.requestProductData(productId: productIdItems[btn.tag])
        } else {
            print("不允许内购")
            view.makeToast("不允许内购")
        }
    }
    
    func requestProductData(productId: String) {
        if  let nsset = NSSet(array: [productId]) as? Set<String> {
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: nsset )
            request.delegate = self
            request.start()
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        HUD.show(false, show: "", enableUserActions: true, with: self)
        let productArr = response.products
        if productArr.isEmpty {
            print("没有商品")
            HUD.showAlert(from: self, title: "没有商品", enterTitle: "确定", mesaage: "", success: {
            })
        }
        guard let pro = productArr.last else { return }
        if pro.productIdentifier == self.productId {
            let payment: SKPayment = SKPayment(product: pro)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
    }
    
    func requestDidFinish(_ request: SKRequest) {
        
    }
    
    @available(iOS 3.0, *)
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for tran: SKPaymentTransaction in transactions {
            HUD.show(true, show: "", enableUserActions: true, with: self)
            print("错误信息：\(tran.error?.localizedDescription ?? "")")
            if let errorMessage = tran.error?.localizedDescription, !errorMessage.isEmpty {
                HUD.showAlert(from: self, title: "", enterTitle: "确定", mesaage: errorMessage, success: {
                })
            }
            switch tran.transactionState {
            case .purchasing:
                print("商品添加进列表")
                break
            case .purchased:
                  HUD.show(false, show: "", enableUserActions: true, with: self)
                self .completeTransaction(transaction: tran)
                SKPaymentQueue.default().finishTransaction(tran)
                print("交易完成")
                break
            case .failed:
                  HUD.show(false, show: "", enableUserActions: true, with: self)
                print("交易失败")
                SKPaymentQueue.default().finishTransaction(tran)
                break
            case .restored:
                  HUD.show(false, show: "", enableUserActions: true, with: self)
                print("已经购买过")
                SKPaymentQueue.default().finishTransaction(tran)
                break
            default:
                print("交易失败")
                  HUD.show(false, show: "", enableUserActions: true, with: self)
                SKPaymentQueue.default().finishTransaction(tran)
                break
            }
        }
    }
    
    func completeTransaction(transaction: SKPaymentTransaction) {
        print("交易结束")
        let productIdentifier: String = transaction.payment.productIdentifier
            if !productIdentifier.characters.isEmpty {
                if let receiptURL = Bundle.main.appStoreReceiptURL, let receiptData = NSData(contentsOf: receiptURL) {
                    let encodeStr = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                    let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr + "\"}")
                    let payloadData = payload.data(using: String.Encoding.utf8.rawValue)
                    print("payloadData:\(String(describing: payloadData))")
                    let rechargeVM = RechargeViewModel()
                    let param = RechargeRequestParam()
                    // FIXME: Change Enviroment
                    param.environment = .test
                    param.receipt = encodeStr
                    rechargeVM.requstRecharge(with: param)
                        .then(execute: { _ -> Promise<Bool> in
                            self.view.makeToast("充值成功")
                            let userVM = UserInfoManagerViewModel()
                            return userVM.requstUserInfo()
                        })
                        .then(execute: { _ -> Void in
                            self.tableView.reloadData()
                        })
                        .catch(execute: { (error) in
                        if let error = error as? AppError {
                            self.view.makeToast(error.message)
                        }
                    })
                }
            }
    }
}
