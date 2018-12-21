// 
// Created by brownsoo han on 2018. 3. 26..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

import UIKit

public final class BlueOutlineButton: UIButton, Also {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }

    convenience public init(_ blue: UIColor? = nil) {
        self.init(type: .custom)
        if blue != nil {
            self.blue = blue!
        }
        onInit()
    }
    
    public var shadowing: Bool = true {
        didSet {
            shadowLayer.isHidden = !shadowing
        }
    }

    private lazy var shadowLayer: CAShapeLayer = {
        let shadow = CAShapeLayer()
        shadow.path = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
        shadow.fillColor = UIColor.white.cgColor
        shadow.shadowColor = UIColor.color255(74, 144, 226).cgColor
        shadow.shadowPath = UIBezierPath(
            roundedRect: CGRect(x: 9, y: 18, width: bounds.width - 18, height: bounds.height - 24),
            cornerRadius: 6)
            .cgPath
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowOpacity = 0.4
        shadow.shadowRadius = 8
        return shadow
    }()
    
    private var blue: UIColor = UIColor.color255(74, 144, 226)

    private func onInit() {
        setBackgroundImage(UIImage().solid(UIColor.white), for: .normal)
        setBackgroundImage(UIImage().solid(blue.alpha(0.2)), for: .highlighted )
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 30, bottom: 12, right: 30)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        setTitleColor(blue, for: .normal)
        layer.insertSublayer(shadowLayer, at: 0)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if shadowing {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
            shadowLayer.shadowPath = UIBezierPath(
                roundedRect: CGRect(x: 9, y: 18, width: bounds.width - 18, height: bounds.height - 20),
                cornerRadius: 6)
                .cgPath
        }
        
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = blue.withAlphaComponent(0.58).cgColor
    }
}
