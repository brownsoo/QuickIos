//
//  JustView.swift
//
import UIKit

open class JustView: UIView {
    public convenience init() {
        self.init(frame: CGRect())
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    open func onInit() {
    }
}

open class JustButton: UIButton {
    public convenience init() {
        self.init(type: .custom)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    open func onInit() {
    }
}
