//
//  Either.swift
//  Either
//
//  Created by amo on 2015/01/10.
//  Copyright (c) 2015年 amo. All rights reserved.
//

import Foundation

public class Box<T> {
    let unbox: T
    init(_ v: T) {
        self.unbox = v
    }
}

public enum Either<L, R> {
    case Left(Box<L>)
    case Right(Box<R>)
    
    public static func left(l: L) -> Either<L, R> {
        return .Left(Box<L>(l))
    }
    
    public static func right(r: R) -> Either<L, R> {
        return .Right(Box<R>(r))
    }
    
    public func left() -> L? {
        switch self {
        case .Left(let boxed):
            return boxed.unbox
        case .Right:
            return nil
        }
    }
    
    public func right() -> R? {
        switch self {
        case .Left:
            return nil
        case .Right(let boxed):
            return boxed.unbox
        }
    }
    
    public static func coproduct<T>(f: L -> T, g: R -> T) -> (Either<L, R> -> T) {
        return {e in
            switch e {
            case .Left(let l):
                return f(l.unbox)
            case .Right(let r):
                return g(r.unbox)
            }
        }
    }
    
    public static func bind(l: L) -> Either <L, R> {
        return .Left(Box<L>(l))
    }
    
    public static func bind(r: R) -> Either <L, R> {
        return .Right(Box<R>(r))
    }
    
    public static func bindFunc<T>(f: T -> L) -> (T -> Either<L, R>) {
        return {Either.bind(f($0))}
    }
    
    public static func bindFunc<T>(g: T -> R) -> (T -> Either<L, R>) {
        return {Either.bind(g($0))}
    }

    public static func leftFunc<T>(f: Either<L, R> -> T) -> (L -> T) {
        return {l in f(Either<L, R>.left(l))}
    }
    
    public static func rightFunc<T>(f: Either<L, R> -> T) -> (R -> T) {
        return {r in f(Either<L, R>.right(r))}
    }
}
