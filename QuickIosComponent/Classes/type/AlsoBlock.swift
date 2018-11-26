// 
// Created by brownsoo han on 2018. 6. 7..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

public protocol AlsoBlock {
    @discardableResult
    func also(_ block: (Self)->Void) -> Self
}

public extension AlsoBlock {
    @discardableResult
    public func also(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}
