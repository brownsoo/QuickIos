// 
// Created by brownsoo han on 2018. 5. 29..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

import Foundation

public protocol Payload {}

public protocol ErrorPayload: Payload, Codable {
    var error: Int { get }
    var message: String?  { get }
}
