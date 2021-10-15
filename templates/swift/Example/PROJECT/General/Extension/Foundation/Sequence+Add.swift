//
//  Sequence+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

/*
 public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ()) rethrows -> Result
 */
enum AsyncReduceControl<Error: Swift.Error> {
    case next
    case retry
    case retryAfter(_ delay: TimeInterval)
    case stop(_ error: Error)
}
/// 因为Swfit不允许闭包捕获输入输出参数，所以只好包装一层
final class AsyncReduceOutputBox<Output> {
    var value: Output
    init(value: Output) {
        self.value = value
    }
}
extension Sequence {
    
    typealias ReduceControl<Error: Swift.Error> = (AsyncReduceControl<Error>) -> Void
    func asyncReduce<Output, Error: Swift.Error>(
        into initialResult: Output, errorType: Error.Type,
        background: Bool = true,
        handler: @escaping (_ box: AsyncReduceOutputBox<Output>,
                            _ item: Element,
                            _ retryCount: Int,
                            _ control: @escaping ReduceControl<Error>) -> Void,
        done: @escaping (Result<Output, Error>) -> Void) {
        
        var iterator = makeIterator()
        guard let firstItem = iterator.next() else {
            done(.success(initialResult))
            return
        }
        let box = AsyncReduceOutputBox(value: initialResult)
        var retryCount = 0
        let queue = background ? DispatchQueue.global() : DispatchQueue.main
        func generator(item itemParam: Element?) {
            guard let item = itemParam else {
                DispatchQueue.main.async {
                    done(.success(box.value))
                }
                return
            }
            
            let closure = { (action: AsyncReduceControl<Error>) in
                switch action {
                case .next:
                    retryCount = 0
                    queue.async { generator(item: iterator.next()) }
                case .retry:
                    retryCount += 1
                    queue.async { generator(item: item) }
                case .retryAfter(let delay):
                    queue.after(delay) {
                        retryCount += 1
                        generator(item: item)
                    }
                case .stop(let error):
                    retryCount = 0
                    DispatchQueue.main.async {
                        done(.failure(error))
                    }
                }
            }
            handler(box, item, retryCount, closure)
        }
        queue.async { generator(item: firstItem) }
    }
}
