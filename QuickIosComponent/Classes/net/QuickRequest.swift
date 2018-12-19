//
//  QuickRequest.swift
//
//  Created by brownsoo han on 26/11/2018.
//

import Foundation

public protocol Request: Cancelable {
    associatedtype ResultType
    
    var isCalled: Bool { get }
    var isCancelled: Bool { get }
    var isCompleted: Bool { get }
    var urlString: String { get }
    var token: String? { get }
    
    func call(resultHandler: @escaping (RequestResult<ResultType>) -> Void)
}

public struct NullDataError: Error {
    let response: URLResponse?
    init(_ response: URLResponse?) {
        self.response = response
    }
}


/// Request 일부 구현한 Abstract 클래스
/// 실제 요청을 수행하지 않음
open class BaseRequest<T> : Request {
    
    public typealias ResultType = T
    public typealias RequestBeforeAction = () -> Void
    public typealias RequestSuccessAction = (_ result: T) -> Void
    public typealias RequestFailAction = (_ error: Error) -> Void
    public typealias RequestCompletion = (_ result: T?, _ response: URLResponse?, _ error: Error?) -> Void
    
    open var isCalled: Bool { return called }
    open var isCancelled: Bool { return cancelled }
    open var isCompleted: Bool { return completed }
    public private(set) var urlString: String
    public private(set) var token: String? = nil
    public private(set) var isTokenRequired: Bool = false
    public lazy var headers = [String : String]()
    
    open var cancelled = false
    open var called = false
    open var completed = false
    
    private var beforeActions = [RequestBeforeAction]()
    private var successActions = [RequestSuccessAction]()
    private var failActions = [RequestFailAction]()
    
    public init(_ urlString: String) {
        self.urlString = urlString
    }
    
    @discardableResult
    open func setTokenRequired() -> BaseRequest<T> {
        self.isTokenRequired = true
        return self
    }
    
    @discardableResult
    open func addHeader(_ key: String, _ value: String) -> BaseRequest<T> {
        headers[key] = value
        return self
    }
    
    /// 요청을 실행하기 전에 수행할 것을 등록한다.
    @discardableResult
    open func addBeforeAction(_ action: @escaping RequestBeforeAction) -> BaseRequest<T> {
        beforeActions.append(action)
        return self
    }
    /// 요청이 성공했을 때 실행할 것을 등록한다.
    @discardableResult
    open func addSuccessAction(_ action: @escaping RequestSuccessAction) -> BaseRequest<T> {
        successActions.append(action)
        return self
    }
    /// 요청이 실패했을 때 실행할 것을 등록한다.
    @discardableResult
    open func addFailAction(_ action: @escaping RequestFailAction) -> BaseRequest<T> {
        failActions.append(action)
        return self
    }
    
    private func notifyBeforeAction() {
        for action in beforeActions {
            action()
        }
    }
    
    private func notifySuccessAction(_ result: T) {
        for action in successActions {
            action(result)
        }
    }
    
    private func notifyFailAction(_ error: Error) {
        for action in failActions {
            action(error)
        }
    }
    /// 요청을 실행한다.
    public func call(resultHandler: @escaping (RequestResult<T>) -> Void) {
        called = true
        DispatchQueue.main.async {
            self.notifyBeforeAction()
        }
        defer {
            completed = true
        }
        
        executeCall { [weak self] data, response, error in
            self?.completed = true
            // print("===== executeCalled \(self?.urlString)")
            DispatchQueue.main.async {
                // notify action handlers
                if let error = error {
                    self?.notifyFailAction(error)
                } else if data == nil {
                    self?.notifyFailAction(NullDataError(response))
                } else {
                    self?.notifySuccessAction(data!)
                }
                
                resultHandler(RequestResult<T> {
                    if let error = error { throw error }
                    guard let data = data else { throw NullDataError(response) }
                    return data
                })
            }
        }
    }
    /// BaseRequest 를 구현한 레이어를 실행한다.
    open func executeCall(_ completion: @escaping RequestCompletion) {
        preconditionFailure("구현해야 하는 부분")
    }
    
    open func cancel() {
        cancelled = true
    }
}


