//
//  Codable++.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - Encodable
public extension Encodable {
    /// 将遵守`Encodable`协议的对象序列化为`[String: Any]`
    /// - Returns: `[String: Any]`
    func dd_JSONObject() -> [String: Any]? {
        guard let data = self.dd_Data() else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            return nil
        }
    }

    /// 将遵守`Encodable`协议的对象序列化为`String`类型数据
    /// - Returns: `String`类型数据
    func dd_String() -> String? {
        if let data = self.dd_Data() {
            return data.dd_String()
        }
        return nil
    }

    /// 将遵守`Encodable`协议的对象序列化为`Data`
    /// - Returns: `Data`
    func dd_Data() -> Data? {
        return self.dd_encode()
    }

    /// 将遵守`Encodable`协议的对象序列化为`Data`
    /// - Parameter encoder: 编码器
    /// - Returns: `Data`
    func dd_encode(encoder: JSONEncoder = .init()) -> Data? {
        do {
            return try encoder.encode(self)
        } catch let err {
            return nil
        }
    }
}

// MARK: - Decodable
public extension Decodable {
    /// 将`[String: Any]`反序列化为遵守`Decodable`协议的模型对象
    /// - Parameter dictionary: 要反序列化的`[String: Any]`
    /// - Returns: 遵守`Decodable`协议的模型对象
    static func dd_model(_ dictionary: [String: Any]?) -> Self? where Self: Decodable {
        guard let dictionary else { return nil }
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary)
            return self.dd_model(data)
        } catch {
            return nil
        }
    }

    /// 将`String`反序列化为遵守`Decodable`协议的模型对象
    /// - Parameter string: 要反序列化的`String`
    /// - Returns: 遵守`Decodable`协议的模型对象
    static func dd_model(_ string: String?) -> Self? where Self: Decodable {
        if let data = string?.dd_Data() {
            return self.dd_model(data)
        }
        return nil
    }

    /// 将`Data`反序列化为遵守`Decodable`协议的模型对象
    /// - Parameter data: 要反序列化的`Data`
    /// - Returns: 遵守`Decodable`协议的模型对象
    static func dd_model(_ data: Data?) -> Self? where Self: Decodable {
        if let data {
            return self.dd_decode(from: data)
        }
        return nil
    }

    /// 将`Data`反序列化为遵守`Decodable`协议的模型对象
    /// - Parameters:
    ///   - data: 要反序列化的`Data`
    ///   - decoder: 解码器
    /// - Returns: 遵守`Decodable`协议的模型对象
    static func dd_decode(from data: Data, decoder: JSONDecoder = .init()) -> Self? {
        do {
            return try decoder.decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
}
