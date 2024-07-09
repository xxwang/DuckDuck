//
//  UIColor+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 链式语法
public extension UIColor {
    /// 设置颜色透明度
    /// - Parameter value:要设置的透明度
    /// - Returns:`UIColor`
    func dd_withAlphaComponent(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
}
