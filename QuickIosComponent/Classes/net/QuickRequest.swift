//
//  QuickRequest.swift
//
//  Created by brownsoo han on 26/11/2018.
//

import Foundation

public protocol RequestStatusNotable {
    var isCalled: Bool { get }
    var isCancelled: Bool { get }
    var isCompleted: Bool { get }
}

public protocol QuickRequest: Cancelable, RequestStatusNotable {

    //associatedtype ResultType
    //associatedtype QuickRequestSubclass

    var urlString: String { get }
    var token: String? { get }
    @discardableResult
    func addHeader(_ key: String, _ value: String) -> Self
    @discardableResult
    func setTokenRequired() -> Self
    //func call(resultHandler: @escaping (RequestResult<ResultType>) -> Void)
}

public struct NullDataError: Error {
    let response: URLResponse?
    init(_ response: URLResponse?) {
        self.response = response
    }
}

open class QuickRequestCenter {

    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        return queue
    }()

    public static let `default` = QuickRequestCenter()

    open func add(_ request: Operation) {
        queue.addOperation(request)
    }

    open func cancelAll() {
        queue.cancelAllOperations()
    }
}


/// Request 일부 구현한 Abstract 클래스
/// 실제 요청을 수행하지 않음
open class QuickRequestBase<T> : Operation, QuickRequest {
    
    //public typealias ResultType = T
    public typealias RequestBeforeAction = () -> Void
    public typealias RequestSuccessAction = (_ result: T) -> Void
    public typealias RequestFailAction = (_ error: Error) -> Void
    public typealias RequestCompletion = (_ result: T?, _ response: URLResponse?, _ error: Error?) -> Void
    
    open var isCalled: Bool { return _called }
    open var isCompleted: Bool { return _finished }
    public private(set) var urlString: String
    public private(set) var token: String? = nil
    public private(set) var isTokenRequired: Bool = false
    public lazy var headers = [String : String]()

    private var _called = false

    private var _executing = false
    open override var isExecuting: Bool {
        get {
            return self._executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }

    private var _finished = false
    override open var isFinished: Bool {
        get {
            return self._finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }

    open override var isConcurrent: Bool {
        return true
    }

    private var beforeActions = [RequestBeforeAction]()
    private var successActions = [RequestSuccessAction]()
    private var failActions = [RequestFailAction]()
    
    public init(_ urlString: String) {
        self.urlString = urlString
    }
    
    @discardableResult
    open func setTokenRequired() -> Self {
        self.isTokenRequired = true
        return self
    }
    
    @discardableResult
    open func addHeader(_ key: String, _ value: String) -> Self {
        headers[key] = value
        return self
    }
    
    /// 요청을 실행하기 전에 수행할 것을 등록한다.
    @discardableResult
    open func addBeforeAction(_ action: @escaping RequestBeforeAction) -> QuickRequestBase<T> {
        beforeActions.append(action)
        return self
    }
    /// 요청이 성공했을 때 실행할 것을 등록한다.
    @discardableResult
    open func addSuccessAction(_ action: @escaping RequestSuccessAction) -> QuickRequestBase<T> {
        successActions.append(action)
        return self
    }
    /// 요청이 실패했을 때 실행할 것을 등록한다.
    @discardableResult
    open func addFailAction(_ action: @escaping RequestFailAction) -> QuickRequestBase<T> {
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

    open override func cancel() {
        self.finish()
        super.cancel()
    }

    func finish() {
        self.isExecuting = false
        self.isFinished = true
    }

    var resultHandler: ((RequestResult<T>) -> Void)?

    /// 요청을 실행한다.
    public func call(resultHandler: @escaping (RequestResult<T>) -> Void) {
        _called = true
        self.resultHandler = resultHandler
        QuickRequestCenter.default.add(self)
    }
    /// BaseRequest 를 구현한 레이어를 실행한다.
    open func executeCall(_ completion: @escaping RequestCompletion) {
        preconditionFailure("구현해야 하는 부분")
    }

    // MARK: Operation Subclassing

    open override func start() {
        let isRunnable = !self.isFinished && !self.isCancelled && !self.isExecuting
        guard isRunnable else { return }
        guard !Thread.isMainThread else {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                self?.start()
            }
            return
        }
        main()
    }

    open override func main() {
        isExecuting = true
        DispatchQueue.main.async {
            self.notifyBeforeAction()
        }
        executeCall { data, response, error in
            if self.isCancelled == true {
                return
            }
            DispatchQueue.main.async {

                self.finish()

                // notify action handlers
                if let error = error {
                    self.notifyFailAction(error)
                } else if data == nil {
                    self.notifyFailAction(NullDataError(response))
                } else {
                    self.notifySuccessAction(data!)
                }

                self.resultHandler?(RequestResult<T> {
                    if let error = error { throw error }
                    guard let data = data else { throw NullDataError(response) }
                    return data
                })
            }
        }
    }
}


