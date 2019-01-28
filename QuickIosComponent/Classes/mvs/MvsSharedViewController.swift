//
//  MvsSharedViewController.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 12. 23..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//
import Foundation
import ReSwift
import ReSwiftConsumer
import RxSwift
import UIKit

open class MvsSharedViewController<SharedState: StateType & Equatable, I: MvsInteractor<SharedState>>
    : StateSharedViewController<SharedState>,
    LoadingIndicatable {

    private(set) var isFirstLayout = true
    lazy public var loadingView = LoadingView()
    public var rxBag = DisposeBag()
    public var indent = [String: Any]()
    public var interactor: I? = nil

    @discardableResult
    public func setIndent(_ key: String, _ value: Any) -> Self {
        indent[key] = value
        return self
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        foot("viewDidLoad()")
        view.backgroundColor = UIColor.white
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foot("viewWillAppear(\(animated))")
        bindEvents()
        bindConsumers()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        foot("viewWillDisappear(\(animated))")
        unbindEvents()
    }

    override open func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
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

extension MvsSharedViewController: AlertPop {
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
