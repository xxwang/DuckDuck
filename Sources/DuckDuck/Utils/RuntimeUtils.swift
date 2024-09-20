//
//  RuntimeUtils.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import UIKit

public class RuntimeUtils: NSObject {}

// MARK: - 静态方法
public extension RuntimeUtils {
    /// 成员变量列表
    /// - Parameter type:类型
    @discardableResult
    static func ivars(_ type: AnyClass) -> [String] {
        var listName = [String]()
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type, &count)
        for i in 0 ..< count {
            let nameP = ivar_getName(ivars![Int(i)])!
            let name = String(cString: nameP)
            listName.append(name)
        }
        // 方法中有 copy,create,的都需要释放
        free(ivars)
        return listName
    }

    /// 获取所有的属性名字
    /// - Parameter aClass:类名
    /// - Returns:返回属性名字数组
    @discardableResult
    static func getAllPropertyName(_ aClass: AnyClass) -> [String] {
        var count = UInt32()
        let properties = class_copyPropertyList(aClass, &count)
        var propertyNames = [String]()
        let intCount = Int(count)
        for i in 0 ..< intCount {
            let property: objc_property_t = properties![i]

            guard let propertyName = NSString(utf8String: property_getName(property)) as String? else {
                print("Couldn't unwrap property name for \(property)")
                break
            }
            propertyNames.append(propertyName)
        }
        free(properties)
        return propertyNames
    }

    /// 获取方法列表
    /// - Parameter classType:所属类型
    /// - Returns:方法列表
    @discardableResult
    static func methods(from classType: AnyClass) -> [Selector] {
        var methodNum: UInt32 = 0
        var list = [Selector]()
        let methods = class_copyMethodList(classType, &methodNum)
        for index in 0 ..< numericCast(methodNum) {
            if let met = methods?[index] {
                let selector = method_getName(met)
                list.append(selector)
            }
        }
        free(methods)
        return list
    }
}

// MARK: - 交换方法
public extension RuntimeUtils {
    /// 交换方法(方法为字符串格式)
    /// - Parameters:
    ///   - target:被交换的方法名
    ///   - replace:用于交换的方法名
    ///   - classType:所属类型
    static func exchangeMethod(target: String,
                               replace: String,
                               class classType: AnyClass)
    {
        exchangeMethod(selector: Selector(target),
                       replace: Selector(replace),
                       class: classType)
    }

    /// 交换方法(方法为Selector格式)
    /// - Parameters:
    ///   - selector:被交换的方法
    ///   - replace:用于交换的方法
    ///   - classType:所属类型
    static func exchangeMethod(selector: Selector,
                               replace: Selector,
                               class classType: AnyClass)
    {
        let select1 = selector
        let select2 = replace

        let select1Method = class_getInstanceMethod(classType, select1)
        let select2Method = class_getInstanceMethod(classType, select2)

        let didAddMethod = class_addMethod(classType, select1, method_getImplementation(select2Method!), method_getTypeEncoding(select2Method!))
        if didAddMethod {
            class_replaceMethod(classType, select2, method_getImplementation(select1Method!), method_getTypeEncoding(select1Method!))
        } else {
            method_exchangeImplementations(select1Method!, select2Method!)
        }
    }
}
