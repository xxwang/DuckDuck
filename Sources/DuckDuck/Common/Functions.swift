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

/// 将`JSON`数据转化为模型对象
/// - Parameters:
///   - model: 遵守`Codable`协议的模型类型
///   - json: 需要转化为模型的`JSON`数据
/// - Returns: 返回遵守`Codable`协议的模型对象，若转换失败则返回`nil`
/// - Example:
/// ```swift
/// if let model = dd_JSONToModel(MyModel.self, json) {
///     print(model)
/// }
/// ```
public func dd_JSONToModel<T: Codable>(_ model: T.Type, _ json: Any?) -> T? {
    guard let json else { return nil }

    let jsonData: Data?
    // 判断传入的json类型并转换为Data
    if let string = json as? String {
        jsonData = string.dd_toData()
    } else if let dict = json as? [String: Any] {
        jsonData = dict.dd_toJSONData()
    } else if let data = json as? Data {
        jsonData = data
    } else if let array = json as? [[String: Any]] {
        jsonData = array.dd_toJSONData()
    } else {
        return nil
    }

    // 确保转换后的jsonData不为nil
    guard let data = jsonData else { return nil }

    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        return nil
    }
}
