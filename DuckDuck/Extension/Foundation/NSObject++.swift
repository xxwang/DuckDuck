import UIKit

// MARK: - 获取类信息
public extension NSObject {
    /// 获取对象的类名字符串
    /// - Returns: 类名字符串
    /// - Example:
    /// ```swift
    /// let className = myObject.dd_className()
    /// ```
    func dd_className() -> String {
        let name = type(of: self).description()
        guard name.contains(".") else { return name }
        return name.components(separatedBy: ".").last ?? ""
    }

    /// 获取类的名称字符串
    /// - Returns: 类名称字符串
    /// - Example:
    /// ```swift
    /// let className = MyClass.dd_className()
    /// ```
    static func dd_className() -> String {
        return String(describing: Self.self)
    }

    /// 获取类中所有成员变量名称
    /// - Returns: 成员变量名称数组
    /// - Example:
    /// ```swift
    /// print(MyClass.dd_members())  // 输出 ["property1", "property2"]
    /// ```
    static func dd_members() -> [String] {
        var varNames = [String]()
        var count: UInt32 = 0
        let ivarList = class_copyIvarList(Self.self, &count)

        for i in 0 ..< count {
            let ivar = ivarList![Int(i)]
            let cName = ivar_getName(ivar)
            if let name = String(cString: cName!, encoding: String.Encoding.utf8) {
                varNames.append(name)
            }
        }
        free(ivarList)

        return varNames
    }

    /// 获取对象的所有属性名称及其类型
    /// - Returns: 字典形式的属性名称和类型
    /// - Example:
    /// ```swift
    /// let properties = MyClass().dd_allPropertiesWithTypes()
    /// ```
    func dd_allPropertiesWithTypes() -> [String: String] {
        var properties = [String: String]()
        var count: UInt32 = 0
        let propertyList = class_copyPropertyList(type(of: self), &count)

        // 遍历所有的属性
        for i in 0 ..< count {
            let property = propertyList![Int(i)]
            let name = String(cString: property_getName(property))

            // 获取属性的所有属性列表
            let attributes = property_copyAttributeList(property, nil)

            var type = ""
            // 遍历所有属性列表，查找类型（'T'代表类型）
            for j in 0 ..< Int(count) {
                let attribute = attributes![j]
                if String(cString: attribute.name) == "T" {
                    type = String(cString: attribute.value)
                }
            }

            properties[name] = type
            free(attributes) // 释放内存
        }

        free(propertyList) // 释放内存
        return properties
    }

    /// 获取对象的内存地址
    /// - Returns: 对象的内存地址字符串
    /// - Example:
    /// ```swift
    /// let memoryAddress = myObject.dd_memoryAddress()
    /// ```
    func dd_memoryAddress() -> String {
        let address = unsafeBitCast(self, to: UnsafeRawPointer.self)
        return String(format: "%p", Int(bitPattern: address))
    }

    /// 获取对象的内存大小（估算）
    /// - Returns: 内存大小
    /// - Example:
    /// ```swift
    /// let memorySize = myObject.dd_memorySize()
    /// ```
    func dd_memorySize() -> Int {
        return MemoryLayout.size(ofValue: self)
    }
}

// MARK: - 动态方法调用
public extension NSObject {
    /// 动态调用对象的方法
    /// - Parameters:
    ///   - methodName: 方法名称
    ///   - arguments: 方法参数
    /// - Returns: 方法执行结果
    /// - Example:
    /// ```swift
    /// let result = myObject.dd_callMethod("methodName", withArguments: [arg1, arg2])
    /// ```
    func dd_callMethod(_ methodName: String, withArguments arguments: [Any] = []) -> Any? {
        let selector = NSSelectorFromString(methodName)

        if self.responds(to: selector) {
            guard let method = class_getInstanceMethod(type(of: self), selector) else {
                return nil
            }

            let imp = method_getImplementation(method)
            typealias Function = @convention(c) (AnyObject, Selector, [Any]) -> Any
            let function = unsafeBitCast(imp, to: Function.self)

            return function(self, selector, arguments)
        }

        return nil
    }
}

// MARK: - 动态属性管理
public extension NSObject {
    /// 动态为对象添加一个新的属性
    /// - Parameters:
    ///   - key: 属性的键名
    ///   - value: 属性的值
    /// - Example:
    /// ```swift
    /// myObject.dd_addProperty("newProperty", value: "new value")
    /// ```
    func dd_addProperty(_ key: String, value: Any) {
        // 强制解包
        guard let rawPointer = UnsafeRawPointer(bitPattern: key.hashValue) else {
            return
        }
        // 使用 `rawPointer` 来设置关联对象
        objc_setAssociatedObject(self, rawPointer, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// 获取动态添加的属性
    /// - Parameter key: 属性的键名
    /// - Returns: 属性值
    /// - Example:
    /// ```swift
    /// let value = myObject.dd_getProperty("newProperty")
    /// ```
    func dd_getProperty(_ key: String) -> Any? {
        // 使用 `guard` 确保 `UnsafeRawPointer` 不为 `nil`
        guard let rawPointer = UnsafeRawPointer(bitPattern: key.hashValue) else {
            return nil
        }

        // 使用 `rawPointer` 获取关联对象
        return objc_getAssociatedObject(self, rawPointer)
    }
}

// MARK: - 对象比较与类型检查
public extension NSObject {
    /// 检查对象是否为空或未初始化
    /// - Returns: 是否为 `nil` 或空对象
    /// - Example:
    /// ```swift
    /// let isNil = myObject.dd_isNilOrEmpty()
    /// ```
    func dd_isNilOrEmpty() -> Bool {
        return (self as? NSNull) != nil || (self as? String)?.isEmpty ?? true
    }

    /// 比较两个对象是否相等
    /// - Parameter other: 要比较的另一个对象
    /// - Returns: 是否相等
    /// - Example:
    /// ```swift
    /// let isEqual = myObject.dd_isEqual(to: otherObject)
    /// ```
    func dd_isEqual(to other: Any?) -> Bool {
        return self.isEqual(other)
    }

    /// 强制将对象转换为指定类型
    /// - Parameter type: 目标类型
    /// - Returns: 转换后的对象
    /// - Example:
    /// ```swift
    /// let stringObject = myObject.dd_cast(to: String.self)
    /// ```
    func dd_cast<T>(to type: T.Type) -> T? {
        return self as? T
    }

    /// 检查对象是否属于指定类型
    /// - Parameter type: 要检查的类型
    /// - Returns: 是否是指定类型的实例
    /// - Example:
    /// ```swift
    /// let isString = myObject.dd_isInstance(of: String.self)
    /// ```
    func dd_isInstance(of type: Any.Type) -> Bool {
        return self.isKind(of: type as! AnyObject.Type)
    }

    // MARK: - 打印日志
    /// 打印对象的所有属性及其值
    /// - Example:
    /// ```swift
    /// myObject.dd_logProperties()
    /// ```
    func dd_logProperties() {
        let properties = self.dd_allPropertiesWithTypes()
        for (key, type) in properties {
            if let value = self.value(forKey: key) {
                print("\(key): \(value) (\(type))")
            }
        }
    }

    /// 打印对象的类信息
    /// - Example:
    /// ```swift
    /// myObject.dd_logClassInfo()
    /// ```
    func dd_logClassInfo() {
        print("Class Name: \(self.dd_className())")
        print("Properties: \(self.dd_allPropertiesWithTypes())")
    }

    // MARK: - 深拷贝
    /// 深拷贝对象，适用于遵守 `NSCopying` 协议的对象
    /// - Returns: 拷贝后的对象
    /// - Example:
    /// ```swift
    /// let copy = myObject.dd_deepCopy()
    /// ```
    func dd_deepCopy() -> Any? {
        guard let copy = self.copy() as? NSObject else { return nil }
        return copy
    }
}

// MARK: - 方法交换
public extension NSObject {
    /// 交换类方法实现 (确保方法前有 `@objc dynamic` 修饰)
    /// - Parameters:
    ///   - originalSelector: 原始方法
    ///   - newSelector: 新方法
    /// - Returns: 交换是否成功
    /// - Example:
    /// ```swift
    /// MyClass.dd_hookClassMethod(of: #selector(originalMethod), with: #selector(newMethod))
    /// ```
    class func dd_hookClassMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        return self.dd_hookMethod(of: originalSelector, with: newSelector, isClassMethod: true)
    }

    /// 交换实例方法实现 (确保方法前有 `@objc dynamic` 修饰)
    /// - Parameters:
    ///   - originalSelector: 原始方法
    ///   - newSelector: 新方法
    /// - Returns: 交换是否成功
    /// - Example:
    /// ```swift
    /// MyClass.dd_hookInstanceMethod(of: #selector(originalInstanceMethod), with: #selector(newInstanceMethod))
    /// ```
    class func dd_hookInstanceMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        return self.dd_hookMethod(of: originalSelector, with: newSelector, isClassMethod: false)
    }

    /// 交换方法实现
    /// - Parameters:
    ///   - originalSelector: 原始方法
    ///   - newSelector: 新方法
    ///   - isClassMethod: 是否是类方法
    /// - Returns: 交换是否成功
    private class func dd_hookMethod(of originalSelector: Selector, with newSelector: Selector, isClassMethod: Bool) -> Bool {
        let selfClass: AnyClass = Self.classForCoder()

        guard
            let originalMethod = (isClassMethod
                ? class_getClassMethod(selfClass, originalSelector)
                : class_getInstanceMethod(selfClass, originalSelector)),
            let newMethod = (isClassMethod
                ? class_getClassMethod(selfClass, newSelector)
                : class_getInstanceMethod(selfClass, newSelector))
        else { return false }

        // 尝试添加新方法，如果添加成功则替换方法
        let didAddMethod = class_addMethod(
            selfClass,
            originalSelector,
            method_getImplementation(newMethod),
            method_getTypeEncoding(newMethod)
        )

        if didAddMethod {
            class_replaceMethod(
                selfClass,
                newSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, newMethod)
        }
        return true
    }
}

// MARK: - setValue 方法交换
public extension NSObject {
    /// 初始化交换方法，在 `AppDelegate` 中调用来初始化交换逻辑
    /// - Note: 由于 `initialize()` 已废弃，在 `AppDelegate` 中调用此方法以确保正确交换方法
    /// - Example:
    /// ```swift
    /// MyClass.dd_initializeMethod()  // 在 AppDelegate 中调用
    /// ```
    class func dd_initializeMethod() {
        if self != NSObject.self {
            self.dd_hook_setValues()
        }
    }

    /// 交换对象的设值方法
    private class func dd_hook_setValues() {
        let onceToken = "Hook_\(NSStringFromClass(Self.classForCoder()))"
        DispatchQueue.dd_once(token: onceToken) {
            let originalSetValueSelector = #selector(Self.setValue(_:forUndefinedKey:))
            let replacementSetValueSelector = #selector(Self.dd_hook_setValue(_:forUndefinedKey:))
            _ = self.dd_hookInstanceMethod(of: originalSetValueSelector, with: replacementSetValueSelector)

            let originalGetValueSelector = #selector(Self.value(forUndefinedKey:))
            let replacementGetValueSelector = #selector(Self.dd_hook_value(forUndefinedKey:))
            _ = self.dd_hookInstanceMethod(of: originalGetValueSelector, with: replacementGetValueSelector)

            let originalSetNilValueSelector = #selector(Self.setNilValueForKey(_:))
            let replacementSetNilValueSelector = #selector(Self.dd_hook_setNilValueForKey(_:))
            _ = self.dd_hookInstanceMethod(of: originalSetNilValueSelector, with: replacementSetNilValueSelector)

            let originalSetValuesForKeysSelector = #selector(Self.setValuesForKeys(_:))
            let replacementSetValuesForKeysSelector = #selector(Self.dd_hook_setValuesForKeys(_:))
            _ = self.dd_hookInstanceMethod(of: originalSetValuesForKeysSelector, with: replacementSetValuesForKeysSelector)
        }
    }
}

private extension NSObject {
    /// 当调用 `setValue(_:forUndefinedKey:)` 方法时，如果遇到未定义的键，会触发此方法
    /// - Parameters:
    ///   - value: 设置的值
    ///   - key: 键
    @objc func dd_hook_setValue(_ value: Any?, forUndefinedKey key: String) {
        Logger.error("setValue(_:forUndefinedKey:), 未知键Key: \(key), 值: \(value ?? "")")
    }

    /// 当调用 `value(forUndefinedKey:)` 方法时，如果遇到未定义的键，会触发此方法
    /// - Parameters:
    ///   - key: 键
    /// - Returns: `nil`
    @objc func dd_hook_value(forUndefinedKey key: String) -> Any? {
        Logger.error("value(forUndefinedKey:), 未知键: \(key)")
        return nil
    }

    /// 当调用 `setNilValueForKey(:)` 方法时，如果键值为 `nil`，且值不支持 `nil`，会触发此方法
    /// - Parameters:
    ///   - key: 键
    @objc func dd_hook_setNilValueForKey(_ key: String) {
        Logger.error("setNilValueForKey(_:), 无法给非指针对象(如`NSInteger`)赋值 `nil` 键: \(key)")
    }

    /// 替换 `setValuesForKeys(:)` 方法，手动为非对象类型转换为字符串
    /// - Parameters:
    ///   - keyedValues: 键值字典
    @objc func dd_hook_setValuesForKeys(_ keyedValues: [String: Any]) {
        for (key, value) in keyedValues {
            Logger.info("\(key) -- \(value)")

            // 为数字类型转换为字符串再设置
            if value is Int || value is CGFloat || value is Double {
                self.setValue("\(value)", forKey: key)
            } else {
                self.setValue(value, forKey: key)
            }
        }
    }
}
