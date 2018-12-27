//
//  CreateStateSharedViaStoryboard.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 11. 7..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftConsumer

/// create ViewController via storyboard that contains shared state.
public protocol CreateStateSharedViaStoryboard: CreateViaStoryboard {
    
    associatedtype SharedState: StateType where SharedState: Equatable
    static func newStateSharedInstance(store: Store<SharedState>,
                                       consumer: StateConsumer<SharedState>) -> StateSharedViewController<SharedState>?
}

public extension CreateStateSharedViaStoryboard {
    
    static func newStateSharedInstance(store: Store<SharedState>,
                                       consumer: StateConsumer<SharedState>) -> StateSharedViewController<SharedState>? {
        let vc = newInstance()
        guard let shared = vc as? StateSharedViewController<SharedState> else {
            return nil
        }
        shared.bind(store: store, consumer: consumer)
        return shared
    }
}



