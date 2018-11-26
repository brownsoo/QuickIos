// 
// Created by brownsoo han on 2018. 5. 29..
// Copyright (c) 2018 StudioMate. All rights reserved.
//

import Foundation

public protocol StudioError: Error, Equatable {
    var type: StudioErrorType { get }
    var code: Int { get }
    var cause: Error? { get }
    var message: String? { get }
    var utc: TimeInterval { get }
}

public enum StudioErrorType: Int {
    case server = 1
    case net = 3
    case runtime = 5
    case undefined = 9
}

public enum StudioErrorCode: Int {
    // server error related with status code
    case noData = 1000, invalidClient, invalidCredential, notFound,
    unauthorized, failedRefreshToken, unprocessableEntity,
    tooManyRequests, conflict, badRequest, serverError
    // server defined
    case serverDefinedError = 2000
    // net
    case connectionTimeout = 3000, connectionFailed,
    noNetwork, cancelled, instant
    // runtime
    case cannotParsingResponse = 5000, invalidDecoder, ignore
    // undefined
    case undefined = 9999
    
    public init(code: Int) {
        if code > 9999 {
            self = StudioErrorCode.serverDefinedError
        } else {
            self = StudioErrorCode(rawValue: code) ?? .undefined
        }
    }
}

// MARK: Helper

public class StudioErrorUtil {

    public static func create(_ error: Error?) -> StudioErrorBase {
        switch error {
        case let error as StudioErrorBase:
            return error
        case let error as URLError:
            return NetError(error)
        default:
            return UndefinedError(error)
        }
    }
    /// 일시적인 오류
    public static func instantError() -> NetError {
        return NetError(.instant, message: "다시 시도 해보기 바랍니다.")
    }
    /// 무시해도 되는 오류
    public static func ignoreError() -> RuntimeError {
        return RuntimeError(.ignore, error: nil)
    }

    /// httpStatus 코드로 오류 파싱
    public static func httpResponseError(_ httpResponse: HTTPURLResponse, data: Data?) -> NetError {
        return NetError(httpResponse, data: data)
    }

    /// RefreshToken Expired
    public static func failedRefreshToken() -> NetError {
        return NetError(.failedRefreshToken, message: "토큰 만료")
    }

    /// 데이터가 없음
    public static func noData(_ url: String?) -> NoDataError {
        return NoDataError(url)
    }

    public static func undefined(_ cause: Error?) -> UndefinedError {
        return UndefinedError(cause)
    }

    public static func withErrorPayload(_ payload: ErrorPayload) -> StumeError {
        return StumeError(payload)
    }

    /// 타입 변환 오류
    public static func parsingError(_ urlString: String?, error: Error?, with data: Data?) -> RuntimeError {

        guard let data = data, let message = String.init(data: data, encoding: .utf8) else {
            return RuntimeError(StudioErrorCode.cannotParsingResponse,
                error: error,
                message: "cannot parse response")
        }
        return RuntimeError(StudioErrorCode.cannotParsingResponse,
            error: error,
            message: message)
    }
}


// MARK: Implementation

open class StudioErrorBase: StudioError {
    public var type: StudioErrorType {
        return StudioErrorType.undefined
    }

    public var code: Int {
        return StudioErrorCode.undefined.rawValue
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

    public static func ==(lhs: StudioErrorBase, rhs: StudioErrorBase) -> Bool {
        return lhs.utc == rhs.utc
            && lhs.code == rhs.code
    }
    
    public var localizedDescription: String {
        let msg = message?.replacingOccurrences(of: "\\", with: "", options:
            NSString.CompareOptions.literal, range: nil) ?? ""
        return """
        type: \(type)
        code: \(StudioErrorCode(code: code)) [\(code)]
        cause: \(String(describing: cause))
        message: \(msg)
        """
    }
}

public class UndefinedError: StudioErrorBase {
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

public class NoDataError: StudioErrorBase {
    override public var type: StudioErrorType {
        return StudioErrorType.server
    }
    override public var code: Int {
        return StudioErrorCode.noData.rawValue
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

open class StumeError: StudioErrorBase {
    override public var type: StudioErrorType {
        return StudioErrorType.server
    }
    override public var code: Int {
        return payload.error
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

    init(_ payload: ErrorPayload) {
        self.payload = payload
        _utc = Date().timeIntervalSince1970
    }
}

public class RuntimeError: StudioErrorBase {
    override public var type: StudioErrorType {
        return StudioErrorType.runtime
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
    private let _code: StudioErrorCode
    private var _message: String?
    private let _utc: Double

    init(_ code: StudioErrorCode, error: Error?, message: String?) {
        _code = code
        _cause = error
        _message = message
        _utc = Date().timeIntervalSince1970
    }

    convenience init(_ code: StudioErrorCode, error: Error?) {
        self.init(code, error: error, message: error?.localizedDescription)
    }
}

public class NetError: StudioErrorBase {

    override public var type: StudioErrorType {
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
    private let _code: StudioErrorCode
    private let _message: String?
    private let _utc: TimeInterval
    private var _type: StudioErrorType

    init(_ cause: URLError?, code: StudioErrorCode, message: String, utc: TimeInterval) {
        self._type = .net
        self._cause = cause
        self._code = code
        self._message = message
        self._utc = utc
    }

    convenience init(_ code: StudioErrorCode, message: String) {
        self.init(nil, code: code, message: message, utc: Date().timeIntervalSince1970)
    }

    convenience init(_ cause: URLError, message: String) {
        self.init(cause, code: NetError.convertCode(cause), message: message, utc: Date().timeIntervalSince1970)
    }

    convenience init(_ cause: URLError) {
        self.init(cause, message: cause.localizedDescription)
    }

    convenience init(_ response: HTTPURLResponse, data: Data?) {
        var code: StudioErrorCode
        switch response.statusCode {
        case 400:
            code = StudioErrorCode.badRequest
        case 401:
            code = StudioErrorCode.unauthorized
        case 404:
            code = StudioErrorCode.notFound
        case 409:
            code = StudioErrorCode.conflict
        case 422:
            code = StudioErrorCode.unprocessableEntity // validation 실패 또는 유효하지 않은 이메일
        case 429:
            code = StudioErrorCode.tooManyRequests
        default:
            code = StudioErrorCode.serverError
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

    static private func convertCode(_ urlError: URLError) -> StudioErrorCode {
        switch urlError.code {
        case URLError.Code.cannotConnectToHost,
             URLError.Code.secureConnectionFailed,
             URLError.Code.badURL:
            return StudioErrorCode.connectionFailed

        case URLError.Code.timedOut:
            return StudioErrorCode.connectionTimeout

        case URLError.Code.notConnectedToInternet:
            return StudioErrorCode.noNetwork

        case URLError.cancelled:
            return StudioErrorCode.cancelled

        default:
            return StudioErrorCode.undefined
        }
    }
}
