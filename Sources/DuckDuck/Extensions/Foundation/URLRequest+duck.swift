//
//  URLRequest+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 类型转换
public extension URLRequest {
    /// 将`URLRequest`转换为`cURL`命令表示形式
    func dd_CURL() -> String {
        guard let url = self.url else { return "" }

        var baseCommand = "curl \(url.absoluteString)"
        if self.httpMethod == "HEAD" { baseCommand += " --head" }

        var command = [baseCommand]
        if let method = self.httpMethod, method != "GET", method != "HEAD" { command.append("-X \(method)") }

        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key):\(value)'")
            }
        }
        if let data = self.httpBody, let body = String(data: data, encoding: .utf8) { command.append("-d '\(body)'") }

        return command.joined(separator: " \\\n\t")
    }
}

// MARK: - 构造方法
public extension URLRequest {
    /// 使用`URL`字符串构建`URLRequest`
    /// - Parameter urlString: URL`字符串
    init?(string urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(url: url)
    }
}
