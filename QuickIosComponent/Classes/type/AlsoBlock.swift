// 
// Created by brownsoo han on 2018. 6. 7..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

public protocol Also {
    @discardableResult
    func also(_ block: (Self)->Void) -> Self
}

public extension Also {
    @discardableResult
    func also(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

public extension Also where Self : UIView {
}

public extension Also where Self : UIButton {
}

public extension Also where Self : AnyObject { }



