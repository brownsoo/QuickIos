//
//  Foot.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 11. 3..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation

public protocol Footable: AnyObject {
    var whoseFoot: String { get }
    func Log(_ items: Any...)
}

public protocol FootableName {
    var who: String { get }
}

public extension Footable {
    public var whoseFoot: String {
        if let who = self as? FootableName {
            return who.who
        }
        return #file.components(separatedBy: "/").last ?? String(describing: self)
    }
    
    func Log(_ items: Any..., line: Int = #line) -> Void {
        #if DEBUG
        let th = Thread.current.isMainThread ? "main": Thread.current.name ?? "-"
        print("🐾", th , whoseFoot, "(LINE \(line)) ", #function, 
            items.map { "\($0)" }.joined(separator: ", "), separator: " :: ")
        #endif
    }
}
// Bridge to objc
extension NSObject: Footable {
    public var whoseFoot: String {
        if let who = self as? FootableName {
            return who.who
        }
        return #file.components(separatedBy: "/").last ?? String(describing: self)
    }
}
