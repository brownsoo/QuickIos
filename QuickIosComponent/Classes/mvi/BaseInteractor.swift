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

open class BaseInteractor<V, PS: StateType & Equatable>: RePageInteractor<PS>,
    ForegroundNotable,
    ViewAttach,
    Footable {
    
    private(set) public var view: V?
    
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
    
    open func attachView(view: Any) {
        self.view = view as? V
        foot("attachView(\(view)")
    }
    
    open func detachView() {
        view = nil
        foot("detachView()")
    }
    open func didForeground() {
        foot("didForeground")
        if let v = view as? ForegroundNotable {
            v.didForeground()
        }
    }
    
    open func didBackground() {
        foot("didBackground")
        if let v = view as? ForegroundNotable {
            v.didBackground()
        }
    }
}
