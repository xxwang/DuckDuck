//
//  UIViewController+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - 链式语法
public extension UIViewController {
    /// 设置控制用户界面样式(亮色/黑暗)
    /// - Parameter userInterfaceStyle: 用户界面样式
    /// - Returns: `Self`
    @discardableResult
    func dd_overrideUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> Self {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    /// 设置是否允许滚动视图自动缩进(iOS11以下版本)
    /// - Parameter automaticallyAdjustsScrollViewInsets: 是否
    /// - Returns: `Self`
    @discardableResult
    func dd_automaticallyAdjustsScrollViewInsets(_ automaticallyAdjustsScrollViewInsets: Bool) -> Self {
        if #available(iOS 11, *) {} else { // iOS11以下版本
            self.automaticallyAdjustsScrollViewInsets = automaticallyAdjustsScrollViewInsets
        }
        return self
    }

    /// 设置控制模态样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func dd_modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle = style
        return self
    }
}

// MARK: - view
public extension UIViewController {
    /// 设置控制器根视图背景颜色
    /// - Parameter backgroundColor: 要设置的背景颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.view.backgroundColor = backgroundColor
        return self
    }
}
