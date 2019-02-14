//
//  MvsInteractor.swift
//  Model + View + State
//
//  Created by brownsoo han on 2017. 12. 23..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftConsumer

open class MvsInteractor<PS: StateType & Equatable>: RePageInteractor<PS>,
    Footable {

    private let pageLogging: Middleware<PS> = { dispatch, getState in
        return { next in
            return { action in
                next(action)
                #if DEBUG
                print("P𝍌 \(action)")
                #endif
            }
        }
    }
    
    open override func getPageMiddleWares() -> [Middleware<PS>] {
        return [pageLogging]
    }
}
