//
//  QuickErrorHelper.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 27/11/2018.
//

import Foundation

public class QuickErrorHelper {
    
    public static func create(_ error: Error?) -> QuickSimpleError {
        switch error {
        case let error as QuickSimpleError:
            return error
        case let error as URLError:
            return NetError(error)
        default:
            return UndefinedError(error)
        }
    }
    /// 인증 오류
    public static func accessTokenError() -> RuntimeError {
        return RuntimeError(.accessTokenRequire, error: nil, message: "접근 토큰 필요.")
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
    
    public static func withErrorPayload(_ payloadBuilder: ()->ErrorPayload) -> DefinedError {
        return DefinedError(payloadBuilder)
    }
    
    /// 타입 변환 오류
    public static func parsingError(_ urlString: String?, error: Error?, with data: Data?) -> RuntimeError {
        
        guard let data = data, let message = String.init(data: data, encoding: .utf8) else {
            return RuntimeError(QuickErrorCode.cannotParsingResponse,
                                error: error,
                                message: "cannot parse response")
        }
        return RuntimeError(QuickErrorCode.cannotParsingResponse,
                            error: error,
                            message: message)
    }
}
