//
//  UINavigationController+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 链式语法
public extension UINavigationController {
    /// 设置导航控制器代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func dd_delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 隐藏导航栏
    /// - Parameters:
    ///   - hidden: 是否隐藏
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dd_setNavigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.setNavigationBarHidden(hidden, animated: animated)
        return self
    }
}
