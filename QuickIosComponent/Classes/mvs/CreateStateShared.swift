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

extension MvsSharedViewController {
    public static func newStateSharedInstance<SharedState: StateType & Equatable, I: MvsInteractor<SharedState>>(
        store: Store<SharedState>?,
        interactor: I?) -> MvsSharedViewController<SharedState, I> {
        let vc = self.init() as! MvsSharedViewController<SharedState, I>
        vc.bind(store: store)
        vc.shardInteractor = interactor
        interactor?.addSharedConsumer(vc.pageConsumer)
        return vc
    }
}
