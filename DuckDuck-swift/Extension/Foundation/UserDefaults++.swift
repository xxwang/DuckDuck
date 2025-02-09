import Foundation

// MARK: - UserDefaults 扩展方法
public extension UserDefaults {
    /// 保存遵守`Codable`协议的对象到`UserDefaults`
    /// - Parameters:
    ///   - object: 要存储的对象
    ///   - key: 存取数据使用的`关键字`
    ///   - encoder: 编码器（默认为`JSONEncoder`）
    /// - Returns: 操作是否成功
    /// - Example:
    /// ```swift
    /// let user = User(name: "John", age: 30)
    /// UserDefaults.standard.dd_set(user, for: "userKey")
    /// ```
    func dd_set(_ object: (some Codable)?, for key: String?, using encoder: JSONEncoder = JSONEncoder()) {
        guard let key else { return }
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
        self.synchronize()
    }

    /// 从`UserDefaults`检索遵守`Codable`的对象
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: 存取数据使用的`关键字`
    ///   - decoder: 解码器（默认为`JSONDecoder`）
    /// - Returns: 遵守`Codable`的对象
    /// - Example:
    /// ```swift
    /// let user: User? = UserDefaults.standard.dd_object(User.self, for: "userKey")
    /// ```
    func dd_object<T: Codable>(_ type: T.Type, for key: String?, using decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let key, let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    /// 从`UserDefaults`中移除当前应用存储的所有数据
    /// - Example:
    /// ```swift
    /// UserDefaults.standard.dd_clearAll()  // 清除所有存储的数据
    /// ```
    func dd_clearAll() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }

    /// 检查某个键是否存在于 `UserDefaults` 中
    /// - Parameter key: 存储数据的 `关键字`
    /// - Returns: `Bool`，如果存在则返回 `true`
    /// - Example:
    /// ```swift
    /// let exists = UserDefaults.standard.dd_contains(key: "userKey")
    /// print(exists) // 输出 `true` 或 `false`
    /// ```
    func dd_contains(key: String) -> Bool {
        return self.object(forKey: key) != nil
    }

    /// 从 `UserDefaults` 获取指定类型的数据
    /// - Parameters:
    ///   - key: 存储数据的 `关键字`
    ///   - type: 数据类型
    /// - Returns: 对应类型的数据，若没有则返回 `nil`
    /// - Example:
    /// ```swift
    /// let userName: String? = UserDefaults.standard.dd_object(for: "userName", type: String.self)
    /// ```
    func dd_object<T>(for key: String, type: T.Type) -> T? {
        return self.value(forKey: key) as? T
    }

    /// 删除 `UserDefaults` 中指定键的数据
    /// - Parameter key: 存储数据的 `关键字`
    /// - Example:
    /// ```swift
    /// UserDefaults.standard.dd_remove(for: "userKey")  // 删除存储的 "userKey" 数据
    /// ```
    func dd_remove(for key: String) {
        self.removeObject(forKey: key)
    }

    /// 删除所有具有特定前缀的 `UserDefaults` 键
    /// - Parameter prefix: 键的前缀
    /// - Example:
    /// ```swift
    /// UserDefaults.standard.dd_clearKeysWithPrefix("temp_")  // 删除所有前缀为 "temp_" 的键值对
    /// ```
    func dd_clearKeysWithPrefix(_ prefix: String) {
        let keys = self.dictionaryRepresentation().keys.filter { $0.hasPrefix(prefix) }
        keys.forEach { self.removeObject(forKey: $0) }
    }

    /// 设置带有过期时间的对象
    /// - Parameters:
    ///   - object: 要存储的对象
    ///   - key: 存储数据的 `关键字`
    ///   - expiration: 过期时间，单位为秒
    /// - Example:
    /// ```swift
    /// let user = User(name: "John", age: 30)
    /// UserDefaults.standard.dd_setWithExpiration(user, for: "userKey", expiration: 3600)  // 1小时后过期
    /// ```
    func dd_setWithExpiration(_ object: (some Codable)?, for key: String?, expiration: TimeInterval) {
        guard let key else { return }
        let expirationDate = Date().addingTimeInterval(expiration)
        var data: [String: Any] = [:]
        data["value"] = object
        data["expirationDate"] = expirationDate
        self.set(data, forKey: key)
        self.synchronize()
    }

    /// 获取存储的数据，并判断是否过期
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: 存储数据的 `关键字`
    /// - Returns: 返回存储的对象，如果没有或已过期则返回 `nil`
    /// - Example:
    /// ```swift
    /// if let user: User = UserDefaults.standard.dd_objectWithExpiration(User.self, for: "userKey") {
    ///     print(user.name)  // 输出存储的用户信息
    /// } else {
    ///     print("数据过期或不存在")
    /// }
    /// ```
    func dd_objectWithExpiration<T: Codable>(_ type: T.Type, for key: String?) -> T? {
        guard let key, let data = self.value(forKey: key) as? [String: Any],
              let expirationDate = data["expirationDate"] as? Date else { return nil }

        if expirationDate < Date() {
            // 数据已过期，移除
            self.removeObject(forKey: key)
            return nil
        }

        if let value = data["value"] as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: value)
        }

        return nil
    }

    /// 批量存储多个键值对到 `UserDefaults`
    /// - Parameter dictionary: 键值对字典
    /// - Example:
    /// ```swift
    /// UserDefaults.standard.dd_setBatch(["userName": "John", "isLoggedIn": true, "userAge": 30])
    /// ```
    func dd_setBatch(_ dictionary: [String: Any?]) {
        for (key, value) in dictionary {
            if let value {
                self.set(value, forKey: key)
            } else {
                self.removeObject(forKey: key)
            }
        }
        self.synchronize()
    }

    /// 批量读取多个键值对
    /// - Parameter keys: 键数组
    /// - Returns: 返回键值对字典
    /// - Example:
    /// ```swift
    /// let values = UserDefaults.standard.dd_getBatch(for: ["userName", "isLoggedIn"])
    /// print(values)  // 输出 ["userName": "John", "isLoggedIn": true]
    /// ```
    func dd_getBatch(for keys: [String]) -> [String: Any?] {
        var result: [String: Any?] = [:]
        for key in keys {
            result[key] = self.value(forKey: key)
        }
        return result
    }
}
