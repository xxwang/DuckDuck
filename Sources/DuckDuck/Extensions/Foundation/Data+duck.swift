//
//  Data+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 类型转换
public extension Data {
    /// `Data`转`UIImage`
    func dd_UIImage() -> UIImage? {
        return UIImage(data: self)
    }

    /// 以字节数组的形式返回数据
    func dd_bytes() -> [UInt8] {
        return [UInt8](self)
    }

    /// `Data`转`十六进制字符串`
    /// - Returns: `String`
    func dd_hexString() -> String {
        let result = self.withUnsafeBytes { rawPointer -> String in
            let unsafeBufferPointer = rawPointer.bindMemory(to: UInt8.self)
            let bytes = unsafeBufferPointer.baseAddress!
            let buffer = UnsafeBufferPointer(start: bytes, count: self.count)
            return buffer.map { String(format: "%02hhx", $0) }.reduce("") { $0 + $1 }.uppercased()
        }
        return result
    }

    /// `Data base64`编码
    func dd_base64Encoded() -> Data? {
        return self.base64EncodedData()
    }

    /// `Data base64`解码
    func dd_base64Decoded() -> Data? {
        return Data(base64Encoded: self)
    }
}

// MARK: - 方法
public extension Data {
    /// 将`Data`转为`指定编码的字符串`
    /// - Parameter encoding: 编码格式
    /// - Returns: 对应字符串
    func dd_string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }

    /// 截取指定长度`Data`
    /// - Parameters:
    ///   - start: 开始位置
    ///   - len: 截取长度
    /// - Returns: 截取的`Data`
    func dd_subData(start: Int, len: Int) -> Data? {
        guard start >= 0, len >= 0 else { return nil }
        guard self.count >= start + len else { return nil }

        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: start + len)
        let range = startIndex ..< endIndex
        return self[range]
    }
}

// MARK: - 常用方法
public extension Data {
    /// 获取资源格式
    /// - Returns: 格式
    func dd_imageFormat() -> String {
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
