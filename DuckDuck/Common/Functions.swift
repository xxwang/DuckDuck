import Foundation

/// 对对象进行设置
///
/// - Note: 需要对象是引用类型
/// - Parameters:
///   - object: 目标对象
///   - closure: 进行设置的闭包
/// - Example:
/// ```swift
/// dd_configure(myObject) { object in
///     object.property = "new value"
/// }
/// ```
public func dd_configure<T: AnyObject>(_ object: T, closure: (T) -> Void) {
    closure(object)
}
