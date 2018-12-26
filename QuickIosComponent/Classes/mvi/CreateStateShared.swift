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

public extension MviStateSharedViewController {
    public static func newStateSharedInstance<State: StateType & Equatable>(
        store: Store<State>,
        consumer: StateConsumer<State>) -> MviStateSharedViewController<State> {
        let me = self.init() as! MviStateSharedViewController<State>
        me.bind(store: store, consumer: consumer)
        return me
    }
}
