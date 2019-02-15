//
//  MvsViewController.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 10. 18..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import ReSwiftConsumer
import RxSwift

open class MvsViewController<S, I: MvsInteractor<S>>
    : StateViewController<S>,
    LoadingIndicatable {

    public lazy var loadingView = LoadingView()

    public var rxBag = DisposeBag()

    private(set) var indent = [String: Any]()

    private(set) var isFirstLayout = true
    
    func setIndent(key: String, value: Any) {
        indent[key] = value
    }

    open func createInteractor() -> I? { return nil }

    convenience required public init() {
        self.init(nibName: nil, bundle: nil)
        pageInteractor = createInteractor()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foot("viewWillAppear")
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
    open func firstDidLayout() {
        foot("firstDidLayout")
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

extension MvsViewController: AlertPop {
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

