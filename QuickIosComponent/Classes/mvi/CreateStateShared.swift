//
//  CreateStateShared.swift
//  StudioUser
//
//  Created by brownsoo han on 2017. 11. 22..
//  Copyright © 2017년 TLX. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftConsumer

extension BaseStateSharedViewController {
    static func newStateSharedInstance<State: StateType & Equatable>(
        store: Store<State>,
        consumer: StateConsumer<State>) -> BaseStateSharedViewController<State> {
        let me = self.init() as! BaseStateSharedViewController<State>
        me.bind(store: store, consumer: consumer)
        return me
    }
}