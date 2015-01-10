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
}

public func coproduct<L, R, T>(f: L -> T, g: R -> T) -> (Either<L, R> -> T) {
    return {e in
        switch(e) {
        case .Left(let l):
            return f(l())
        case .Right(let r):
            return g(r())
        }
    }
}

public func bind<L, R>(l: L) -> Either<L, R> {
    return .Left(l)
}

public func bind<L, R>(r: R) -> Either<L, R> {
    return .Right(r)
}

public func bindFunc<L, R, T>(f: T -> L) -> (T -> Either<L, R>) {
    return {bind(f($0))}
}

public func bindFunc<L, R, T>(g: T -> R) -> (T -> Either<L, R>) {
    return {bind(g($0))}
}
