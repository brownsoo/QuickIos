//
//  BaseStateSharedViewController.swift
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

class BaseStateSharedViewController<SharedState: StateType & Equatable>
    : StateSharedViewController<SharedState>,
    LoadingIndicatable,
    ForegroundNotable {

    private(set) var isFirstLayout = true
    lazy var loadingView = LoadingView()
    var bag = DisposeBag()
    var indent = [String: Any]()

    @discardableResult
    func setIndent(_ key: String, _ value: Any) -> Self {
        indent[key] = value
        return self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        foot("viewDidLoad()")
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foot("viewWillAppear(\(animated))")
        bindEvents()
        bindConsumers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        foot("viewWillDisappear(\(animated))")
        unbindEvents()
        consumerBag?.removeAll()
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            firstDidLayout()
        }
    }
    /// once called at first layout time
    func firstDidLayout() {
    }
    
    func didForeground() {
    }
    func didBackground() {
    }
    /// bind UI events
    /// called in viewWillAppear
    func bindEvents() {}
    /// unbind UI events
    /// called in viewWillDisappear
    func unbindEvents() {
        bag = DisposeBag()
    }
    /// bind Consumers
    /// called in viewWillAppear
    func bindConsumers() {}
}

extension BaseStateSharedViewController: AlertPop {
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
