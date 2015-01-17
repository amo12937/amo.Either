# amo.Either
「2つの型のうちのどちらか」を表す generic 型

# 使い方
- リポジトリをクローン
```
git clone -b v1.0.0 git@github.com:amo12937/amo.Either.git
```

- xcode でビルド
- Products/Either.framework を使いたいプロジェクトへコピー

# 仕様兼テスト
## 2つの型のどちらかを保持できる
```swift:EitherTests.swift
    func test_2つの型のどちらかを保持できる() {
        let n = 1
        let u = Either<Int, String>.Left(n)
        XCTAssertEqual(n, u.left()!)
        XCTAssertTrue(u.right() == nil)
        
        let s = "hoge"
        let v = Either<Int, String>.Right(s)
        XCTAssertTrue(v.left() == nil)
        XCTAssertEqual(s, v.right()!)
    }
```

## coproductは返り値が同じ型の2つの関数からEither型を引数とする関数を返す
```swift:EitherTests.swift
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
```
    
## bindはEitherのconstructorと同じ働きをする
```swift:EitherTests.swift
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
```
    
## bindFuncは関数をbindする
```swift:EitherTests.swift
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
```

## leftFunc / rithgFunc は Either から T への関数を L / R から T への関数に変換する
```swift:EitherTests.swift
    func test_leftFuncはEitherからTへの関数をLからTへの関数に変換する() {
        let f = {(l: Int) -> Bool in
            return l > 5
        }
        let g = {(r: String) -> Bool in
            return r.isEmpty
        }
        let e = Either<Int, String>.coproduct(f, g)
        let actual = Either<Int, String>.leftFunc(e)
        XCTAssertEqual(true, actual(6))
        XCTAssertEqual(false, actual(5))
    }
    
    func test_rightFuncはEitherからTへの関数をRからTへの関数に変換する() {
        let f = {(l: Int) -> Bool in
            return l > 5
        }
        let g = {(r: String) -> Bool in
            return r.isEmpty
        }
        let e = Either<Int, String>.coproduct(f, g)
        let actual = Either<Int, String>.rightFunc(e)
        XCTAssertEqual(true, actual(""))
        XCTAssertEqual(false, actual("hoge"))
    }
```

