//
//  UIEdgeInsets++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - 属性
public extension UIEdgeInsets {
    /// 返回水平方向的边距总和（左 + 右）
    /// - Returns: 水平方向的边距总和
    ///
    /// 示例:
    /// ```swift
    /// let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let horizontal = inset.dd_horizontal // 10
    /// ```
    var dd_horizontal: CGFloat {
        return self.left + self.right
    }

    /// 返回垂直方向的边距总和（上 + 下）
    /// - Returns: 垂直方向的边距总和
    ///
    /// 示例:
    /// ```swift
    /// let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let vertical = inset.dd_vertical // 20
    /// ```
    var dd_vertical: CGFloat {
        return self.top + self.bottom
    }
}

// MARK: - 构造方法
public extension UIEdgeInsets {
    /// 创建四个方向相等的`UIEdgeInsets`
    /// - Parameter inset: 用于四个方向的边距值
    /// - Returns: 一个新的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let inset = UIEdgeInsets(inset: 10)
    /// // 结果: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    /// ```
    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    /// 创建一个水平方向与垂直方向平分的`UIEdgeInsets`
    /// - Parameters:
    ///   - horizontal: 水平方向的边距
    ///   - vertical: 垂直方向的边距
    /// - Returns: 一个新的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let inset = UIEdgeInsets(horizontal: 20, vertical: 40)
    /// // 结果: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    /// ```
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical / 2, left: horizontal / 2, bottom: vertical / 2, right: horizontal / 2)
    }
}

// MARK: - 链式语法
public extension UIEdgeInsets {
    /// 基于当前值和顶部偏移创建新的`UIEdgeInsets`
    /// - Parameter top: 顶部的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let newInset = inset.dd_insetBy(top: 5)
    /// // 结果: UIEdgeInsets(top: 15, left: 5, bottom: 5, right: 5)
    /// ```
    @discardableResult
    func dd_insetBy(top: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top + top, left: self.left, bottom: self.bottom, right: self.right)
    }

    /// 基于当前值和左侧偏移创建新的`UIEdgeInsets`
    /// - Parameter left: 左侧的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd_insetBy(left: 10)
    /// // 结果: UIEdgeInsets(top: 10, left: 15, bottom: 5, right: 5)
    /// ```
    @discardableResult
    func dd_insetBy(left: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top, left: self.left + left, bottom: self.bottom, right: self.right)
    }

    /// 基于当前值和底部偏移创建新的`UIEdgeInsets`
    /// - Parameter bottom: 底部的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd_insetBy(bottom: 10)
    /// // 结果: UIEdgeInsets(top: 10, left: 5, bottom: 15, right: 5)
    /// ```
    @discardableResult
    func dd_insetBy(bottom: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom + bottom, right: self.right)
    }

    /// 基于当前值和右侧偏移创建新的`UIEdgeInsets`
    /// - Parameter right: 右侧的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd_insetBy(right: 15)
    /// // 结果: UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 20)
    /// ```
    @discardableResult
    func dd_insetBy(right: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right + right)
    }

    /// 基于当前值和水平值等分并应用于左右偏移，创建新的`UIEdgeInsets`
    /// - Parameter horizontal: 要应用于左侧和右侧的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd_insetBy(horizontal: 20)
    /// // 结果: UIEdgeInsets(top: 10, left: 15, bottom: 5, right: 25)
    /// ```
    @discardableResult
    func dd_insetBy(horizontal: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top, left: self.left + horizontal / 2, bottom: self.bottom, right: self.right + horizontal / 2)
    }

    /// 基于当前值和垂直值等分并应用于顶部和底部，创建新的`UIEdgeInsets`
    /// - Parameter vertical: 要应用于顶部和底部的偏移值
    /// - Returns: 偏移后的`UIEdgeInsets`
    ///
    /// 示例:
    /// ```swift
    /// let newInset = inset.dd_insetBy(vertical: 30)
    /// // 结果: UIEdgeInsets(top: 25, left: 5, bottom: 25, right: 5)
    /// ```
    @discardableResult
    func dd_insetBy(vertical: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top + vertical / 2, left: self.left, bottom: self.bottom + vertical / 2, right: self.right)
    }
}

// MARK: - 运算符重载
public extension UIEdgeInsets {
    /// 比较两个`UIEdgeInsets`是否相等
    /// - Returns: 如果两个`UIEdgeInsets`相等，返回`true`，否则返回`false`
    ///
    /// 示例:
    /// ```swift
    /// let inset1 = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let inset2 = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let areEqual = inset1 == inset2 // true
    /// ```
    static func == (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool {
        return lhs.top == rhs.top &&
            lhs.left == rhs.left &&
            lhs.bottom == rhs.bottom &&
            lhs.right == rhs.right
    }

    /// 根据两个`UIEdgeInsets`的和来创建一个新的`UIEdgeInsets`
    /// - Parameters:
    ///   - lhs: 左侧的`UIEdgeInsets`
    ///   - rhs: 右侧的`UIEdgeInsets`
    /// - Returns: 一个新的`UIEdgeInsets`，是`lhs`和`rhs`相加的结果
    ///
    /// 示例:
    /// ```swift
    /// let inset1 = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let inset2 = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    /// let newInset = inset1 + inset2
    /// // 结果: UIEdgeInsets(top: 12, left: 7, bottom: 7, right: 7)
    /// ```
    static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top,
                            left: lhs.left + rhs.left,
                            bottom: lhs.bottom + rhs.bottom,
                            right: lhs.right + rhs.right)
    }

    /// 把右侧的`UIEdgeInsets`添加到左侧的`UIEdgeInsets`
    ///
    /// 该方法将右侧 `UIEdgeInsets` 的每个边距值（上、左、下、右）与左侧 `UIEdgeInsets` 相对应的边距值相加，更新左侧 `UIEdgeInsets`。
    ///
    /// - Parameters:
    ///   - lhs: 左侧的`UIEdgeInsets`，将被更新。
    ///   - rhs: 右侧的`UIEdgeInsets`，其每个边距值将加到左侧的对应边距上。
    ///
    /// 示例:
    /// ```swift
    /// var inset1 = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    /// let inset2 = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    /// inset1 += inset2
    /// // inset1 的值将变为 UIEdgeInsets(top: 12, left: 7, bottom: 7, right: 7)
    /// ```
    static func += (_ lhs: inout UIEdgeInsets, _ rhs: UIEdgeInsets) {
        lhs.top += rhs.top
        lhs.left += rhs.left
        lhs.bottom += rhs.bottom
        lhs.right += rhs.right
    }
}
