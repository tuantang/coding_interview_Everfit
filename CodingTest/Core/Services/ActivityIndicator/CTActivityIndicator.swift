//
//  CTActivityIndicator.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxRelay

private struct CTActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

public class CTActivityIndicator : SharedSequenceConvertibleType {

    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let lock = NSRecursiveLock()
    private let variable = BehaviorRelay(value: 0)
    private let loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        loading = variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return Observable.using({ () -> CTActivityToken<O.Element> in
            self.increment()
            return CTActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }
    
    private func increment() {
        lock.lock()
        variable.accept(variable.value + 1)
        lock.unlock()
    }
    
    private func decrement() {
        lock.lock()
        variable.accept(variable.value - 1)
        lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, CTActivityIndicator.Element> {
        return loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: CTActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}

func isLoading(for refreshControl : UIRefreshControl) -> AnyObserver<Bool> {
    
    return Binder(refreshControl, binding: { (hud, isLoading) in
        switch isLoading {
        case true:
            refreshControl.beginRefreshing()
        case false:
            refreshControl.endRefreshing()
            break
        }
    }).asObserver()
}
