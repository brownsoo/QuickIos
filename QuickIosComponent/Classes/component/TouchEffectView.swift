//
//  TouchEffectView.swift
//

import RxSwift

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
