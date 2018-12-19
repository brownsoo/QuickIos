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

class BaseStateNavigationController<V, S, I: BaseInteractor<V, S>>: StateNavigationController<S>, ForegroundNotable {

    private(set) public var isFirstLayout = true
    var bag = DisposeBag()

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        onInit()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        onInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    
    func createInteractor() -> I? { return nil }
    
    func onInit() {
        pageInteractor = createInteractor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (pageInteractor as? ViewAttach)?.attachView(view: self as! V)
        bindEvents()
        bindConsumers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (pageInteractor as? ViewAttach)?.detachView()
        unbindEvents()
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

    func showLoading() {
        guard let child = children.last else {
            return
        }
        (child as? LoadingIndicatable)?.showLoading(child.view)
    }
    
    func hideLoading() {
        if let child = children.last as? LoadingIndicatable {
            child.hideLoading()
        }
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

