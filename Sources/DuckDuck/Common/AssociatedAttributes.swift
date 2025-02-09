import Foundation

// MARK: - 事件处理协议
public protocol OnEventHandler {
    /// 关联回调闭包参数类型
    associatedtype OnEvent

    /// 回调闭包别名
    typealias OnEventHandlerClosure = (OnEvent?) -> Void

    /// 事件处理闭包
    var onEvent: OnEventHandlerClosure? { get set }
}
