//
//  Data++.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 类型转换
public extension Data {
    /// 以字节数组的形式返回数据
    /// - Returns: `[UInt8]`
    func dd_bytes() -> [UInt8] {
        return [UInt8](self)
    }

    /// `Data`转`十六进制字符串`
    /// - Returns: `十六进制字符串`
    func dd_hexString() -> String {
        let result = self.withUnsafeBytes { rawPointer -> String in
            let unsafeBufferPointer = rawPointer.bindMemory(to: UInt8.self)
            let bytes = unsafeBufferPointer.baseAddress!
            let buffer = UnsafeBufferPointer(start: bytes, count: self.count)
            return buffer.map { String(format: "%02hhx", $0) }.reduce("") { $0 + $1 }.uppercased()
        }
        return result
    }

    /// `Data`转`UIImage`图片
    /// - Returns: `UIImage?`
    func dd_UIImage() -> UIImage? {
        return UIImage(data: self)
    }
}

// MARK: - 方法
public extension Data {
    /// 获取指定位置及长度的`Data`数据
    /// - Parameters:
    ///   - start: 开始位置
    ///   - len: 长度
    /// - Returns: `Data`
    func dd_subData(start: Int, len: Int) -> Data? {
        guard start >= 0, len >= 0 else { return nil }
        guard self.count >= start + len else { return nil }

        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: start + len)
        let range = startIndex ..< endIndex
        return self[range]
    }

    /// 获取资源的后缀名
    /// - Returns: 文件后缀名
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
    func dd_base64Encoded() -> Data? {
        return self.base64EncodedData()
    }

    /// `Data base64`解码
    func dd_base64Decoded() -> Data? {
        return Data(base64Encoded: self)
    }
}

// MARK: - JSON
public extension Data {
    /// 将`Data`转成`JSON对象格式`数据
    /// - Parameters:
    ///   - name: 目标类型如:`[String:Any].self`
    ///   - options: 选项
    /// - Returns: `JSON对象格式`数据
    func dd_JSONObject<T>(for name: T.Type = Any.self, options: JSONSerialization.ReadingOptions = []) -> T? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: options)
            return jsonObject as? T
        } catch {
            return nil
        }
    }

    /// 将`Data`转为`指定编码的字符串`
    /// - Parameter encoding: 编码格式
    /// - Returns: `指定编码的字符串`
    func dd_String(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
}
