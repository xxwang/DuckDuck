import Foundation

// MARK: - UserStorage
@propertyWrapper
public struct UserStorage<T: Codable> {
    private let userDefaults: UserDefaults
    private let key: String
    private let defaultValue: T

    /// 包装的属性值
    public var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }
            do {
                let decodedValue = try JSONDecoder().decode(T.self, from: data)
                return decodedValue
            } catch {
                Logger.fail("⚠️ 解码失败，返回默认值。错误：\(error.localizedDescription)")
                return defaultValue
            }
        }
        set {
            do {
                let encodedValue = try JSONEncoder().encode(newValue)
                userDefaults.set(encodedValue, forKey: key)
            } catch {
                Logger.fail("⚠️ 编码失败，无法存储值。错误：\(error.localizedDescription)")
            }
        }
    }

    /// 初始化属性包装器
    /// - Parameters:
    ///   - key: 存储值的键
    ///   - defaultValue: 默认值
    ///   - userDefaults: 指定的 `UserDefaults` 实例，默认为 `.standard`
    /// - Example:
    /// ```swift
    /// @UserStorage("userProfile", defaultValue: UserProfile(name: "Default"))
    /// var userProfile: UserProfile
    /// ```
    public init(
        _ key: String,
        defaultValue: T,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [key: defaultValue])
    }
}
