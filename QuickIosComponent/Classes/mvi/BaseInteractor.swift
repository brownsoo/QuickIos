//
//  BaseInteractor.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 12. 23..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftConsumer
import RxSwift

open class BaseInteractor<V, PS: StateType & Equatable>: RePageInteractor<PS>,
    ForegroundNotable,
    ViewAttach,
    Footable {
    
    private var view: V?
    let bag = DisposeBag()
    
    private let pageLogging: Middleware<PS> = { dispatch, getState in
        return { next in
            return { action in
                #if DEBUG
                print("P𝍌 \(action)")
                #endif
                next(action)
            }
        }
    }
    
    override open func getPageMiddleWares() -> [Middleware<PS>] {
        return [pageLogging]
    }
    
    func attachView(view: Any) {
        self.view = view as? V
        foot("attachView(\(view)")
    }
    
    func detachView() {
        view = nil
        foot("detachView()")
    }
    func didForeground() {
        foot("didForeground")
        if let v = view as? ForegroundNotable {
            v.didForeground()
        }
    }
    
    func didBackground() {
        foot("didBackground")
        if let v = view as? ForegroundNotable {
            v.didBackground()
        }
    }
    
    private func foregroundChanged(prev: Bool?, curr: Bool) {
        if curr {
            didForeground()
        } else {
            didBackground()
        }
    }
    
}
