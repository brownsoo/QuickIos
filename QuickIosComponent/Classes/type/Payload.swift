// 
// Created by brownsoo han on 2018. 5. 29..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

import Foundation

public protocol Payload {}

public protocol ErrorPayload: Payload, Codable {
    var code: Int { get }
    var message: String?  { get }
}

// 배열도 리턴 타입에 포함시키기 위함
extension Array: Payload {}
