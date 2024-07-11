// The Swift Programming Language
// https://docs.swift.org/swift-book

struct DuckDuck {
    static let text = "Hello World!"
}

extension DuckDuck {
    static func sayHello() {
        DDLog.info(self.text)
    }
}
