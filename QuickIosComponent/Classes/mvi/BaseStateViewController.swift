//
//  BaseStateViewController.swift
//  StudioUser
//
//  Created by brownsoo han on 2017. 10. 18..
//  Copyright © 2017년 TLX. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import ReSwiftConsumer
import RxSwift

open class BaseStateViewController<V, S, I: BaseInteractor<V, S>>
    : StateViewController<S>,
    LoadingIndicatable,
    ForegroundNotable {

    public let loadingView = LoadingView()
    internal var bag = DisposeBag()
    private(set) var indent = [String: Any]()
    private(set) var isFirstLayout = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        onInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    
    func setIndent(key: String, value: Any) {
        indent[key] = value
    }
    
    func createInteractor() -> I? { return nil }
    
    func onInit() {
        pageInteractor = createInteractor()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foot("viewWillAppear")
        (pageInteractor as? ViewAttach)?.attachView(view: self as! V)
        bindEvents()
        bindConsumers()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        foot("viewWillDisappear")
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
    func firstDidLayout() {
        foot("firstDidLayout")
    }
    
    func didBackground() {
    }
    
    func didForeground() {
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

extension BaseStateViewController: AlertPop {
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

