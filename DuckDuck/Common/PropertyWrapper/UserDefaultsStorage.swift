import Foundation

// MARK: - UserDefaultsStorage
@propertyWrapper
public struct UserDefaultsStorage<T> {
    private let userDefaults: UserDefaults
    private let key: String
    private let defaultValue: T

    /// 初始化属性包装器
    /// - Parameters:
    ///   - key: 存储值的键
    ///   - default: 默认值
    ///   - userDefaults: 指定的 `UserDefaults` 实例，默认为 `.standard`
    /// - Example:
    /// ```swift
    /// @UserDefaultsStorage("test", default: 0)
    /// var test: Int
    /// ```
    public init(
        _ key: String,
        default: T,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = `default`
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [key: `default`])
    }

    /// 包装的属性值
    public var wrappedValue: T {
        get {
            // 检查 T 是否是基础数据类型
            if T.self is Bool.Type || T.self is Bool?.Type ||
                T.self is Int.Type || T.self is Int?.Type ||
                T.self is UInt.Type || T.self is UInt?.Type ||
                T.self is Float.Type || T.self is Float?.Type ||
                T.self is Double.Type || T.self is Double?.Type ||
                T.self is String.Type || T.self is String?.Type ||
                T.self is Data.Type || T.self is Data?.Type
            {
                let value = self.userDefaults.object(forKey: self.key) as? T ?? self.defaultValue
                Logger.fail(value)
                return value
            } else if let Type = T.self as? Decodable.Type, let data = self.userDefaults.data(forKey: self.key) {
                if let value = try? JSONDecoder().decode(Type, from: data) as? T {
                    return value
                } else {
                    Logger.fail("⚠️ 解码失败")
                }
            }
            return self.defaultValue
        }
        set {
            if let value = newValue as? Bool {
                self.userDefaults.set(value, forKey: self.key)
            } else if let value = newValue as? Int {
                self.userDefaults.set(value, forKey: self.key)
            } else if let value = newValue as? UInt {
                self.userDefaults.set(value, forKey: self.key)
            } else if let value = newValue as? Float {
                self.userDefaults.set(value, forKey: self.key)
            } else if let value = newValue as? Double {
                self.userDefaults.set(value, forKey: self.key)
            } else if let value = newValue as? String {
                self.userDefaults.set(value, forKey: self.key)
            } else if let value = newValue as? Data {
                self.userDefaults.set(value, forKey: self.key)
            } else if let value = newValue as? Encodable {
                do {
                    let value = try JSONEncoder().encode(value)
                    userDefaults.set(value, forKey: key)
                } catch {
                    Logger.fail("⚠️ 编码失败")
                }
            } else {
                Logger.fail("⚠️ 编码失败")
            }
        }
    }
}
