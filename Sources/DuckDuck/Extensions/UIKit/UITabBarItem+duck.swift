//
//  UITabBarItem+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 链式语法
public extension UITabBarItem {
    /// 设置标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func dd_title(_ title: String) -> Self {
        self.title = title
        return self
    }

    /// 设置默认图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func dd_image(_ image: UIImage) -> Self {
        self.image = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置选中图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func dd_selectedImage(_ image: UIImage) -> Self {
        self.selectedImage = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置`badgeColor`颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func dd_badgeColor(_ color: UIColor) -> Self {
        self.badgeColor = color
        return self
    }

    /// 设置`badgeValue`值
    /// - Parameter value:值
    /// - Returns:`Self`
    @discardableResult
    func dd_badgeValue(_ value: String) -> Self {
        self.badgeValue = value
        return self
    }
}
