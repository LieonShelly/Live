//
//  Transform.swift
//  Live
//
//  Created by lieon on 2017/6/21.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import ObjectMapper

open class IntStringTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Int? {
        if let time = value as? String {
            return Int(time)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Int?) -> String? {
        if let date = value {
            return String(date)
        }
        return nil
    }
}

open class ArrayOfURLTransform: TransformType {
    public typealias Object = [URL?]
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> [URL?]? {
        if let time = value as? [String] {
            return time.map { return URL(string: $0)}
        }
        return nil
    }
    
    public func transformToJSON(_ value: [URL?]?) -> String? {
        if let date = value {
            let array = date.flatMap { return $0?.absoluteString }
            return array.joined(separator: ",")
        }
        return nil
    }
}

open class FloatStringTransform: TransformType {
    public typealias Object = Float
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Float? {
        if let time = value as? String {
            return Float(time)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Float?) -> String? {
        if let date = value {
            return String(date)
        }
        return nil
    }
}

open class BoolNumberTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = Int
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Bool? {
        if let time = value as? Int {
            if time == 1 {
                return true
            } else {
                return false
            }
        }
        return nil
    }
    
    public func transformToJSON(_ value: Bool?) -> Int? {
        if let date = value {
            if date == true {
                return 1
            } else {
                return 0
            }
        }
        return nil
    }
}

open class BoolStringTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Bool? {
        if let time = value as? String {
            if time == "1" {
                return true
            } else {
                return false
            }
        }
        return nil
    }
    
    public func transformToJSON(_ value: Bool?) -> String? {
        if let date = value {
            if date == true {
                return "1"
            } else {
                return "0"
            }
        }
        return nil
    }
}

open class DoubleStringTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Double? {
        if let time = value as? String {
            return Double(time)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Double?) -> String? {
        if let date = value {
            return String(date)
        }
        return nil
    }
}

open class HtmlStringTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> String? {
        if let time = value as? String {
            let string = time.stringByRemovingCharactersInSet(CharacterSet(charactersIn: "\""))
            return string
        }
        return nil
    }
    
    public func transformToJSON(_ value: String?) -> String? {
        if let date = value {
            return String(date)
        }
        return nil
    }
}

open class DataStringTransform: TransformType {
    public typealias Object = Data
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Data? {
        if let time = value as? String {
            return Data(base64Encoded: time, options: .ignoreUnknownCharacters)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Data?) -> String? {
        if let date = value {
            return date.base64EncodedString(options: .lineLength64Characters)
        }
        return nil
    }
    
}

open class RegionPathsTransform: TransformType {
    public typealias Object = [String]
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> [String]? {
        if let string = value as? String {
            return string.components(separatedBy: ",")
        }
        return nil
    }
    
    public func transformToJSON(_ value: [String]?) -> String? {
        if let strings = value {
            // FIXME: need test
            return strings.reduce("", { $0 ?? $1 + "," + $1 })
        }
        return nil
    }
}

open class DateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = Double
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let interval = value as? Double {
           return Date(timeIntervalSince1970: interval / 1000.0)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
          return date.timeIntervalSince1970 * 1000.0
        }
        return nil
    }

}
