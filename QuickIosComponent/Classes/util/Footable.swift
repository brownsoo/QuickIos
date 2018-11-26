//
//  Foot.swift
//  StudioUser
//
//  Created by brownsoo han on 2017. 11. 3..
//  Copyright © 2017년 TLX. All rights reserved.
//

import Foundation

public protocol Footable: AnyObject {
    var whoseFoot: String { get }
    func foot(_ items: Any...)
}

public protocol FootableName {
    var who: String { get }
}

public extension Footable {
    public var whoseFoot: String {
        if let who = self as? FootableName {
            return who.who
        }
        return String(describing: self)
    }
    
    func foot(_ items: Any...) -> Void {
        #if DEBUG
        let th = Thread.current.isMainThread ? "main": Thread.current.name ?? "-"
        print("🐾", th , whoseFoot, items.map { "\($0)" }.joined(separator: ", "), separator: " | ")
        #endif
    }
}
// Bridge to objc
extension NSObject: Footable {
    public var whoseFoot: String {
        if let who = self as? FootableName {
            return who.who
        }
        return String(describing: self)
    }
}
