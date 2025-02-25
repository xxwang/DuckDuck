import Foundation

// MARK: - Encodable
public extension Encodable {
    /// 转换当前对象为`Data?`
    ///
    /// - Example:
    /// ```swift
    /// struct User: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let user = User(id: 1, name: "John")
    /// if let jsonData = user.dd_encode() {
    ///     print(jsonData) // JSON 数据对象
    /// }
    /// ```
    func dd_encode(encoder: JSONEncoder = JSONEncoder()) -> Data? {
        guard let data = try? encoder.encode(self) else {
            return nil
        }
        return data
    }
}

// MARK: - Decodable
public extension Decodable {
    /// 从 `Data?`创建对象
    ///
    /// - Example:
    /// ```swift
    /// struct User: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let data = Data()
    /// if let user = User.dd_decode(from: data) {
    ///     print(user) // nil
    /// }
    /// ```
    static func dd_decode(from data: Data?, decoder: JSONDecoder = JSONDecoder()) -> Self? {
        guard let data else { return nil }
        return try? decoder.decode(Self.self, from: data)
    }
}
