//
//  Model.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa
import RxDataSources

class SectionModel<Section, ItemType>: SectionModelType, CustomStringConvertible {
    public typealias Identity = Section
    public typealias Item = ItemType
    public var model: Section
    
    public var identity: Section {
        return model
    }
    
    public var items: [Item]
    
    public init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
    
    public var description: String {
        return "\(self.model) > \(items)"
    }
    
    public required init(original: SectionModel<Section, Item>, items: [Item]) {
        self.model = original.model
        self.items = items
    }
}

open class Model: Mappable {
    
    public init() {
        
    }
    
    // MARK: Mappable
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        
    }
    
}

// MARK: - Model Debug String
extension Model: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var str = "\n"
        let properties = Mirror(reflecting: self).children
        for c in properties {
            if let name = c.label {
                str += name + ": \(c.value)\n"
            }
        }
        return str
    }
}
