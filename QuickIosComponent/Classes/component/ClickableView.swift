//
//  ClickableView.swift
//

import RxSwift

open class ClickableView: JustView {

    private let clickPublish = PublishSubject<Any>()
    public var clicks: Observable<Any> {
        return clickPublish
    }

    public var isClickable: Bool = true
    private var clicked = false
    private var rxBag = DisposeBag()

    open override func onInit() {
        super.onInit()
        addTapGesture()
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

    private func touchEffect() {
        clicked = true
        DispatchQueue.main.async { [weak self] in
            self?.backgroundColor = UIColor.blue.alpha(0.05)
        }
    }

    private func clearTouchEffect() {
        clicked = false
        DispatchQueue.main.async { [weak self] in
            self?.backgroundColor = UIColor.clear
        }
    }
}
