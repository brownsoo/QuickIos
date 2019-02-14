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

    public lazy var loadingView = LoadingView()

    public var rxBag = DisposeBag()

    public var indent = [String: Any]()

    public var shardInteractor: I? = nil

    public let pageConsumer = StateConsumer<SharedState>()

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
        shardInteractor?.addSharedConsumer(pageConsumer)
        bindEvents()
        bindConsumers()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        foot("viewWillDisappear(\(animated))")
        unbindEvents()
        pageConsumer.removeAll()
        shardInteractor?.removeSharedConsumer(pageConsumer)
        super.viewWillDisappear(animated)
    }

    deinit {
        shardInteractor = nil
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

    /// called in viewWillAppear
    open func bindConsumers() {
        if pageConsumer.consumeInstantly, let ps = sharedStore?.state {
            print("오호호호호호호호호 ")
            shardInteractor?.newPageState(state: ps)
        }
    }
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
