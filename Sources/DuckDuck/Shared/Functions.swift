//
//  Functions.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import Foundation

/// 对对象进行设置
///
/// - Note: 需要对象是引用类型
/// - Parameters:
///   - object: 目标对象
///   - closure: 进行设置的闭包
public func dd_configure<T: AnyObject>(_ object: T, closure: (T) -> Void) {
    closure(object)
}

/// `JSON`转模型
/// - Parameters:
///   - model: 遵守`Codable`协议的模型类型
///   - json: 需要转模型的`JSON`数据
/// - Returns: 遵守`Codable`协议的模型对象
public func dd_JSON2Model<T: Codable>(_ model: T.Type, _ json: Any?) -> T? {
    guard let json else { return nil }

    let jsonData: Data?
    if let string = json as? String {
        jsonData = string.dd_Data()
    } else if let dict = json as? [String: Any] {
        jsonData = dict.dd_Data()
    } else if let data = json as? Data {
        jsonData = data
    } else if let array = json as? [[String: Any]] {
        jsonData = array.dd_Data()
    } else {
        return nil
    }

    guard let data = jsonData else { return nil }

    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        return nil
    }
}
