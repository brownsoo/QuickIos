//
//  BaseStateNavigationController.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 12. 23..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import ReSwift
import ReSwiftConsumer

open class BaseStateNavigationController<V, S, I: BaseInteractor<V, S>>: StateNavigationController<S>, ForegroundNotable {

    private(set) public var isFirstLayout = true
    public var rxBag = DisposeBag()

    open func createInteractor() -> I? { return nil }

    open override func viewDidLoad() {
        super.viewDidLoad()
        pageInteractor = createInteractor()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (pageInteractor as? ViewAttach)?.attachView(view: self as! V)
        bindEvents()
        bindConsumers()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (pageInteractor as? ViewAttach)?.detachView()
        unbindEvents()
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

    open func showLoading() {
        guard let child = children.last else {
            return
        }
        (child as? LoadingIndicatable)?.showLoading(child.view)
    }
    
    open func hideLoading() {
        if let child = children.last as? LoadingIndicatable {
            child.hideLoading()
        }
    }
    
    open func didForeground() {
    }
    
    open func didBackground() {
    }
    /// bind UI events
    /// called in viewWillAppear
    open func bindEvents() {}
    /// unbind UI events
    /// called in viewWillDisappear
    open func unbindEvents() {
        rxBag = DisposeBag()
    }
    /// bind Consumers
    /// called in viewWillAppear
    open func bindConsumers() {}
}

extension BaseStateNavigationController: AlertPop {
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

