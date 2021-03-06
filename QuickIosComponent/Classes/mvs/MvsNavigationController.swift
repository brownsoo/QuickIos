//
//  MvsNavigationController.swift
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

open class MvsNavigationController<S, I: RePageInteractor<S>>: StateNavigationController<S>,
    IntentContainer {

    private(set) var isFirstLayout = true

    public var rxBag = DisposeBag()

    public private(set) var intent: NSMutableDictionary = NSMutableDictionary()

    open func createInteractor() -> I? { return nil }

    convenience required public init() {
        self.init(nibName: nil, bundle: nil)
    }

    open override func viewDidLoad() {
        // Before subscription, makes instance of RePageInteractor
        pageInteractor = createInteractor()
        // At this time, it makes subscription with initial state and middle wares
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindUIEvents()
        bindConsumers()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (pageInteractor as? ViewAttach)?.detachView()
        unbindUIEvents()
        unbindConsumers()
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
        (child as? LoadingVisible)?.showLoading(child.view)
    }
    
    open func hideLoading() {
        if let child = children.last as? LoadingVisible {
            child.hideLoading()
        }
    }

    /// bind UI events
    /// called in viewWillAppear
    open func bindUIEvents() {}
    /// unbind UI events
    /// called in viewWillDisappear
    open func unbindUIEvents() {
        rxBag = DisposeBag()
    }
    /// bind Consumers
    /// called in viewWillAppear
    open func bindConsumers() {}
    
    /// bind Consumers
    /// called in viewWillDisappear
    open func unbindConsumers() {
    }
}

extension MvsNavigationController: AlertPop {
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

