//
//  BaseViewController.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 26/12/2018.
//

import Foundation
import RxSwift

open class BaseViewController: UIViewController, LoadingIndicatable, ForegroundNotable {

    lazy public var loadingView = LoadingView()
    public var rxBag = DisposeBag()
    private(set) var indent = [String: Any]()
    private(set) var isFirstLayout = true

    override open func viewDidLoad() {
        super.viewDidLoad()
        foot("viewDidLoad()")
        view.backgroundColor = UIColor.white
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foot("viewWillAppear")
        bindEvents()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        foot("viewWillDisappear")
        unbindEvents()
    }

    public func setIndent(_ key: String, _ value: Any) {
        indent[key] = value
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            firstDidLayout()
        }
    }
    /// once called at first layout time
    open func firstDidLayout() {
    }
    open func didBackground() {
    }
    open func didForeground() {
    }
    /// bind UI events
    /// called in viewWillAppear
    open func bindEvents() {}
    /// unbind UI events
    /// called in viewWillDisappear
    open func unbindEvents() {
        rxBag = DisposeBag()
    }
}


extension BaseViewController: AlertPop {
    public func alertPop(_ title: String?,
                         message: String,
                         positive: String? = nil,
                         positiveCallback: ((_ action: UIAlertAction)->Void)? = nil,
                         alt: String? = nil,
                         altCallback: ((_ action: UIAlertAction) -> Void)? = nil) {

        alertPop(self,
                 title: title,
                 message: message,
                 positive: positive,
                 positiveCallback: positiveCallback,
                 alt: alt,
                 altCallback: altCallback)
    }
}
