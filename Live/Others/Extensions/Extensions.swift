//
//  Extensions.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping
// swiftlint:disable syntactic_sugar
// swiftlint:disable identifier_name

import UIKit
import SwiftDate
import RxSwift
import RxCocoa

extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func getScreenShot() -> UIImage {
        guard  let window = UIApplication.shared.keyWindow else { return UIImage() }
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, true, UIScreen.main.scale)
        guard  let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        window.layer.render(in: context)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        guard let  data = UIImageJPEGRepresentation(img, 0.5) else { return UIImage() }
         guard let shot = UIImage(data: data) else { return UIImage() }
        return shot
    }
}

extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        self.init(red: CGFloat(r) / 0xff,
                  green: CGFloat(g) / 0xff,
                  blue: CGFloat(b) / 0xff,
                  alpha: alpha)
    }
    
    static var randomColor: UIColor {
        let r = arc4random_uniform(256)
        let g = arc4random_uniform(256)
        let b = arc4random_uniform(256)
        return  UIColor(red: CGFloat(r)/256.0, green: CGFloat(g)/256.0, blue: CGFloat(b)/256.0, alpha: 1.0)
    }
    
}

extension URL {
    func queryDictionary() -> [String:String] {
        var dictionary: [String:String] = [:]
        guard let components = URLComponents(string: self.absoluteString)?.queryItems else {
            return dictionary
        }
        
        for pairs in components {
            dictionary[pairs.name] = pairs.value
        }
        
        return dictionary
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

fileprivate let dateFormatter: DateFormatter = {
    let dateFmt = DateFormatter()
    dateFmt.timeZone = TimeZone.current
    return dateFmt
}()

extension Date {
    
    func timeAgoSince() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.day, .month, .year], from: self, to: now)
        
        if components.year! >= 1 {
            return self.toString("yyyy/MM/dd")
        }
        
        if components.day! >= 1 {
            return self.toString("MM/dd")
        }
        
        return self.toString("HH:mm")
        
    }
    
    func toString(_ format: String? = "yyyy-MM-dd") -> String {
        if let fmt = format {
            dateFormatter.dateFormat = fmt
        }
        return dateFormatter.string(from: self)
    }
    
    func toAppointString(_ format: String? = "yyyy年MM月dd日 HH:mm") -> String {
        if let fmt = format {
            dateFormatter.dateFormat = fmt
        }
        return dateFormatter.string(from: self)
    }
    
    /// 同一天
    func isSameDay(_ date: Date) -> Bool {
        return year == date.year && month == date.month && day == date.day
    }
    
    func toDateString(_ format: String? = "yyyy年MM月dd日") -> String {
        if let fmt = format {
            dateFormatter.dateFormat = fmt
        }
        return dateFormatter.string(from: self)
    }
    
    static func timeFromInterval(_ interval: TimeInterval) -> (Int, Int, Int) {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        let days = (interval / (3600 * 24))
        return (days, hours, minutes)
    }
}

extension Array where Element: Hashable {
    func containsArray(array: [Element]) -> Bool {
        let selfSet = Set(self)
        return !array.contains { !selfSet.contains($0) }
    }
}

extension Array {
    func groupBy<G: Hashable>(_ groupClosure: (Element) -> G) -> [G: [Element]] {
        var dictionary = [G: [Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var array: [Element]? = dictionary[key]
            
            if array == nil {
                array = [Element]()
            }
            
            array!.append(element)
            dictionary[key] = array!
        }
        
        return dictionary
    }
    
}

let numFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    return formatter
}()

extension Float {
    
    /// 转换 为字符串
    ///
    /// - Returns: 字符串(去掉末尾为0的小数)
    func numberToString() -> String {
        let str = String(format: "%.2f", self)
        guard let amount = Float(str) else { return ""}
        var size = 2
        if (amount) == roundf(amount) {
            size = 0
        } else if amount*10 == roundf(amount*10) {
            size = 1
        }
        numFormatter.roundingMode = .halfUp
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = size
        numFormatter.maximumFractionDigits = size
        let number = numFormatter.string(from: NSNumber(value: amount)) ?? ""
        return number
    }
}

extension Double {
    /// 转换 为字符串
    ///
    /// - Returns: 字符串(去掉末尾为0的小数)
    func numberToString() -> String {
        let str = String(format: "%.2f", self)
        guard let amount = Float(str) else { return ""}
        var size = 2
        if (amount) == roundf(amount) {
            size = 0
        } else if amount * 10 == roundf(amount * 10) {
            size = 1
        }
        numFormatter.roundingMode = .halfUp
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = size
        numFormatter.maximumFractionDigits = size
        let number = numFormatter.string(from: NSNumber(value: amount)) ?? ""
        return number
    }
}

extension String {
    static func randomStr(withLength length: Int) -> String {
        let kRandomAlphabet: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString: NSMutableString = NSMutableString.init(capacity: length)
        for _ in 0..<length {
            randomString.appendFormat("%c", kRandomAlphabet.character(at: Int(arc4random_uniform(UInt32(kRandomAlphabet.length)))))
        }
        return randomString as String
    }
    
    func implicitPhoneNumFormat() -> String {
        if self.characters.count != 11 {
            
        }
        let length = self.characters.count
        let subStr0: String = (self as NSString).substring(with: NSRange(location: 0, length: 3))
        let subStr1: String = (self as NSString).substring(with: NSRange(location: length - 4, length: 4))
        return "\(subStr0)*****\(subStr1)"
    }
    
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    func tmpDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    //每四个字符后插入一个空格
    func couponString() -> String {
        let mutableString = NSMutableString(string: self)
        let i = mutableString.length / 4
        for n in 0..<i {
            mutableString.insert(" ", at: (n + 1) * 4 + n)
        }
        return mutableString as String
    }
    
    func md5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        let result = (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
        
        return result
    }
    
    static func randomText(_ length: Int) -> String {
        var text = ""
        for _ in 1...length {
            var decValue = 0  // ascii decimal value of a character
            var charType = 3  // default is lowercase
            charType =  Int(arc4random_uniform(3) + 1)
            switch charType {
            case 1:  // digit: random Int between 48 and 57
                decValue = Int(arc4random_uniform(10)) + 48
            case 2:  // uppercase letter
                decValue = Int(arc4random_uniform(26)) + 65
            case 3:  // lowercase letter
                decValue = Int(arc4random_uniform(26)) + 97
            default:  // space character
                decValue = 32
            }
            // get ASCII character from random decimal value
            if let value = UnicodeScalar(decValue) {
                let char = String(describing: value)
                text = text.appending(char)
            }
        }
        return text
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        let base64String: String = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let result = String(base64String)
        return result
    }
    
    func stringByRemovingCharactersInSet(_ characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined(separator: "")
    }
    
    /**
     替换指定范围字符串，保留其他部分
     
     - parameter count: 需要保留的位数
     
     - returns: 指定位数的字符串
     */
    func replaceWith(_ replace: String = "*", range: NSRange) -> String {
        let replaceString = NSString(string: replace).padding(toLength: range.length, withPad: replace, startingAt: 0)
        var result = NSString(string: self)
        result = result.replacingCharacters(in: range, with: replaceString) as NSString
        return result as String
    }
    
    func deleteWith(_ deleteString: String) -> String {
        var result = self
        result = result.replacingOccurrences(of: deleteString, with: "")
        return result as String
    }
    
    func URLEncode() -> String! {
        let customAllowedSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]~")
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString
    }
    
    func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func dateFromString(_ timeString: String? = "yyyy-MM-dd") -> Date {
        if let time = timeString {
            guard let date = dateFormatter.date(from: time) else {return Date()}
            return date
        } else {
            return Date()
        }
    }
    
    func attributedString(_ color: UIColor = UIColor(hex: 0xff6400), fontSize: CGFloat, weight: CGFloat? = nil, strikethrough: Bool = false) -> NSAttributedString {
        guard let weight = weight else {
            return NSAttributedString(string: self,
                                      attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont.systemFont(ofSize: fontSize), NSStrikethroughStyleAttributeName: strikethrough])
        }
        return NSAttributedString(string: self,
                                  attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont.systemFont(ofSize: fontSize, weight: weight), NSStrikethroughStyleAttributeName: strikethrough])
    }
    
    /**
     将汉字转换成拼音
     - parameter str:            汉字
     - parameter isAbbreviation: 是否缩写拼音
     - returns: 拼音
     */
    func translateChineseIntoPinyin(_ str: String, isAbbreviation: Bool) -> String {
        var pinYinStr = String()
        var newStrArray: [String] = []
        let pinyin: CFMutableString = NSMutableString(string: str) as CFMutableString
        if CFStringTransform(pinyin, nil, kCFStringTransformMandarinLatin, false) {
        }
        //再转换为不带声调的拼音
        if CFStringTransform(pinyin, nil, kCFStringTransformStripDiacritics, false) {
            //再去除空格，将拼音连在一起
            pinYinStr = pinyin as String
            pinYinStr = pinYinStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            pinYinStr = pinYinStr.replacingOccurrences(of: "\r", with: "")
            pinYinStr = pinYinStr.replacingOccurrences(of: "\n", with: "")
            pinYinStr = pinYinStr.replacingOccurrences(of: "n xing", with: "n hang")
            guard isAbbreviation == true else {
                pinYinStr = pinYinStr.replacingOccurrences(of: " ", with: "")
                return pinYinStr
            }
            
        }
        let array = pinYinStr.components(separatedBy: " ")
        for str in array {
            let zufu = (str as NSString).substring(to: 1)
            newStrArray.append(zufu)
        }
        let joinStr = newStrArray.joined(separator: "")
        return joinStr
    }
    
    func toPhoneString() -> String {
        let phone = NSMutableString(string: self)
        if phone.length >= 11 {
            for i in 0..<2 {
                phone.insert(" ", at: 5 * i + 3)
            }
        }
        return phone as String
    }
    
    // 返回折扣
    func getAttString() -> NSMutableAttributedString {
        let newString = self+"折"
        let attString = NSMutableAttributedString(string: newString)
        let range = (self as NSString).range(of: ".")
        let rangeZhe = (newString as NSString).range(of: "折")
        
        attString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize:27), range:
            NSRange(location: range.location-1, length: 1))
        
        attString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize:20), range: NSRange(location: 1, length: 2))
        attString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize:15), range: NSRange(location: 3, length: 1))
        attString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 0, length: 4))
        attString.addAttribute(NSBaselineOffsetAttributeName, value: 1, range: rangeZhe)
        return attString
    }
    // 保留两位小数
    func  keepTwoPlacesDecimal() -> String {
        
        let stringCount = self.characters.count
        let nsString = self as NSString
        if self.contains(".") {
            if nsString.substring(from: stringCount-1) == "." {
            } else {
                let strlocation = nsString.range(of: ".")
                let decimalCount = nsString.substring(from: strlocation.location).characters.count
                if decimalCount >= 3 {
                    return  nsString.substring(to: strlocation.location+3)
                }
                return self
            }
        }
        return self
    }
    
    func validatePassword() -> Bool {
        let chars = "!@#$%+-,\\.;'"
        let regex = "^((?=.*?\\d)(?=.*?[A-Za-z])|(?=.*?\\d)(?=.*?[\(chars)])|(?=.*?[A-Za-z])(?=.*?[\(chars)]))[\\dA-Za-z\(chars)]{6,16}$"
        let passPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        //        print(passPredicate.evaluate(with: self))
        return passPredicate.evaluate(with:self)
    }
    
    static func dateStrFormTimeInterval(with timeIntervalStr: String, format: String) -> String {
        let timeInterval: CLongLong = CLongLong(timeIntervalStr)!
        let seconds: CLongLong = timeInterval / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        let dateformater = DateFormatter()
        dateformater.dateFormat = format
        return dateformater.string(from: date)
    }
    
    func  transformToDate(with format: String) -> String? {
        if let timeInterval = TimeInterval(self) {
            // yyyy年MM月dd日 HH:mm:ss
            let date = Date(timeIntervalSince1970: timeInterval)
            let dateformater = DateFormatter()
            dateformater.dateFormat = format
           return dateformater.string(from: date)
        }
        return nil
    }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: left)
    result.append(right)
    return result
}

extension NSAttributedString {
    
    // 前半部分和后半部分字体不同
    convenience init(leftString: String, rightString: String, leftColor: UIColor, rightColor: UIColor, leftFontSize: CGFloat, rightFoneSize: CGFloat) {
        let string: NSAttributedString
        let left = leftString.attributedString(leftColor, fontSize: leftFontSize)
        let right = rightString.attributedString(rightColor, fontSize: rightFoneSize)
        string = left + right
        self.init(attributedString: string)
    }
    
    // 地址页面的默认地址
    convenience init(defaultString: String = "【默认】", unit: String, isDefault: Bool) {
        let string: NSAttributedString
        let string1 = defaultString.attributedString(fontSize: 15)
        let unitString = unit.attributedString(UIColor.darkGray, fontSize: 15)
        if isDefault == true {
            string = string1 + unitString
        } else {
            string = unitString
        }
        self.init(attributedString: string)
    }
    
    convenience init(amountNumber: Int, leftString: String, rightString: String, color: UIColor, amountFontSize: CGFloat, leftStringFontSize: CGFloat, rightStringFontSize: CGFloat) {
        //        let formatter = NSNumberFormatter()
        //        formatter.numberStyle = .DecimalStyle
        //
        //        let amount = amountNumber
        let number = String(format: "%+d", amountNumber)
        //let number = formatter.stringFromNumber(amount) ?? ""
        let numberString = number.attributedString(color, fontSize: amountFontSize)
        let left = leftString.attributedString(color, fontSize: leftStringFontSize)
        let right = rightString.attributedString(color, fontSize: rightStringFontSize)
        let string: NSAttributedString
        string = left + numberString + right
        self.init(attributedString: string)
    }
    
    // TODO:
    convenience init(amountNumber: Float, color: UIColor, amountFontSize: CGFloat, unitFontSize: CGFloat, strikethrough: Bool = false, fontWeight: CGFloat?, unit: String, decimalPlace: Int? = nil, useBigUnit: Bool = false) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        var amount = amountNumber
        
        var bigUnitFlag = false
        if unit == "元" && useBigUnit == true && amount > 10000 {
            amount = Float(amount / 10000.0)
            bigUnitFlag = true
        }
        
        if let size = decimalPlace {
            formatter.roundingMode = .halfUp
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = size
            formatter.maximumFractionDigits = size
        }
        
        let number = formatter.string(from: NSNumber(value: amount)) ?? ""
        
        let numberString = number.attributedString(color, fontSize: amountFontSize, weight: fontWeight, strikethrough: strikethrough)
        let bitUnitString = "万".attributedString(color, fontSize: amountFontSize, weight: fontWeight, strikethrough: strikethrough)
        let unitString = unit.attributedString(color, fontSize: unitFontSize, weight: fontWeight, strikethrough: strikethrough)
        let string: NSAttributedString
        if bigUnitFlag {
            if unit == "¥" {
                string = unitString + numberString + bitUnitString
            } else {
                string = numberString + bitUnitString + unitString
            }
            
        } else {
            if unit == "¥" {
                string = unitString + numberString
            } else {
                string = numberString + unitString
            }
        }
        self.init(attributedString: string)
    }
}

extension UIWindow {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
}

extension UIButton {
     func addFaveAnimation() {
        let btnAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnimation.values = [(1.0), (0.7), (0.5), (0.3), (0.5), (0.7), (1.0), (1.2), (1.4), (1.2), (1.0)]
        btnAnimation.keyTimes = [(0.0), (0.1), (0.2), (0.3), (0.4), (0.5), (0.6), (0.7), (0.8), (0.9), (1.0)]
        btnAnimation.calculationMode = kCAAnimationLinear
        btnAnimation.duration = 0.3
        self.layer.add(btnAnimation, forKey: nil)
    }
}

extension Dictionary {
    func toJSONString() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return  ""}
        guard let str = String(data: data, encoding: .utf8) else { return  ""}
        return str
    }
}

extension UIFont {
    static func sizeToFit(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: (size * UIScreen.width) / 320.0)
    }
}

extension Double {
    var fitHeight: CGFloat {
        return CGFloat((self / 1334.0) * Double(UIScreen.height))
    }
    
    var fitWidth: CGFloat {
        return CGFloat((self / 750.0) * Double(UIScreen.width))
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ViewNameReusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ViewNameReusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension Reactive where Base: UIImagePickerController {
    public var didFinishPickingMediaWithInfo: Observable<[String : AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
            })
    }
    
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
}

extension Reactive where Base: UIViewController {
    public var didLoadView: Observable<[String: AnyObject]> {
        return self
            .methodInvoked(#selector(UIViewController.viewDidLoad))
            .map({ (a) in
                return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
            })
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
