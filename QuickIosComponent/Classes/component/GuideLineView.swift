//
// Created by brownsoo han on 2018. 4. 9..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

import Foundation
import UIKit

public class GuideLineView: UIView, UIGestureRecognizerDelegate {

    private var touchDownPoint: CGPoint? = nil
    private let density: CGFloat = UIScreen.main.scale

    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }

    private func onInit() {
        backgroundColor = UIColor.clear
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let w = UIApplication.shared.keyWindow {
            let pan = UIPanGestureRecognizer()
            pan.addTarget(self, action: #selector(handlePan))
            pan.delegate = self

            w.addGestureRecognizer(pan)
        }
    }

    @objc
    private func handlePan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            touchDownPoint = pan.location(in: self)
        case .changed:
            touchDownPoint = pan.location(in: self)
        default:
            touchDownPoint = nil
        }
        setNeedsDisplay()
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if let p = touchDownPoint, let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(1 / density)
            context.move(to: CGPoint(x: p.x, y: 0))
            context.addLine(to: CGPoint(x: p.x, y: rect.height))
            context.move(to: CGPoint(x: 0, y: p.y))
            context.addLine(to: CGPoint(x: rect.width, y: p.y))
            context.strokePath()
        }
    }
}