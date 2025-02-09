import UIKit

// MARK: - NotificationCenter 扩展
public extension NotificationCenter {
    /// 异步发送通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - object: 通知对象（可选）
    ///   - userInfo: 通知的附加信息字典（可选）
    /// - Example:
    /// ```swift
    /// NotificationCenter.dd_postNotification(.myCustomNotification, object: self, userInfo: ["key": "value"])
    /// ```
    static func dd_postNotification(
        _ name: Notification.Name,
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil
    ) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }

    /// 异步添加通知监听器
    /// - Parameters:
    ///   - observer: 监听者对象
    ///   - selector: 响应方法
    ///   - name: 通知名称
    ///   - object: 监听的对象（可选）
    /// - Example:
    /// ```swift
    /// NotificationCenter.dd_addObserverForNotification(self, selector: #selector(handleNotification), name: .myCustomNotification)
    /// ```
    static func dd_addObserverForNotification(
        _ observer: Any,
        selector: Selector,
        name: Notification.Name,
        object: Any? = nil
    ) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }

    /// 移除指定通知的监听
    /// - Parameters:
    ///   - observer: 需要移除的监听者对象
    ///   - name: 通知名称（可选，若不指定，则移除所有通知）
    ///   - object: 监听的对象（可选）
    /// - Example:
    /// ```swift
    /// NotificationCenter.dd_removeObserverForNotification(self, name: .myCustomNotification)
    /// ```
    static func dd_removeObserverForNotification(
        _ observer: Any,
        name: Notification.Name? = nil,
        object: Any? = nil
    ) {
        if let name {
            // 移除指定通知的监听者
            NotificationCenter.default.removeObserver(observer, name: name, object: object)
        } else {
            // 移除所有通知的监听者
            NotificationCenter.default.removeObserver(observer)
        }
    }

    /// 移除指定监听者的所有通知监听
    /// - Parameter observer: 监听者对象
    /// - Example:
    /// ```swift
    /// NotificationCenter.dd_removeAllObserversForNotification(self)
    /// ```
    static func dd_removeAllObserversForNotification(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
