import Foundation

// MARK: - 关联属性工具类
public class AttributeBinder {
    // 为对象设置关联属性
    public static func bind(
        to object: AnyObject,
        withKey key: UnsafeRawPointer,
        value: Any?,
        usingPolicy policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(object, key, value, policy)
    }

    // 获取对象的关联属性
    public static func retrieve<T>(
        _ object: AnyObject,
        forKey key: UnsafeRawPointer
    ) -> T? {
        return objc_getAssociatedObject(object, key) as? T
    }

    // 移除对象的所有关联属性
    public static func unbindAllAttributes(of object: AnyObject) {
        objc_removeAssociatedObjects(object)
    }
}
