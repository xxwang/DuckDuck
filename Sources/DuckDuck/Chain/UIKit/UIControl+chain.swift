//
//  UIControl+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIControl {
    /// 设置控件是否可用
    /// - Parameter isEnabled:是否可用
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.isEnabled(true)
    /// ```
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        self.base.isEnabled = isEnabled
        return self
    }

    /// 设置是否被选中
    /// - Parameter isSelected:选中状态
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.isSelected(true)
    /// ```
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        self.base.isSelected = isSelected
        return self
    }

    /// 设置是否高亮
    /// - Parameter isHighlighted:高亮状态
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.isHighlighted(true)
    /// ```
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> Self {
        self.base.isHighlighted = isHighlighted
        return self
    }

    /// 设置垂直方向对齐
    /// - Parameter contentVerticalAlignment:对齐方式
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.contentVerticalAlignment(.center)
    /// ```
    @discardableResult
    func contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.base.contentVerticalAlignment = contentVerticalAlignment
        return self
    }

    /// 设置水平方向对齐
    /// - Parameter contentHorizontalAlignment:对齐方式
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.contentHorizontalAlignment(.right)
    /// ```
    @discardableResult
    func contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.base.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }

    /// 添加事件(默认点击事件:`touchUpInside`)
    /// - Parameters:
    ///   - target:被监听的对象
    ///   - action:事件
    ///   - event:事件类型，默认为`.touchUpInside`
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.addTarget(self, action: #selector(buttonTapped))
    /// ```
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        self.base.addTarget(target, action: action, for: event)
        return self
    }

    /// 移除事件(默认移除点击事件:`touchUpInside`)
    /// - Parameters:
    ///   - target:被监听的对象
    ///   - action:事件
    ///   - event:事件类型，默认为`.touchUpInside`
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.removeTarget(self, action: #selector(buttonTapped))
    /// ```
    @discardableResult
    func removeTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        self.base.removeTarget(target, action: action, for: event)
        return self
    }

    /// 设置在指定时间内禁用多次点击
    /// - Parameter hitTime:禁用时长(单位:秒)
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.disableMultiTouch(1.5) // 禁止连续点击1.5秒
    /// ```
    @discardableResult
    func disableMultiTouch(_ hitTime: Double = 1) -> Self {
        self.base.dd_doubleHit(hitTime: hitTime)
        return self
    }

    /// 添加`UIControl`事件回调
    /// - Parameters:
    ///   - block:事件回调
    ///   - controlEvent:事件类型，默认为`.touchUpInside`
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd.onEvent { control in
    ///     print("Button clicked!")
    /// }
    /// ```
    @discardableResult
    func onEvent(_ closure: ((_ control: UIControl) -> Void)?, for controlEvent: UIControl.Event = .touchUpInside) -> Self {
        self.base.onEvent = closure
        self.base.addTarget(self.base, action: #selector(self.base.dd_controlEventHandler(_:)), for: controlEvent)
        return self
    }
}
