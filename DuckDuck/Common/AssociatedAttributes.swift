import Foundation

// MARK: - 事件处理协议
public protocol OnEventHandler {
    /// 关联回调闭包参数类型
    associatedtype Sender

    /// 回调闭包别名
    typealias OnEventHandlerCallback = (Sender?) -> Void

    /// 事件处理闭包
    var onEvent: OnEventHandlerCallback? { get set }
}
