//
//  Data+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

extension Data: DDExtensionable {}

public extension DDExtension where Base == Data {
    /// `Data`转`UIImage`
    var as2UIImage: UIImage? {
        return UIImage(data: self.base)
    }

    /// 以字节数组的形式返回数据
    var bytes: [UInt8] {
        return [UInt8](self.base)
    }

    /// `Data`转`十六进制字符串`
    /// - Returns: `String`
    func as2HexString() -> String {
        let result = self.base.withUnsafeBytes { rawPointer -> String in
            let unsafeBufferPointer = rawPointer.bindMemory(to: UInt8.self)
            let bytes = unsafeBufferPointer.baseAddress!
            let buffer = UnsafeBufferPointer(start: bytes, count: self.base.count)
            return buffer.map { String(format: "%02hhx", $0) }.reduce("") { $0 + $1 }.uppercased()
        }
        return result
    }

    /// `Data base64`编码
    var base64Encoded: Data? {
        return self.base.base64EncodedData()
    }

    /// `Data base64`解码
    var base64Decoded: Data? {
        return Data(base64Encoded: self.base)
    }
}

// MARK: - 方法
public extension DDExtension where Base == Data {
    /// 将`Data`转为`指定编码的字符串`
    /// - Parameter encoding: 编码格式
    /// - Returns: 对应字符串
    func string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self.base, encoding: encoding)
    }

    /// 截取指定长度`Data`
    /// - Parameters:
    ///   - start: 开始位置
    ///   - len: 截取长度
    /// - Returns: 截取的`Data`
    func subData(start: Int, len: Int) -> Data? {
        guard start >= 0, len >= 0 else { return nil }
        guard self.base.count >= start + len else { return nil }

        let startIndex = self.base.index(self.base.startIndex, offsetBy: start)
        let endIndex = self.base.index(self.base.startIndex, offsetBy: start + len)
        let range = startIndex ..< endIndex
        return self.base[range]
    }
}

// MARK: - 常用方法
public extension DDExtension where Base == Data {
    /// 获取资源格式
    /// - Returns: 格式
    func imageFormat() -> String {
        let c = self.base[0]
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
