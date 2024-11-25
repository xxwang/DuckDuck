//
//  URL+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import Foundation

extension URL: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base == URL {
    /// 向`URL`中追加路径
    /// - Parameter path: 要追加的路径
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let url = URL(string: "https://domain.com")!
    /// let newURL = url.dd.appendingPathComponent("path/to/resource")
    /// print(newURL) // prints "https://domain.com/path/to/resource"
    /// ```
    func appendingPathComponent(_ path: String) -> Self {
        if #available(iOS 16.0, *) {
            self.base = self.base.appending(component: path)
            return self
        } else {
            self.base = self.base.appendingPathComponent(path)
            return self
        }
    }
}
