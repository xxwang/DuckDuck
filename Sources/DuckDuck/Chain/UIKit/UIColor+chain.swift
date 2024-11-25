//
//  UIColor+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIColor {
    /// 设置颜色的透明度（链式调用）
    /// - Parameter alpha: 透明度（范围 0.0 ~ 1.0）
    /// - Returns: 透明度调整后的 `UIColor`
    ///
    /// 示例：
    /// ```swift
    /// let semiTransparentRed = UIColor.red.dd.alpha(0.5)
    /// ```
    func alpha(_ alpha: CGFloat) -> UIColor {
        return self.base.withAlphaComponent(alpha)
    }
}
