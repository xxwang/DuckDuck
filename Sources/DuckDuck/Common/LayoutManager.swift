//
//  LayoutManager.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 24/11/2024.
//

import UIKit

// MARK: - 布局相关计算属性
public extension UIView {
    /// 控件的`frame`
    /// - 用于获取或设置控件的整体布局框架
    ///
    /// 示例：
    /// ```swift
    /// view.dd_frame = CGRect(x: 10, y: 10, width: 100, height: 50)
    /// print(view.dd_frame) // 输出: (10.0, 10.0, 100.0, 50.0)
    /// ```
    var dd_frame: CGRect {
        get { return self.frame }
        set { self.frame = newValue }
    }

    /// 控件的`bounds`
    /// - 用于获取或设置控件的内部边界
    ///
    /// 示例：
    /// ```swift
    /// view.dd_bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
    /// print(view.dd_bounds) // 输出: (0.0, 0.0, 100.0, 50.0)
    /// ```
    var dd_bounds: CGRect {
        get { return self.bounds }
        set { self.bounds = CGRect(origin: .zero, size: newValue.size) }
    }

    /// 控件的`origin`
    /// - 用于获取或设置控件的位置
    ///
    /// 示例：
    /// ```swift
    /// view.dd_origin = CGPoint(x: 20, y: 30)
    /// print(view.dd_origin) // 输出: (20.0, 30.0)
    /// ```
    var dd_origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame = CGRect(origin: newValue, size: self.dd_size) }
    }

    /// 控件的`x`
    /// - 用于获取或设置控件的`x`坐标
    ///
    /// 示例：
    /// ```swift
    /// view.dd_x = 50
    /// print(view.dd_x) // 输出: 50.0
    /// ```
    var dd_x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(origin: CGPoint(x: newValue, y: self.dd_origin.y), size: self.dd_size) }
    }

    /// 控件的`y`
    /// - 用于获取或设置控件的`y`坐标
    ///
    /// 示例：
    /// ```swift
    /// view.dd_y = 40
    /// print(view.dd_y) // 输出: 40.0
    /// ```
    var dd_y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame = CGRect(origin: CGPoint(x: self.dd_origin.x, y: newValue), size: self.dd_size) }
    }

    /// 控件的`size`
    /// - 用于获取或设置控件的大小
    ///
    /// 示例：
    /// ```swift
    /// view.dd_size = CGSize(width: 100, height: 50)
    /// print(view.dd_size) // 输出: (100.0, 50.0)
    /// ```
    var dd_size: CGSize {
        get { return self.frame.size }
        set { self.frame = CGRect(origin: self.dd_origin, size: newValue) }
    }

    /// 控件的宽度
    /// - 用于获取或设置控件的`width`
    ///
    /// 示例：
    /// ```swift
    /// view.dd_width = 150
    /// print(view.dd_width) // 输出: 150.0
    /// ```
    var dd_width: CGFloat {
        get { return self.frame.width }
        set { self.frame = CGRect(origin: self.dd_origin, size: CGSize(width: newValue, height: self.dd_size.height)) }
    }

    /// 控件的高度
    /// - 用于获取或设置控件的`height`
    ///
    /// 示例：
    /// ```swift
    /// view.dd_height = 80
    /// print(view.dd_height) // 输出: 80.0
    /// ```
    var dd_height: CGFloat {
        get { return self.frame.height }
        set { self.frame = CGRect(origin: self.dd_origin, size: CGSize(width: self.dd_size.width, height: newValue)) }
    }

    /// 以`frame`为基准的中心点
    /// - 用于获取或设置控件的中心点
    ///
    /// 示例：
    /// ```swift
    /// view.dd_center = CGPoint(x: 50, y: 50)
    /// print(view.dd_center) // 输出: (50.0, 50.0)
    /// ```
    var dd_center: CGPoint {
        get { return self.center }
        set { self.center = newValue }
    }

    /// 控件中心点的`x`
    /// - 用于获取或设置中心点的`x`坐标
    ///
    /// 示例：
    /// ```swift
    /// view.dd_centerX = 100
    /// print(view.dd_centerX) // 输出: 100.0
    /// ```
    var dd_centerX: CGFloat {
        get { return self.center.x }
        set { self.dd_center = CGPoint(x: newValue, y: self.dd_center.y) }
    }

    /// 控件中心点的`y`
    /// - 用于获取或设置中心点的`y`坐标
    ///
    /// 示例：
    /// ```swift
    /// view.dd_centerY = 200
    /// print(view.dd_centerY) // 输出: 200.0
    /// ```
    var dd_centerY: CGFloat {
        get { return self.dd_center.y }
        set { self.center = CGPoint(x: self.dd_center.x, y: newValue) }
    }

    /// 控件的顶部边距`y`
    /// - 功能等同于`dd_y`
    ///
    /// 示例：
    /// ```swift
    /// view.dd_top = 20
    /// print(view.dd_top) // 输出: 20.0
    /// ```
    var dd_top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame = CGRect(origin: CGPoint(x: self.dd_origin.x, y: newValue), size: self.dd_size) }
    }

    /// 控件底部边距`maxY`
    /// - 用于获取或设置控件的底部边距
    ///
    /// 示例：
    /// ```swift
    /// view.dd_bottom = 200
    /// print(view.dd_bottom) // 输出: 200.0
    /// ```
    var dd_bottom: CGFloat {
        get { return self.frame.maxY }
        set { self.frame = CGRect(origin: CGPoint(x: self.dd_left, y: newValue - self.dd_height), size: self.dd_size) }
    }

    /// 控件左边距`x`
    /// - 功能等同于`dd_x`
    ///
    /// 示例：
    /// ```swift
    /// view.dd_left = 10
    /// print(view.dd_left) // 输出: 10.0
    /// ```
    var dd_left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(origin: CGPoint(x: newValue, y: self.dd_origin.y), size: self.dd_size) }
    }

    /// 控件右边距`maxX`
    /// - 用于获取或设置控件的右边距
    ///
    /// 示例：
    /// ```swift
    /// view.dd_right = 120
    /// print(view.dd_right) // 输出: 120.0
    /// ```
    var dd_right: CGFloat {
        get { return self.frame.maxX }
        set { self.frame = CGRect(origin: CGPoint(x: newValue - self.dd_width, y: self.dd_top), size: self.dd_size) }
    }

    /// 以`bounds`为基准的中心点 (只读)
    /// - 计算控件的中心点坐标
    ///
    /// 示例：
    /// ```swift
    /// let middle = view.dd_middle
    /// print(middle) // 输出: (width / 2, height / 2)
    /// ```
    var dd_middle: CGPoint {
        return CGPoint(x: self.dd_width / 2, y: self.dd_height / 2)
    }
}

// MARK: - 链式语法 - 布局相关设置
public extension UIView {
    /// 设置控件的 `frame`
    /// - Parameter frame: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_frame(CGRect(x: 10, y: 20, width: 100, height: 50))
    /// ```
    @discardableResult
    func dd_frame(_ frame: CGRect) -> Self {
        self.dd_frame = frame
        return self
    }

    /// 设置控件的 `bounds`
    /// - Parameter bounds: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_bounds(CGRect(x: 10, y: 20, width: 100, height: 50))
    /// ```
    @discardableResult
    func dd_bounds(_ bounds: CGRect) -> Self {
        self.dd_bounds = bounds
        return self
    }

    /// 设置控件的 `origin`
    /// - Parameter origin: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_origin(CGPoint(x: 10, y: 20))
    /// ```
    @discardableResult
    func dd_origin(_ origin: CGPoint) -> Self {
        self.dd_origin = origin
        return self
    }

    /// 设置控件的 `x` 坐标
    /// - Parameter x: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_x(15)
    /// ```
    @discardableResult
    func dd_x(_ x: CGFloat) -> Self {
        self.dd_x = x
        return self
    }

    /// 设置控件的顶部 `y` 坐标
    /// - Parameter y: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_y(30)
    /// ```
    @discardableResult
    func dd_y(_ y: CGFloat) -> Self {
        self.dd_y = y
        return self
    }

    /// 设置控件的 `size`
    /// - Parameter size: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_size(CGSize(width: 100, height: 50))
    /// ```
    @discardableResult
    func dd_size(_ size: CGSize) -> Self {
        self.dd_size = size
        return self
    }

    /// 设置控件的 `width`
    /// - Parameter width: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_width(120)
    /// ```
    @discardableResult
    func dd_width(_ width: CGFloat) -> Self {
        self.dd_width = width
        return self
    }

    /// 设置控件的 `height`
    /// - Parameter height: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_height(80)
    /// ```
    @discardableResult
    func dd_height(_ height: CGFloat) -> Self {
        self.dd_height = height
        return self
    }

    /// 设置控件的 `center`
    /// - Parameter center: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_center(CGPoint(x: 50, y: 100))
    /// ```
    @discardableResult
    func dd_center(_ center: CGPoint) -> Self {
        self.dd_center = center
        return self
    }

    /// 设置控件的中心点 `x` 坐标
    /// - Parameter centerX: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_centerX(75)
    /// ```
    @discardableResult
    func dd_centerX(_ centerX: CGFloat) -> Self {
        self.dd_centerX = centerX
        return self
    }

    /// 设置控件的中心点 `y` 坐标
    /// - Parameter centerY: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_centerY(150)
    /// ```
    @discardableResult
    func dd_centerY(_ centerY: CGFloat) -> Self {
        self.dd_centerY = centerY
        return self
    }

    /// 设置控件的顶部 `y` 坐标
    /// - Parameter top: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_top(30)
    /// ```
    @discardableResult
    func dd_top(_ top: CGFloat) -> Self {
        self.dd_top = top
        return self
    }

    /// 设置控件的底部 `maxY`
    /// - Parameter bottom: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_bottom(250)
    /// ```
    @discardableResult
    func dd_bottom(_ bottom: CGFloat) -> Self {
        self.dd_bottom = bottom
        return self
    }

    /// 设置控件的 `x` 坐标
    /// - Parameter left: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_left(15)
    /// ```
    @discardableResult
    func dd_left(_ left: CGFloat) -> Self {
        self.dd_left = left
        return self
    }

    /// 设置控件的右边距 `maxX`
    /// - Parameter right: 要设置的值
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_right(200)
    /// ```
    @discardableResult
    func dd_right(_ right: CGFloat) -> Self {
        self.dd_right = right
        return self
    }
}

public extension UIView {
    /// 强制更新布局 (立即更新)
    /// - 使用 `setNeedsLayout` 标记需要布局更新，并立即调用 `layoutIfNeeded` 更新布局。
    /// - Returns: 当前视图 (`Self`) 实例，支持链式调用。
    ///
    /// 示例：
    /// ```swift
    /// view.dd_updateLayout()
    /// ```
    @discardableResult
    func dd_updateLayout() -> Self {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        return self
    }
}
