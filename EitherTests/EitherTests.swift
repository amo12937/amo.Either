//
//  EitherTests.swift
//  EitherTests
//
//  Created by amo on 2015/01/10.
//  Copyright (c) 2015年 amo. All rights reserved.
//

import UIKit
import XCTest
import Either

class EitherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_2つの型のどちらかを保持できる() {
        let n = 1
        let u = Either<Int, String>.left(n)
        XCTAssertEqual(n, u.left()!)
        XCTAssertTrue(u.right() == nil)
        
        let s = "hoge"
        let v = Either<Int, String>.right(s)
        XCTAssertTrue(v.left() == nil)
        XCTAssertEqual(s, v.right()!)
    }
    
    func test_coproductは返り値が同じ型の2つの関数からEither型を引数とする関数を返す() {
        var f_count = 0
        func f(b: Bool) -> String {
            f_count++
            return "\(b)"
        }
        
        var g_count = 0
        func g(n: Int) -> String {
            g_count++
            return "\(n)"
        }
        
        let u = Either.coproduct(f, g)
        
        let x = Either<Bool, Int>.bind(true)
        let y = Either<Bool, Int>.bind(1)
        
        XCTAssertEqual(0, f_count)
        XCTAssertEqual("true", u(x))
        XCTAssertEqual(1, f_count)
        
        XCTAssertEqual(0, g_count)
        XCTAssertEqual("1", u(y))
        XCTAssertEqual(1, g_count)
    }
    
    func test_bindはEitherのconstructorと同じ働きをする() {
        let n = 1
        let u = Either<Int, String>.bind(n)
        XCTAssertEqual(n, u.left()!)
        XCTAssertTrue(u.right() == nil)
        
        let s = "hoge"
        let v = Either<Int, String>.bind(s)
        XCTAssertTrue(v.left() == nil)
        XCTAssertEqual(s, v.right()!)
    }
    
    func test_bindFuncは関数をbindする() {
        let l = ["a", "b", "c"]

        let f = {(a: [String]) -> Int in a.count}
        let u = Either<Int, String>.bindFunc(f)
        XCTAssertEqual(3, u(l).left()!)
        XCTAssertTrue(u(l).right() == nil)
        
        let g = {(a: [String]) -> String in "".join(a)}
        let v = Either<Int, String>.bindFunc(g)
        XCTAssertTrue(v(l).left() == nil)
        XCTAssertEqual("abc", v(l).right()!)
    }
}
