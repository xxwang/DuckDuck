// The Swift Programming Language
// https://docs.swift.org/swift-book

struct DuckDuck: @unchecked Sendable {
    @MainActor static func sayHello() {
        Logger.info("Hello, I am DuckDuck!")
    }
}
