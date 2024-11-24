//
//  Data++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 18/11/2024.
//

import UIKit

// MARK: - 类型转换
public extension Data {
    /// 将 `Data` 转换为字节数组 `[UInt8]`
    ///
    /// - Returns: 返回一个字节数组 `[UInt8]`，即将 `Data` 中的每个字节转换为 `UInt8` 数值。
    ///
    /// - Example:
    /// ```swift
    /// let data = Data([0x01, 0x02, 0x03])
    /// let bytes = data.dd_toBytes()
    /// print(bytes)  // 输出: [1, 2, 3]
    /// ```
    func dd_toBytes() -> [UInt8] {
        return [UInt8](self)
    }

    /// 将 `Data` 转换为十六进制字符串
    ///
    /// - Returns: 返回 `Data` 转换后的十六进制字符串，所有字节都转换为两位十六进制表示，并转换为大写。
    ///
    /// - Example:
    /// ```swift
    /// let data = Data([0x01, 0x02, 0x03])
    /// let hexString = data.dd_toHexString()
    /// print(hexString)  // 输出: "010203"
    /// ```
    func dd_toHexString() -> String {
        let result = self.withUnsafeBytes { rawPointer -> String in
            let unsafeBufferPointer = rawPointer.bindMemory(to: UInt8.self)
            let bytes = unsafeBufferPointer.baseAddress!
            let buffer = UnsafeBufferPointer(start: bytes, count: self.count)
            return buffer.map { String(format: "%02hhx", $0) }.reduce("") { $0 + $1 }.uppercased()
        }
        return result
    }

    /// 将 `Data` 转换为 `UIImage` 图片
    ///
    /// - Returns: 返回一个 `UIImage?`，如果 `Data` 无法转为有效的图片则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// let data = Data(...)
    /// if let image = data.dd_toUIImage() {
    ///     print(image)
    /// } else {
    ///     print("无效图片数据")
    /// }
    /// ```
    func dd_toUIImage() -> UIImage? {
        return UIImage(data: self)
    }
}

// MARK: - 方法
public extension Data {
    /// 获取指定位置及长度的 `Data` 数据
    ///
    /// - Parameters:
    ///   - start: 起始位置，表示从哪个字节开始提取数据。
    ///   - len: 长度，表示提取的数据字节数。
    /// - Returns: 返回一个 `Data`，包含从 `start` 开始，长度为 `len` 的数据片段。如果起始位置或长度无效则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// let data = Data([0x01, 0x02, 0x03, 0x04, 0x05])
    /// if let subData = data.dd_subData(start: 1, len: 3) {
    ///     print(subData)  // 输出: 2, 3, 4
    /// }
    /// ```
    func dd_subData(start: Int, len: Int) -> Data? {
        guard start >= 0, len >= 0 else { return nil } // 确保起始位置和长度有效
        guard self.count >= start + len else { return nil } // 确保数据长度足够

        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: start + len)
        let range = startIndex ..< endIndex
        return self[range]
    }

    /// 获取资源的后缀名
    ///
    /// 根据文件的字节内容返回相应的后缀名。
    ///
    /// - Example:
    /// ```swift
    /// let data = Data([0x89, 0x50, 0x4E, 0x47])  // PNG 文件头
    /// let extension = data.dd_extension()
    /// print(extension)  // 输出: ".png"
    /// ```
    func dd_extension() -> String {
        let c = self[0]
        switch c {
        case 0xFF:
            return ".jpeg"
        case 0x89:
            return ".png"
        case 0x47:
            return ".gif"
        case 0x49, 0x4D:
            return ".tiff"
        default:
            return ".default"
        }
    }
}

// MARK: - base64
public extension Data {
    /// `Data base64`编码
    ///
    /// 将 `Data` 转换为 `Base64` 编码后的数据。
    ///
    /// - Example:
    /// ```swift
    /// let data = Data([0x01, 0x02, 0x03])
    /// if let encodedData = data.dd_base64Encoded() {
    ///     print(encodedData)  // 输出: "AQID"
    /// }
    /// ```
    func dd_base64Encoded() -> Data? {
        return self.base64EncodedData()
    }

    /// `Data base64`解码
    ///
    /// 将 `Base64` 编码的字符串解码为原始数据。
    ///
    /// - Example:
    /// ```swift
    /// let base64String = "AQID"
    /// if let decodedData = Data(base64Encoded: base64String) {
    ///     print(decodedData)  // 输出: [1, 2, 3]
    /// }
    /// ```
    func dd_base64Decoded() -> Data? {
        return Data(base64Encoded: self)
    }
}

// MARK: - JSON
public extension Data {
    /// 将 `Data` 转换为 `JSON` 对象格式数据
    ///
    /// 将 `Data` 解码为 `JSON` 对象。返回指定类型的 JSON 对象。
    ///
    /// - Parameters:
    ///   - name: 目标类型，默认类型为 `Any`，可以指定类型例如 `[String: Any].self`。
    ///   - options: JSON 解码选项。
    /// - Returns: 返回 JSON 对象，或者如果解码失败则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// let jsonData = Data("{\"name\": \"John\"}".utf8)
    /// if let jsonObject: [String: Any] = jsonData.dd_JSONObject() {
    ///     print(jsonObject)  // 输出: ["name": "John"]
    /// }
    /// ```
    func dd_JSONObject<T>(for name: T.Type = [String: Any].self, options: JSONSerialization.ReadingOptions = []) -> T? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: options)
            return jsonObject as? T
        } catch {
            return nil
        }
    }

    /// 将 `Data` 转换为指定编码的字符串
    ///
    /// - Parameter encoding: 字符串编码格式，默认是 `.utf8`。
    /// - Returns: 返回解码后的字符串，如果无法解码则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// let data = "Hello".data(using: .utf8)!
    /// let string = data.dd_String()
    /// print(string)  // 输出: "Hello"
    /// ```
    func dd_String(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
}
