import Foundation

// MARK: - Encodable
public extension Encodable {
    /// 转换当前对象为 JSON 字典
    ///
    /// - Example:
    /// ```swift
    /// struct User: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let user = User(id: 1, name: "John")
    /// if let jsonDict = user.dd_toJSONDictionary() {
    ///     print(jsonDict) // ["id": 1, "name": "John"]
    /// }
    /// ```
    func dd_toJSONDictionary(encoder: JSONEncoder = JSONEncoder()) -> [String: Any]? {
        guard let data = self.dd_toJSONData(encoder: encoder) else {
            Logger.fail("转换为 JSON 数据失败：对象无法序列化为 Data。")
            return nil
        }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            Logger.fail("转换为 JSON 字典失败：无法将 Data 转换为 [String: Any] 格式。")
            return nil
        }
        return dictionary
    }

    /// 转换当前对象为 JSON 数据
    ///
    /// - Example:
    /// ```swift
    /// struct User: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let user = User(id: 1, name: "John")
    /// if let jsonData = user.dd_toJSONData() {
    ///     print(jsonData) // JSON 数据对象
    /// }
    /// ```
    func dd_toJSONData(encoder: JSONEncoder = JSONEncoder()) -> Data? {
        do {
            return try encoder.encode(self)
        } catch {
            Logger.fail("JSON 编码错误：\(error.localizedDescription)")
            return nil
        }
    }

    /// 转换当前对象为 JSON 字符串
    ///
    /// - Example:
    /// ```swift
    /// struct User: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let user = User(id: 1, name: "John")
    /// if let jsonString = user.dd_toJSONString() {
    ///     print(jsonString) // "{"id":1,"name":"John"}"
    /// }
    /// ```
    func dd_toJSONString(encoder: JSONEncoder = JSONEncoder()) -> String? {
        guard let data = self.dd_toJSONData(encoder: encoder) else {
            Logger.fail("转换为 JSON 数据失败：对象无法序列化为 Data。")
            return nil
        }
        guard let jsonString = String(data: data, encoding: .utf8) else {
            Logger.fail("转换为 JSON 字符串失败：Data 无法编码为 UTF-8 格式的字符串。")
            return nil
        }
        return jsonString
    }
}

// MARK: - Decodable
public extension Decodable {
    /// 从 JSON 字典创建对象
    ///
    /// - Example:
    /// ```swift
    /// struct User: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let jsonDict: [String: Any] = ["id": 1, "name": "John"]
    /// if let user = User.dd_fromJSONDictionary(jsonDict) {
    ///     print(user) // User(id: 1, name: "John")
    /// }
    /// ```
    static func dd_fromJSONDictionary(_ dictionary: [String: Any], decoder: JSONDecoder = JSONDecoder()) -> Self? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else {
            Logger.fail("转换为 JSON 数据失败：无法将字典序列化为 Data。")
            return nil
        }
        return self.dd_fromJSONData(data, decoder: decoder)
    }

    /// 从 JSON 数据创建对象
    ///
    /// - Example:
    /// ```swift
    /// struct User: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let jsonData = "{\"id\": 1, \"name\": \"John\"}".data(using: .utf8)!
    /// if let user = User.dd_fromJSONData(jsonData) {
    ///     print(user) // User(id: 1, name: "John")
    /// }
    /// ```
    static func dd_fromJSONData(_ data: Data, decoder: JSONDecoder = JSONDecoder()) -> Self? {
        do {
            return try decoder.decode(Self.self, from: data)
        } catch {
            Logger.fail("JSON 解码错误：\(error.localizedDescription)")
            return nil
        }
    }

    /// 从 JSON 字符串创建对象
    ///
    /// - Example:
    /// ```swift
    /// struct User: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let jsonString = "{\"id\": 1, \"name\": \"John\"}"
    /// if let user = User.dd_fromJSONString(jsonString) {
    ///     print(user) // User(id: 1, name: "John")
    /// }
    /// ```
    static func dd_fromJSONString(_ jsonString: String, decoder: JSONDecoder = JSONDecoder()) -> Self? {
        guard let data = jsonString.data(using: .utf8) else {
            Logger.fail("转换为 JSON 数据失败：字符串无法编码为 Data。")
            return nil
        }
        return self.dd_fromJSONData(data, decoder: decoder)
    }
}
