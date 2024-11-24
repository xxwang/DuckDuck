//
//  CGSize++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGSize {
    /// 获取`宽高比`
    ///
    /// 该方法返回`CGSize`的宽高比，即`width`除以`height`，如果`height`为零，则返回零。
    ///
    /// - Returns: 返回宽高比
    ///
    /// - Example:
    ///     ```swift
    ///     let size = CGSize(width: 120, height: 80)
    ///     let aspectRatio = size.dd_aspectRatio()
    ///     print(aspectRatio) // 输出: 1.5
    ///     ```
    func dd_aspectRatio() -> CGFloat {
        guard self.height != 0 else { return 0 }
        return self.width / self.height
    }

    /// 获取`宽高最大值`
    ///
    /// 该方法返回`CGSize`的最大值，`width`和`height`中的较大者。
    ///
    /// - Returns: 返回宽高的最大值
    ///
    /// - Example:
    ///     ```swift
    ///     let size = CGSize(width: 120, height: 80)
    ///     let maxDimension = size.dd_maxDimension()
    ///     print(maxDimension) // 输出: 120
    ///     ```
    func dd_maxDimension() -> CGFloat {
        return max(self.width, self.height)
    }

    /// 获取`宽高最小值`
    ///
    /// 该方法返回`CGSize`的最小值，`width`和`height`中的较小者。
    ///
    /// - Returns: 返回宽高的最小值
    ///
    /// - Example:
    ///     ```swift
    ///     let size = CGSize(width: 120, height: 80)
    ///     let minDimension = size.dd_minDimension()
    ///     print(minDimension) // 输出: 80
    ///     ```
    func dd_minDimension() -> CGFloat {
        return min(self.width, self.height)
    }
}

// MARK: - 方法
public extension CGSize {
    /// 以`size`最小宽高比缩放`CGSize`（不超过`size`）
    ///
    /// 该方法将`CGSize`按最小宽高比缩放，以适配目标大小`size`，返回缩放后的`CGSize`。
    ///
    /// - Parameter size: 边界`CGSize`
    /// - Returns: 缩放后的`CGSize`
    ///
    /// - Example:
    ///     ```swift
    ///     let rect = CGSize(width: 120, height: 80)
    ///     let parentSize = CGSize(width: 100, height: 50)
    ///     let newSize = rect.dd_aspectFit(to: parentSize)
    ///     print(newSize) // 输出: (75.0, 50.0)
    ///     ```
    func dd_aspectFit(to size: CGSize) -> CGSize {
        let minRatio = min(size.width / self.width, size.height / self.height)
        return CGSize(width: self.width * minRatio, height: self.height * minRatio)
    }

    /// 以`size`最大宽高比缩放`CGSize`（不超过`size`）
    ///
    /// 该方法将`CGSize`按最大宽高比缩放，以适配目标大小`size`，返回缩放后的`CGSize`。
    ///
    /// - Parameter size: 边界`CGSize`
    /// - Returns: 缩放后的`CGSize`
    ///
    /// - Example:
    ///     ```swift
    ///     let size = CGSize(width: 20, height: 120)
    ///     let parentSize = CGSize(width: 100, height: 60)
    ///     let newSize = size.dd_aspectFill(to: parentSize)
    ///     print(newSize) // 输出: (100.0, 60.0)
    ///     ```
    func dd_aspectFill(to size: CGSize) -> CGSize {
        let maxRatio = max(size.width / self.width, size.height / self.height)
        let aWidth = min(self.width * maxRatio, size.width)
        let aHeight = min(self.height * maxRatio, size.height)
        return CGSize(width: aWidth, height: aHeight)
    }
}

// MARK: - 运算符
public extension CGSize {
    /// 求两个`CGSize`的`和`
    ///
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - rhs: 加数`CGSize`
    /// - Returns: 返回`CGSize`
    ///
    /// - Example:
    ///     ```swift
    ///     let size1 = CGSize(width: 50, height: 60)
    ///     let size2 = CGSize(width: 30, height: 40)
    ///     let result = size1 + size2
    ///     print(result) // 输出: (80.0, 100.0)
    ///     ```
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    /// 求`CGSize`与`元组`的`和`
    ///
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - tuple: 加数`tuple`
    /// - Returns: 返回`CGSize`
    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    /// 求两个`CGSize`的`和`并赋值给被加`CGSize`
    ///
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - rhs: 加数`CGSize`
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    /// 求`CGSize`与`元组`的`和`并赋值给被加`CGSize`
    ///
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - tuple: 加数`tuple`
    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    /// 求两个`CGSize`的`差`
    ///
    /// - Parameters:
    ///   - lhs: 被减`CGSize`
    ///   - rhs: 减数`CGSize`
    /// - Returns: 返回`CGSize`
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    /// 求`CGSize`与`元组`的`差`
    ///
    /// - Parameters:
    ///   - lhs: 被减`CGSize`
    ///   - tuple: 减数`tuple`
    /// - Returns: 返回`CGSize`
    static func - (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.height)
    }

    /// 求两个`CGSize`的`差`并赋值给被减`CGSize`
    ///
    /// - Parameters:
    ///   - lhs: 被减`CGSize`
    ///   - rhs: 减数`CGSize`
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    /// 求`CGSize`与`元组`的`差`并赋值给被减`CGSize`
    ///
    /// - Parameters:
    ///   - lhs: 被减`CGSize`
    ///   - tuple: 减数`tuple`
    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    /// 求两个`CGSize`的`积`
    ///
    /// - Parameters:
    ///   - lhs: 被乘`CGSize`
    ///   - rhs: 乘数`CGSize`
    /// - Returns: 返回`CGSize`
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    /// 两个`CGSize`的`积`并赋值给被乘`CGSize`
    ///
    /// - Parameters:
    ///   - lhs: 被乘`CGSize`
    ///   - rhs: 乘数`CGSize`
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    /// 求`CGSize`与`标量`的`积`
    ///
    /// - Parameters:
    ///   - lhs: 被乘`CGSize`
    ///   - scalar: 乘数`标量`
    /// - Returns: 返回`CGSize`
    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    /// 求`标量`与`CGSize`的`积`
    ///
    /// - Parameters:
    ///   - scalar: 乘数`标量`
    ///   - rhs: 被乘`CGSize`
    /// - Returns: 返回`CGSize`
    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    /// 求`CGSize`与`标量`的`积`并赋值给被乘`CGSize`
    ///
    /// - Parameters:
    ///   - lhs: 被乘`CGSize`
    ///   - scalar: 乘数`标量`
    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }
}
