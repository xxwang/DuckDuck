import Foundation

// MARK: - 关联属性工具类
public class AssociatedObject {
    /// 为对象设置关联属性
    /// - Parameters:
    ///   - object: 需要设置关联属性的对象，通常是一个类的实例。
    ///   - key: 关联属性的键，使用`UnsafeRawPointer`类型确保唯一性。
    ///   - value: 要关联的值，可以是任意类型。
    ///   - policy: 关联策略，默认为`.OBJC_ASSOCIATION_RETAIN_NONATOMIC`。
    /// - Example:
    /// ```swift
    /// let key = &AssociatedKey.someKey
    /// AssociatedObject.set(myObject, key: key, value: "Hello")
    /// ```
    static func set(
        _ object: Any,
        key: UnsafeRawPointer,
        value: Any?,
        policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(object, key, value, policy)
    }

    /// 获取对象的关联属性
    /// - Parameters:
    ///   - object: 需要获取关联属性的对象。
    ///   - key: 关联属性的键，使用`UnsafeRawPointer`类型确保唯一性。
    /// - Returns: 返回关联的值，如果没有找到对应的值则返回`nil`。
    /// - Example:
    /// ```swift
    /// let value = AssociatedObject.get(myObject, key: key)
    /// print(value ?? "没有关联属性")
    /// ```
    static func get(
        _ object: Any,
        key: UnsafeRawPointer
    ) -> Any? {
        return objc_getAssociatedObject(object, key)
    }

    /// 移除对象的所有关联属性
    /// - Parameter object: 需要移除关联属性的对象。
    /// - Example:
    /// ```swift
    /// AssociatedObject.remove(myObject)
    /// ```
    static func remove(_ object: Any) {
        objc_removeAssociatedObjects(object)
    }
}
