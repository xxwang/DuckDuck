//
//  UIPageControl+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - 链式语法
public extension UIPageControl {
    /// 设置当前选中指示器颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_currentPageIndicatorTintColor(_ color: UIColor) -> Self {
        self.currentPageIndicatorTintColor = color
        return self
    }

    /// 设置没有选中时的指示器颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_pageIndicatorTintColor(_ color: UIColor) -> Self {
        self.pageIndicatorTintColor = color
        return self
    }

    /// 只有一页的时候是否隐藏分页指示器
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func dd_hidesForSinglePage(_ isHidden: Bool) -> Self {
        self.hidesForSinglePage = isHidden
        return self
    }

    /// 设置当前页码
    /// - Parameter current: 当前页码
    /// - Returns: `Self`
    @discardableResult
    func dd_currentPage(_ current: Int) -> Self {
        self.currentPage = current
        return self
    }

    /// 设置总页数
    /// - Parameter count: 总页数
    /// - Returns: `Self`
    @discardableResult
    func dd_numberOfPages(_ count: Int) -> Self {
        self.numberOfPages = count
        return self
    }
}
