//
//  Either.swift
//  Either
//
//  Created by amo on 2015/01/10.
//  Copyright (c) 2015年 amo. All rights reserved.
//

import Foundation

public enum Either<L, R> {
    case Left(@autoclosure() -> L)
    case Right(@autoclosure() -> R)
    
    public func left() -> L? {
        switch self {
        case .Left(let l):
            return l()
        case .Right:
            return nil
        }
    }
    
    public func right() -> R? {
        switch self {
        case .Left:
            return nil
        case .Right(let r):
            return r()
        }
    }
    
    public static func coproduct<T>(f: L -> T, g: R -> T) -> (Either<L, R> -> T) {
        return {e in
            switch(e) {
            case .Left(let l):
                return f(l())
            case .Right(let r):
                return g(r())
            }
        }
    }

    public static func bind(l: L) -> Either<L, R> {
        return .Left(l)
    }
    
    public static func bind(r: R) -> Either<L, R> {
        return .Right(r)
    }
    
    public static func bindFunc<T>(f: T -> L) -> (T -> Either<L, R>) {
        return {Either.bind(f($0))}
    }
    
    public static func bindFunc<T>(g: T -> R) -> (T -> Either<L, R>) {
        return {Either.bind(g($0))}
    }

}
