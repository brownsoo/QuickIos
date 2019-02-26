//
//  BaseViewController.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 26/12/2018.
//

import Foundation
import RxSwift

open class BaseViewController: UIViewController,
    LoadingIndicatable, ForegroundNotable, IntentContainer {

    public lazy var loadingView = LoadingView()

    private(set) var isFirstLayout = true

    public private(set) var intent: NSMutableDictionary = NSMutableDictionary()

    override open func viewDidLoad() {
        super.viewDidLoad()
        foot("viewDidLoad()")
        view.backgroundColor = UIColor.white
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foot("viewWillAppear")
        bindUIEvents()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        foot("viewWillDisappear")
        unbindUIEvents()
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
    open func bindUIEvents() {}
    /// unbind UI events
    /// called in viewWillDisappear
    open func unbindUIEvents() {
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
