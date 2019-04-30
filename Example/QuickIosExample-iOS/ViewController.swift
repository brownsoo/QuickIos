//
//  ViewController.swift
//  QuickIosExample-iOS
//
//  Created by brownsoo han on 27/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import QuickIosComponent
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let stack = UIStackView()
        view.addSubview(stack)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true

        var lb = UILabel()
        lb.text = "QuickButton"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stack.addArrangedSubview(lb)

        var bt = QuickButton()
        bt.setTitle("Default", for: .normal)
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("Default: disabled", for: .normal)
        bt.isEnabled = false
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("Default: gradient", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.setTitleColor(UIColor.lightGray, for: .highlighted)
        bt.useGradient = true
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("Default: gradient, disabled", for: .normal)
        bt.useGradient = true
        bt.isEnabled = false
        stack.addArrangedSubview(bt)

        lb = UILabel()
        lb.text = "ClickableView"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stack.addArrangedSubview(lb)

        stack.addArrangedSubview(wrapAttached)

    }

    private lazy var lbAttachedName: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        v.textColor = UIColor.black
        v.text = "Label Text"
        v.lineBreakMode = .byTruncatingTail
        v.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        v.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        v.setContentHuggingPriority(.required, for: .vertical)
        v.setContentCompressionResistancePriority(.required, for: .vertical)
        return v
    }()

    private lazy var wrapAttached: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.yellow
        v.clipsToBounds = false
        let boxView = UIView()
        v.addSubview(boxView)
        boxView.backgroundColor = UIColor.white
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.leftAnchor.constraint(equalTo: v.leftAnchor).isActive = true
        boxView.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        boxView.topAnchor.constraint(equalTo: v.topAnchor, constant: 30).isActive = true
        boxView.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        
        boxView.layer.cornerRadius = 8
        boxView.layer.shadowOpacity = 0.4
        boxView.layer.shadowOffset = CGSize(width: 0, height: 2)
        boxView.layer.shadowRadius = 4
        boxView.layer.shadowColor = UIColor.black.cgColor

        let clickView = TouchEffectView()
        v.addSubview(clickView)
        clickView.translatesAutoresizingMaskIntoConstraints = false
        clickView.leftAnchor.constraint(equalTo: boxView.leftAnchor).isActive = true
        clickView.rightAnchor.constraint(equalTo: boxView.rightAnchor).isActive = true
        clickView.topAnchor.constraint(equalTo: boxView.topAnchor).isActive = true
        clickView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor).isActive = true
        clickView.layer.masksToBounds = true
        clickView.layer.cornerRadius = 8

        clickView.addSubview(lbAttachedName)
        lbAttachedName.translatesAutoresizingMaskIntoConstraints = false
        lbAttachedName.leftAnchor.constraint(equalTo: clickView.leftAnchor, constant: 16).isActive = true
        lbAttachedName.topAnchor.constraint(equalTo: clickView.topAnchor, constant: 8).isActive = true
        lbAttachedName.bottomAnchor.constraint(equalTo: clickView.bottomAnchor, constant: -8).isActive = true
        lbAttachedName.trailingAnchor.constraint(lessThanOrEqualTo: clickView.trailingAnchor, constant: -8).isActive = true

        return v
    }()


}


open class TouchEffectView: JustView {

    private let clickPublish = PublishSubject<Any>()
    public var clicks: Observable<Any> {
        return clickPublish
    }

    public var isClickable: Bool = true
    public var isTouchEffect: Bool = true
    private var clicked = false
    private var rxBag = DisposeBag()

    public lazy var effectLayer: CAShapeLayer = {
        let effect = CAShapeLayer()
        effect.fillColor = nil
        return effect
    }()

    public var highlightColor: UIColor = UIColor.blue.withAlphaComponent(0.05) {
        didSet {
            effectLayer.fillColor = self.highlightColor.cgColor
        }
    }

    open override func onInit() {
        super.onInit()
        addTapGesture()
        layer.insertSublayer(effectLayer, at: 0)
    }

    private func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.delaysTouchesEnded = false
        tap.delaysTouchesBegan = false
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        if isClickable {
            if !clicked {
                touchEffect()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.clearTouchEffect()
                    self.dispatchClick()
                }
            } else {
                dispatchClick()
            }
        }
    }

    private func dispatchClick() {
        self.clickPublish.onNext(true)
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isClickable {
            touchEffect()
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isClickable && clicked {
            clearTouchEffect()
        }
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if isClickable && clicked {
            if let touch = touches.first {
                let currentPoint = touch.location(in: self)
                if !bounds.contains(currentPoint) {
                    clearTouchEffect()
                }
            }
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isClickable && clicked {
            clearTouchEffect()
        }
    }

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        effectLayer.frame = self.bounds
        effectLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0).cgPath

    }

    private func touchEffect() {
        clicked = true
        if isTouchEffect {
            let color = self.highlightColor.cgColor
            DispatchQueue.main.async { [weak self] in
                self?.effectLayer.fillColor = color
            }
        }
    }

    private func clearTouchEffect() {
        clicked = false
        if isTouchEffect {
            DispatchQueue.main.async { [weak self] in
                self?.effectLayer.fillColor = nil
            }
        }
    }
}

