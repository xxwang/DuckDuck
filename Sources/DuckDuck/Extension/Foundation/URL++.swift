//
//  URL++.swift
//  DuckDuck
//
//  Created by xxwang on 22/11/2024.
//

import AVFoundation
import UIKit

// MARK: - 构造方法
public extension URL {
    /// 使用基础`URL`和`路径字符串`初始化`URL`对象
    /// - Parameters:
    ///   - string: `URL`路径
    ///   - url: 基础`URL`
    /// - Returns: 初始化后的`URL`对象
    ///
    /// 示例：
    /// ```swift
    /// let baseURL = URL(string: "https://example.com")!
    /// let fullURL = URL(path: "/path/to/resource", base: baseURL)
    /// // 返回 "https://example.com/path/to/resource"
    /// ```
    init?(path string: String?, base url: URL? = nil) {
        guard let string else { return nil }
        self.init(string: string, relativeTo: url)
    }
}

// MARK: - 方法
public extension URL {
    /// 检测应用是否能打开这个`URL`
    /// - Returns: `Bool`，如果能打开返回`true`
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://example.com")!
    /// let canOpen = url.dd_isValid()
    /// print(canOpen) // prints true or false
    /// ```
    @MainActor func dd_isValid() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }

    /// 判断 URL 是否使用 HTTPS 协议
    /// - Returns: 如果是 HTTPS 协议，返回 `true`，否则返回 `false`
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com")!
    ///     print(url.dd_isHTTPS()) // 输出 true
    ///     ```
    func dd_isHTTPS() -> Bool {
        return self.scheme == "https"
    }

    /// 判断 URL 是否指向本地文件
    /// - Returns: 如果是文件 URL 返回 `true`，否则返回 `false`
    /// - Example:
    ///     ```swift
    ///     let url = URL(fileURLWithPath: "/path/to/file.txt")
    ///     print(url.dd_isFileURL()) // 输出 true
    ///     ```
    func dd_isFileURL() -> Bool {
        return self.isFileURL
    }

    /// 以字典形式返回`URL`的参数
    /// - Returns: 参数字典，包含`URL`中的查询项
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://example.com?q=swift&lang=en")!
    /// let params = url.dd_parameters()
    /// print(params) // prints ["q": "swift", "lang": "en"]
    /// ```
    func dd_parameters() -> [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

    /// 给`URL`添加参数列表,并返回`URL`
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://google.com")!
    /// let params = ["q": "Swifter Swift"]
    /// let updatedURL = url.dd_appendParameters(params)
    /// print(updatedURL) // prints "https://google.com?q=Swifter%20Swift"
    /// ```
    /// - Parameter parameters: 参数列表
    /// - Returns: 带参数列表的`URL`
    func dd_appendParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        return urlComponents.url!
    }

    /// 给`URL`添加参数列表
    ///
    /// 示例：
    /// ```swift
    /// var url = URL(string: "https://google.com")!
    /// let params = ["q": "Swifter Swift"]
    /// url.dd_appendParameters(params)
    /// print(url) // prints "https://google.com?q=Swifter%20Swift"
    /// ```
    /// - Parameter parameters: 参数列表
    mutating func dd_appendParameters(_ parameters: [String: String]) {
        self = self.dd_appendParameters(parameters)
    }

    /// 获取查询参数中键对应的值
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://google.com?code=12345")!
    /// let value = url.dd_queryValue(for: "code")
    /// print(value) // prints "12345"
    /// ```
    /// - Parameter key: 键
    /// - Returns: 参数字符串
    func dd_queryValue(for key: String) -> String? {
        return URLComponents(string: self.absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// 删除所有路径组件返回新`URL`
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://domain.com/path/other")!
    /// let newURL = url.dd_deleteAllPathComponents()
    /// print(newURL) // prints "https://domain.com/"
    /// ```
    /// - Returns: 结果`URL`
    func dd_deleteAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0 ..< self.pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// 从`URL`中删除所有路径组件
    ///
    /// 示例：
    /// ```swift
    /// var url = URL(string: "https://domain.com/path/other")!
    /// url.dd_deleteAllPathComponents()
    /// print(url) // prints "https://domain.com/"
    /// ```
    mutating func dd_deleteAllPathComponents() {
        for _ in 0 ..< self.pathComponents.count - 1 {
            self.deleteLastPathComponent()
        }
    }

    /// 删除`URL`中的协议部分
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://domain.com")!
    /// let droppedURL = url.dd_droppedScheme()
    /// print(droppedURL) // prints "domain.com"
    /// ```
    /// - Returns: 新的`URL`
    func dd_droppedScheme() -> URL? {
        if let scheme = self.scheme {
            let droppedScheme = String(self.absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }
        guard self.host != nil else { return self }
        let droppedScheme = String(self.absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    /// 根据视频`URL`在指定时间`秒`截取图像
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    /// var thumbnail = await url.dd_thumbnail()
    /// thumbnail = await url.dd_thumbnail(from: 5) // 截取5秒处的图像
    /// ```
    /// - Parameter time: 需要生成图片的视频的时间`秒`
    /// - Returns: 截取的图片
    /// 使用异步方式从视频 URL 获取缩略图
    /// - Parameter time: 截取缩略图的时间，单位为秒
    /// - Returns: 截取的图像（`UIImage`），如果失败则返回 `nil`
    @MainActor
    func dd_thumbnail(from time: Float64 = 0) async -> UIImage? {
        let urlAsset = AVURLAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: urlAsset)

        let cmTime = CMTime(seconds: time, preferredTimescale: 600)

        // 异步生成图像
        return await withCheckedContinuation { continuation in
            if #available(iOS 16.0, *) {
                imageGenerator.generateCGImageAsynchronously(for: cmTime) { cgImage, actualTime, error in
                    if let cgImage, error == nil {
                        // 如果成功，返回生成的图像
                        continuation.resume(returning: UIImage(cgImage: cgImage))
                    } else {
                        // 如果失败，返回 `nil`
                        continuation.resume(returning: nil)
                    }
                }
            } else {
                var actualTime = CMTimeMake(value: 0, timescale: 0)
                guard let cgImage = try? imageGenerator.copyCGImage(at: cmTime, actualTime: &actualTime) else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: UIImage(cgImage: cgImage))
            }
        }
    }
}

public extension URL {
    /// 获取 URL 的主机（域名）部分
    /// - Returns: 主机名（域名），如果没有主机部分则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com")!
    ///     print(url.dd_hostName()) // 输出 "www.example.com"
    ///     ```
    func dd_hostName() -> String? {
        return self.host
    }

    /// 获取 URL 的文件名（最后一个路径组件）
    /// - Returns: 文件名
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com/path/to/file.txt")!
    ///     print(url.dd_filename()) // 输出 "file.txt"
    ///     ```
    func dd_filename() -> String {
        return self.lastPathComponent
    }

    /// 获取 URL 的文件扩展名
    /// - Returns: 文件的扩展名，如果没有扩展名则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com/path/to/file.txt")!
    ///     print(url.dd_fileExtension()) // 输出 "txt"
    ///     ```
    func dd_fileExtension() -> String? {
        return self.pathExtension
    }

    /// 根据 URL 的文件扩展名获取 MIME 类型
    /// - Returns: 文件的 MIME 类型，如果无法识别扩展名则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com/file.jpg")!
    ///     print(url.dd_mimeType()) // 输出 "image/jpeg"
    ///     ```
    func dd_mimeType() -> String? {
        let fileExtension = self.pathExtension.lowercased()
        let type = UTType(filenameExtension: fileExtension)
        return type?.preferredMIMEType
    }

    /// 将 URL 指向的文件内容转换为 `Data`
    /// - Returns: 文件的 `Data`，如果无法读取文件则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com/file.txt")!
    ///     if let data = url.dd_toData() {
    ///         print("File Data: \(data)")
    ///     } else {
    ///         print("Failed to load data")
    ///     }
    ///     ```
    func dd_toData() -> Data? {
        return try? Data(contentsOf: self)
    }

    /// 将 URL 转换为 Base64 编码字符串
    /// - Returns: Base64 编码的字符串，如果编码失败则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com")!
    ///     print(url.dd_base64Encoded()) // 输出 Base64 编码字符串
    ///     ```
    func dd_base64Encoded() -> String? {
        return self.absoluteString.data(using: .utf8)?.base64EncodedString()
    }

    /// 获取 URL 指向文件的大小（字节数）
    /// - Returns: 文件大小（字节数），如果无法获取则返回 `nil`
    /// - Example:
    ///     ```swift
    ///     let url = URL(fileURLWithPath: "/path/to/file.txt")
    ///     if let size = url.dd_fileSize() {
    ///         print("File Size: \(size) bytes")
    ///     } else {
    ///         print("Failed to get file size")
    ///     }
    ///     ```
    func dd_fileSize() -> Int64? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: self.path)
        return attributes?[.size] as? Int64
    }

    /// 合并当前 URL 的查询参数与新的参数列表
    /// - Parameter parameters: 新的查询参数字典
    /// - Returns: 合并后的新的 URL
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com?search=swift")!
    ///     let newURL = url.dd_mergeParameters(with: ["page": "1"])
    ///     print(newURL) // 输出 "https://www.example.com?search=swift&page=1"
    ///     ```
    func dd_mergeParameters(with parameters: [String: String]) -> URL {
        return self.dd_appendParameters(parameters)
    }

    /// 删除 URL 中指定的查询参数
    /// - Parameter key: 要删除的查询参数的键
    /// - Returns: 删除指定参数后的新 URL
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com?search=swift&page=1")!
    ///     let newURL = url.dd_removeQueryParameter(for: "page")
    ///     print(newURL) // 输出 "https://www.example.com?search=swift"
    ///     ```
    func dd_removeQueryParameter(for key: String) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = urlComponents.queryItems?.filter { $0.name != key }
        return urlComponents.url!
    }

    /// 获取 URL 的各个组件（如 scheme, host, path, query 等）
    /// - Returns: 各个组件组成的字典
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com/path?query=value")!
    ///     let components = url.dd_components()
    ///     print(components) // 输出 ["scheme": "https", "host": "www.example.com", "path": "/path", "query": "query=value"]
    ///     ```
    func dd_components() -> [String: String?] {
        return [
            "scheme": self.scheme,
            "host": self.host,
            "path": self.path,
            "query": self.query,
        ]
    }

    /// 获取 URL 的所有路径组件（去掉 `/` 斜杠）
    /// - Returns: 路径组件数组
    /// - Example:
    ///     ```swift
    ///     let url = URL(string: "https://www.example.com/path/to/file")!
    ///     print(url.dd_pathComponentsList()) // 输出 ["path", "to", "file"]
    ///     ```
    func dd_pathComponentsList() -> [String] {
        return self.pathComponents.filter { $0 != "/" }
    }
}

// MARK: - 链式语法
public extension URL {
    /// 向`URL`中追加路径
    /// - Parameter path: 要追加的路径
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://domain.com")!
    /// let newURL = url.dd_appendingPathComponent("path/to/resource")
    /// print(newURL) // prints "https://domain.com/path/to/resource"
    /// ```
    func dd_appendingPathComponent(_ path: String) -> Self {
        if #available(iOS 16.0, *) {
            return self.appending(component: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }
}
