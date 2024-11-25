// The Swift Programming Language
// https://docs.swift.org/swift-book

struct DuckDuck {
    static let text = "Hello World!"
}

extension DuckDuck {
    @MainActor
    static func sayHello() {
        Logger.info(self.text)
    }
}
