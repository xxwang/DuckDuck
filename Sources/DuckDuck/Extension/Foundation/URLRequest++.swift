//
//  URLRequest++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 22/11/2024.
//

import Foundation

// MARK: - 类型转换
public extension URLRequest {
    /// 将`URLRequest`转换为`cURL`命令表示形式
    /// - Returns: 返回 `cURL` 命令字符串
    /// - Example:
    /// ```swift
    /// let request = URLRequest(url: URL(string: "https://example.com")!)
    /// let curlCommand = request.dd_toCURL()
    /// print(curlCommand)
    /// ```
    func dd_toCURL() -> String {
        guard let url = self.url else { return "" }

        var baseCommand = "curl \(url.absoluteString)"
        if self.httpMethod == "HEAD" { baseCommand += " --head" }

        var command = [baseCommand]
        if let method = self.httpMethod, method != "GET", method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key):\(value)'")
            }
        }
        if let data = self.httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}

// MARK: - 构造方法
public extension URLRequest {
    /// 使用`URL`字符串构建`URLRequest`
    /// - Parameter urlString: `URL`字符串
    /// - Returns: 构建的 `URLRequest` 或 `nil` 如果无效
    /// - Example:
    /// ```swift
    /// if let request = URLRequest(string: "https://example.com") {
    ///     print(request)
    /// }
    /// ```
    init?(string urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(url: url)
    }
}
