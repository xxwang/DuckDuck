//
//  CGPath++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import CoreGraphics

// MARK: - 类型转换
public extension CGPath {
    /// 转换为可变路径
    ///
    /// 该方法将当前的 `CGPath` 转换为一个 `CGMutablePath` 对象，`CGMutablePath` 可以执行修改操作，如添加、删除路径元素等。
    ///
    /// - Returns: 返回一个新的 `CGMutablePath`，它包含当前 `CGPath` 的所有路径数据。
    ///
    /// - Example:
    ///     ```swift
    ///     let path = CGPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100), transform: nil)
    ///     let mutablePath = path.dd_toCGMutablePath()
    ///     print(mutablePath) // 输出: CGMutablePath包含与path相同的路径数据
    ///     ```
    func dd_toCGMutablePath() -> CGMutablePath {
        return CGMutablePath().dd_add(path: self)
    }
}
