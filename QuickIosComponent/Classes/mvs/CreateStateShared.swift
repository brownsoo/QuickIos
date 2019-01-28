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
    public static func newStateSharedInstance<SharedState: StateType & Equatable, I: MvsInteractor<SharedState>, T>(
        store: Store<SharedState>?,
        interactor: I?) -> T where T: MvsSharedViewController<SharedState, I> {
        let vc = self.init() as! T
        vc.bind(store: store)
        vc.interactor = interactor
        interactor?.addSharedConsumer(vc.pageConsumer)
        return vc
    }
}
