// 
// Created by brownsoo han on 2018. 5. 29..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

import Foundation

public protocol QuickError: Error, Equatable {
    var type: QuickErrorType { get }
    var code: Int { get }
    var cause: Error? { get }
    var message: String? { get }
    var utc: TimeInterval { get }
}

public enum QuickErrorType: Int {
    case server = 1
    case net = 3
    case runtime = 5
    case undefined = 9
}

public enum QuickErrorCode: Int {
    // server error related with status code
    case noData = 1000, invalidClient, invalidCredential, notFound,
    unauthorized, failedRefreshToken, unprocessableEntity,
    tooManyRequests, conflict, badRequest, serverError, notModified,
    forbidden, notAcceptable, gone, enhanceYourCalm, internalServerError,
    badGateway, serviceUnavailable, gatewayTimeout
    // net
    case connectionTimeout = 2000, connectionFailed,
    noNetwork, cancelled, instant
    // runtime
    case cannotParsingResponse = 5000, invalidDecoder, ignore, accessTokenRequire
    // undefined
    case undefined = 9999
    
    public init(code: Int) {
        self = QuickErrorCode(rawValue: code) ?? .undefined
    }
}


// MARK: Implementation

open class QuickSimpleError: QuickError {
    public var type: QuickErrorType {
        return QuickErrorType.undefined
    }

    public var code: Int {
        return QuickErrorCode.undefined.rawValue
    }

    public var cause: Error? {
        return nil
    }

    public var message: String? {
        return nil
    }

    public var utc: TimeInterval {
        return 0
    }

    public static func ==(lhs: QuickSimpleError, rhs: QuickSimpleError) -> Bool {
        return lhs.utc == rhs.utc
            && lhs.code == rhs.code
    }
    
    public var localizedDescription: String {
        let msg = message?.replacingOccurrences(of: "\\", with: "", options:
            NSString.CompareOptions.literal, range: nil) ?? ""
        return """
        type: \(type)
        code: \(QuickErrorCode(code: code)) [\(code)]
        cause: \(String(describing: cause))
        message: \(msg)
        """
    }
}

public class UndefinedError: QuickSimpleError {
    override public var cause: Error? {
        return _cause
    }
    override public var message: String? {
        return _cause?.localizedDescription
    }
    override public var utc: TimeInterval {
        return _utc
    }
    
    private let _cause: Error?
    private let _utc: TimeInterval
    
    init(_ cause: Error?) {
        self._cause = cause
        _utc = Date().timeIntervalSince1970
    }
}

public class NoDataError: QuickSimpleError {
    override public var type: QuickErrorType {
        return QuickErrorType.server
    }
    override public var code: Int {
        return QuickErrorCode.noData.rawValue
    }
    override public var message: String? {
        return "No data with No Error : \(url ?? "")"
    }
    override public var utc: TimeInterval {
        return _utc
    }

    private var url: String?
    private let _utc: Double

    init(_ url: String?) {
        self.url = url
        _utc = Date().timeIntervalSince1970
    }
}

open class DefinedError: QuickSimpleError {
    override public var type: QuickErrorType {
        return QuickErrorType.server
    }
    override public var code: Int {
        return payload.code
    }
    override public var cause: Error? {
        return nil
    }
    override public var message: String? {
        return payload.message
    }
    override public var utc: TimeInterval {
        return _utc
    }

    private var payload: ErrorPayload
    private let _utc: TimeInterval

    init(_ payloadBuilder: ()->ErrorPayload) {
        self.payload = payloadBuilder()
        _utc = Date().timeIntervalSince1970
    }
}

public class RuntimeError: QuickSimpleError {
    override public var type: QuickErrorType {
        return QuickErrorType.runtime
    }
    override public var code: Int {
        return _code.rawValue
    }
    override public var cause: Error? {
        return _cause
    }
    override public var message: String? {
        return _message
    }
    override public var utc: TimeInterval {
        return _utc
    }

    private var _cause: Error?
    private let _code: QuickErrorCode
    private var _message: String?
    private let _utc: Double

    init(_ code: QuickErrorCode, error: Error?, message: String?) {
        _code = code
        _cause = error
        _message = message
        _utc = Date().timeIntervalSince1970
    }

    convenience init(_ code: QuickErrorCode, error: Error?) {
        self.init(code, error: error, message: error?.localizedDescription)
    }
}

public class NetError: QuickSimpleError {

    override public var type: QuickErrorType {
        return _type
    }
    override public var code: Int {
        return _code.rawValue
    }
    override public var cause: Error? {
        return _cause
    }
    override public var message: String? {
        return _message
    }
    override public var utc: TimeInterval {
        return _utc
    }

    public var urlError: URLError {
        return _cause!
    }
    
    public private(set) var statusCode: Int = -1

    private let _cause: URLError?
    private let _code: QuickErrorCode
    private let _message: String?
    private let _utc: TimeInterval
    private var _type: QuickErrorType

    init(_ cause: URLError?, code: QuickErrorCode, message: String, utc: TimeInterval) {
        self._type = .net
        self._cause = cause
        self._code = code
        self._message = message
        self._utc = utc
    }

    convenience init(_ code: QuickErrorCode, message: String) {
        self.init(nil, code: code, message: message, utc: Date().timeIntervalSince1970)
    }

    convenience init(_ cause: URLError, message: String) {
        self.init(cause, code: NetError.convertCode(cause), message: message, utc: Date().timeIntervalSince1970)
    }

    convenience init(_ cause: URLError) {
        self.init(cause, message: cause.localizedDescription)
    }

    convenience init(_ response: HTTPURLResponse, data: Data?) {
        var code: QuickErrorCode
        switch response.statusCode {
        case 304:
            code = .notModified
        case 400:
            code = .badRequest
        case 401:
            code = .unauthorized
        case 403:
            code = .forbidden
        case 404:
            code = .notFound
        case 406:
            code = .notAcceptable
        case 409:
            code = .conflict
        case 410:
            code = .gone
        case 420:
            code = .enhanceYourCalm
        case 422:
            code = .unprocessableEntity
        case 429:
            code = .tooManyRequests
        case 500:
            code = .internalServerError
        case 502:
            code = .badGateway
        case 503:
            code = .serviceUnavailable
        case 504:
            code = .gatewayTimeout
        default:
            code = .serverError
        }
        
        var msg: String
        if data == nil {
            msg = ""
        } else {
            msg = String.init(data: data!, encoding: .utf8) ?? ""
        }
        self.init(nil, code: code, message: msg, utc: Date().timeIntervalSince1970)
        if response.statusCode >= 500 {
            self._type = .server
        }
        self.statusCode = response.statusCode
    }

    static private func convertCode(_ urlError: URLError) -> QuickErrorCode {
        switch urlError.code {
        case URLError.Code.cannotConnectToHost,
             URLError.Code.secureConnectionFailed,
             URLError.Code.badURL:
            return QuickErrorCode.connectionFailed

        case URLError.Code.timedOut:
            return QuickErrorCode.connectionTimeout

        case URLError.Code.notConnectedToInternet:
            return QuickErrorCode.noNetwork

        case URLError.cancelled:
            return QuickErrorCode.cancelled

        default:
            return QuickErrorCode.undefined
        }
    }
}
