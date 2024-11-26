//
//  RuntimeHelper.swift
//  DuckDuck
//
//  Created by xxwang on 21/11/2024.
//

import UIKit

/// 一个用于运行时操作的工具类，例如检查类、方法、属性等。
public class RuntimeHelper: NSObject {}

// MARK: - 获取类信息：属性、方法和实例变量
public extension RuntimeHelper {
    /// 获取给定类的所有实例变量名。
    ///
    /// - Parameter classType: 要检查的类类型。
    /// - Returns: 实例变量名称的数组。
    /// - Example:
    ///   ```swift
    ///   let ivars = RuntimeHelper.getInstanceVariableNames(for: MyClass.self)
    ///   print(ivars) // 打印所有实例变量名
    ///   ```
    @discardableResult
    static func getInstanceVariableNames(for classType: AnyClass) -> [String] {
        var ivarNames = [String]()
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(classType, &count) else { return ivarNames }
        for i in 0 ..< Int(count) {
            let namePointer = ivar_getName(ivars[i])!
            let name = String(cString: namePointer)
            ivarNames.append(name)
        }
        free(ivars) // 使用后释放内存
        return ivarNames
    }

    /// 获取给定类的所有属性名。
    ///
    /// - Parameter classType: 要检查的类类型。
    /// - Returns: 属性名称的数组。
    /// - Example:
    ///   ```swift
    ///   let properties = RuntimeHelper.getPropertyNames(for: MyClass.self)
    ///   print(properties) // 打印所有属性名
    ///   ```
    @discardableResult
    static func getPropertyNames(for classType: AnyClass) -> [String] {
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(classType, &count) else { return [] }
        var propertyNames = [String]()
        for i in 0 ..< Int(count) {
            let property = properties[i]
            if let propertyName = NSString(utf8String: property_getName(property)) as String? {
                propertyNames.append(propertyName)
            }
        }
        free(properties) // 使用后释放内存
        return propertyNames
    }

    /// 获取给定类的所有方法选择器。
    ///
    /// - Parameter classType: 要检查的类类型。
    /// - Returns: 方法选择器的数组。
    /// - Example:
    ///   ```swift
    ///   let methods = RuntimeHelper.getMethodSelectors(for: MyClass.self)
    ///   print(methods) // 打印所有方法选择器
    ///   ```
    @discardableResult
    static func getMethodSelectors(for classType: AnyClass) -> [Selector] {
        var methodCount: UInt32 = 0
        var methodSelectors = [Selector]()
        guard let methods = class_copyMethodList(classType, &methodCount) else { return [] }
        for i in 0 ..< Int(methodCount) {
            let method = methods[i]
            methodSelectors.append(method_getName(method))
        }
        free(methods) // 使用后释放内存
        return methodSelectors
    }

    /// 获取给定类的父类。
    ///
    /// - Parameter classType: 要检查的类类型。
    /// - Returns: 父类类型，如果没有父类则返回 nil。
    /// - Example:
    ///   ```swift
    ///   let superclass = RuntimeHelper.getSuperclass(for: MyClass.self)
    ///   print(superclass) // 打印 MyClass 的父类
    ///   ```
    static func getSuperclass(for classType: AnyClass) -> AnyClass? {
        return class_getSuperclass(classType)
    }

    /// 检查给定类是否是另一个类的子类。
    ///
    /// - Parameters:
    ///   - classType: 要检查的类。
    ///   - superclassType: 要检查的父类。
    /// - Returns: 如果 classType 是 superclassType 的子类，则返回 true，否则返回 false。
    /// - Example:
    ///   ```swift
    ///   let isSubclass = RuntimeHelper.isSubclass(of: MyClass.self, superclass: NSObject.self)
    ///   print(isSubclass) // 如果 MyClass 是 NSObject 的子类，则打印 true
    ///   ```
    static func isSubclass(of classType: AnyClass, superclassType: AnyClass) -> Bool {
        return classType.isSubclass(of: superclassType)
    }

    /// 获取给定类采用的所有协议。
    ///
    /// - Parameter classType: 要检查的类类型。
    /// - Returns: 类采用的协议的数组。
    /// - Example:
    ///   ```swift
    ///   let protocols = RuntimeHelper.getProtocols(for: MyClass.self)
    ///   print(protocols) // 打印 MyClass 采用的所有协议
    ///   ```
    static func getProtocols(for classType: AnyClass) -> [Protocol] {
        var count: UInt32 = 0
        guard let protocols = class_copyProtocolList(classType, &count) else { return [] }
        var protocolList = [Protocol]()
        for i in 0 ..< Int(count) {
            protocolList.append(protocols[i])
        }
        return protocolList
    }

    /// 动态地将协议添加到类。
    ///
    /// - Parameters:
    ///   - classType: 要添加协议的类。
    ///   - protocolType: 要添加的协议类型。
    /// - Example:
    ///   ```swift
    ///   RuntimeHelper.addProtocol(to: MyClass.self, protocolType: MyProtocol.self)
    ///   ```
    static func addProtocol(to classType: AnyClass, protocolType: Protocol) {
        if class_addProtocol(classType, protocolType) {
            print("成功将协议 \(protocolType) 添加到类 \(classType)")
        } else {
            print("失败将协议 \(protocolType) 添加到类 \(classType)")
        }
    }

    /// 获取给定选择器的实例方法。
    ///
    /// - Parameters:
    ///   - classType: 要检查的类类型。
    ///   - selector: 要查找的方法选择器。
    /// - Returns: 实例方法，如果未找到则返回 nil。
    /// - Example:
    ///   ```swift
    ///   let method = RuntimeHelper.getInstanceMethod(from: MyClass.self, selector: #selector(MyClass.someMethod))
    ///   print(method) // 如果找到，打印实例方法
    ///   ```
    static func getInstanceMethod(from classType: AnyClass, selector: Selector) -> Method? {
        return class_getInstanceMethod(classType, selector)
    }

    /// 获取给定选择器的类方法。
    ///
    /// - Parameters:
    ///   - classType: 要检查的类类型。
    ///   - selector: 要查找的方法选择器。
    /// - Returns: 类方法，如果未找到则返回 nil。
    /// - Example:
    ///   ```swift
    ///   let method = RuntimeHelper.getClassMethod(from: MyClass.self, selector: #selector(MyClass.classMethod))
    ///   print(method) // 如果找到，打印类方法
    ///   ```
    static func getClassMethod(from classType: AnyClass, selector: Selector) -> Method? {
        return class_getClassMethod(classType, selector)
    }

    /// 在运行时动态创建一个新类。
    ///
    /// - Parameters:
    ///   - className: 新类的名称。
    ///   - superClass: 新类的父类。
    /// - Returns: 新创建的类类型，如果创建失败则返回 nil。
    /// - Example:
    ///   ```swift
    ///   let newClass = RuntimeHelper.createClass(named: "MyNewClass", superClass: UIView.self)
    ///   print(newClass) // 打印新创建的类
    ///   ```
    static func createClass(named className: String, superClass: AnyClass) -> AnyClass? {
        guard let classObj = objc_allocateClassPair(superClass, className, 0) else {
            print("错误：创建类失败。")
            return nil
        }
        objc_registerClassPair(classObj)
        return classObj
    }

    /// 检查一个类是否响应特定的选择器。
    ///
    /// - Parameters:
    ///   - selector: 要检查的方法选择器。
    ///   - classType: 要检查的类类型。
    /// - Returns: 如果类响应该选择器，则返回 true，否则返回 false。
    /// - Example:
    ///   ```swift
    ///   let canRespond = RuntimeHelper.responds(to: #selector(MyClass.someMethod), in: MyClass.self)
    ///   print(canRespond) // 如果类响应该选择器，打印 true
    ///   ```
    static func responds(to selector: Selector, in classType: AnyClass) -> Bool {
        return class_respondsToSelector(classType, selector)
    }

    /// 检查一个对象是否是元类。
    ///
    /// - Parameter object: 要检查的对象。
    /// - Returns: 如果对象是元类，则返回 true，否则返回 false。
    /// - Example:
    ///   ```swift
    ///   let isMetaClass = RuntimeHelper.isMetaClass(for: MyClass.self)
    ///   print(isMetaClass) // 如果 MyClass 是元类，打印 true
    ///   ```
    static func isMetaClass(for object: Any) -> Bool {
        return object_getClass(object) == object_getClass(object_getClass(object))
    }

    /// 获取实例变量的偏移量。
    ///
    /// - Parameter ivar: 要检查的实例变量。
    /// - Returns: 实例变量的偏移量。
    /// - Example:
    ///   ```swift
    ///   let offset = RuntimeHelper.getInstanceVariableOffset(for: ivar)
    ///   print(offset) // 打印实例变量的偏移量
    ///   ```
    static func getInstanceVariableOffset(for ivar: Ivar) -> Int {
        return ivar_getOffset(ivar)
    }
}

// MARK: - 方法交换
public extension RuntimeHelper {
    /// 使用选择器字符串交换两个方法。
    ///
    /// - Parameters:
    ///   - originalSelector: 原始方法的选择器。
    ///   - swizzledSelector: 新方法的选择器。
    ///   - classType: 包含方法的类类型。
    /// - Example:
    ///   ```swift
    ///   RuntimeHelper.exchangeMethods(originalSelector: "originalMethod", swizzledSelector: "newMethod", for: MyClass.self)
    ///   ```
    static func exchangeMethods(originalSelector: String, swizzledSelector: String, for classType: AnyClass) {
        exchangeMethods(originalSelector: Selector(originalSelector), swizzledSelector: Selector(swizzledSelector), for: classType)
    }

    /// 使用选择器交换两个方法。
    ///
    /// - Parameters:
    ///   - originalSelector: 原始方法的选择器。
    ///   - swizzledSelector: 新方法的选择器。
    ///   - classType: 包含方法的类类型。
    /// - Example:
    ///   ```swift
    ///   RuntimeHelper.exchangeMethods(originalSelector: #selector(MyClass.originalMethod),
    ///                                 swizzledSelector: #selector(MyClass.newMethod),
    ///                                 for: MyClass.self)
    ///   ```
    static func exchangeMethods(originalSelector: Selector, swizzledSelector: Selector, for classType: AnyClass) {
        let originalMethod = class_getInstanceMethod(classType, originalSelector)
        let swizzledMethod = class_getInstanceMethod(classType, swizzledSelector)

        if class_addMethod(classType, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(classType, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}
