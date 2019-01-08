//
//  CreateStateShared.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 11. 22..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftConsumer

public extension MvsSharedViewController {
    public static func newStateSharedInstance<State: StateType & Equatable, I: MvsInteractor<State>>(
        store: Store<State>,
        consumer: StateConsumer<State>,
        interactor: I? = nil) -> MvsSharedViewController<State, I> {
        let me = MvsSharedViewController<State, I>()
        me.bind(store: store, consumer: consumer)
        me.interactor = interactor
        return me
    }
}
