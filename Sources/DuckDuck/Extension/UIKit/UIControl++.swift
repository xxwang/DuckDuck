//
//  UIControl++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UIControl {
    /// 纯净的创建方法
    static func create<T: UIControl>(_ aClass: T.Type = UIControl.self) -> T {
        let control = UIControl(frame: .zero)
        return control as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIControl>(_ aClass: T.Type = UIControl.self) -> T {
        let control: UIControl = self.create()
        return control as! T
    }
}

// MARK: - 类型
extension UIControl {
    // MARK: - 关联键
    @MainActor
    class AssociateKeys {
        static var callbackKey = UnsafeRawPointer(bitPattern: ("UIControl" + "CallbackKey").hashValue)
        static var hitTimerKey = UnsafeRawPointer(bitPattern: ("UIControl" + "HitTimerKey").hashValue)
    }
}

// MARK: - 事件关联
extension UIControl {
    /// 事件回调
    var control_onEventHandler: ((UIControl) -> Void)? {
        get { AssociatedObject.get(self, key: &AssociateKeys.callbackKey) as? (UIControl) -> Void }
        set { AssociatedObject.set(self, key: &AssociateKeys.callbackKey, value: newValue) }
    }

    /// 重复点击限制时间
    var dd_hitTime: Double? {
        get { AssociatedObject.get(self, key: &AssociateKeys.hitTimerKey) as? Double }
        set { AssociatedObject.set(self, key: &AssociateKeys.hitTimerKey, value: newValue, policy: .OBJC_ASSOCIATION_ASSIGN) }
    }

    /// 防止重复点击实现
    /// - Parameter sender:被点击的`UIControl`
    @objc func dd_preventDoubleHit(_ sender: UIControl) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.isUserInteractionEnabled = true
        }
    }

    /// 事件处理方法
    /// - Parameter sender:事件发起者
    @objc func dd_controlEventHandler(_ sender: UIControl) {
        if let block = self.control_onEventHandler { block(sender) }
    }
}

// MARK: - 限制连续点击时间间隔
public extension UIControl {
    /// 设置指定时长(单位:秒)内不可重复点击
    /// - Parameter hitTime:时长
    func dd_doubleHit(hitTime: Double = 1) {
        self.dd_hitTime = hitTime
        self.addTarget(self, action: #selector(self.dd_preventDoubleHit), for: .touchUpInside)
    }
}

// MARK: - 链式语法
public extension UIControl {
    /// 设置控件是否可用
    /// - Parameter isEnabled:是否可用
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd_isEnabled(true)
    /// ```
    @discardableResult
    func dd_isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    /// 设置是否被选中
    /// - Parameter isSelected:选中状态
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd_isSelected(true)
    /// ```
    @discardableResult
    func dd_isSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }

    /// 设置是否高亮
    /// - Parameter isHighlighted:高亮状态
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd_isHighlighted(true)
    /// ```
    @discardableResult
    func dd_isHighlighted(_ isHighlighted: Bool) -> Self {
        self.isHighlighted = isHighlighted
        return self
    }

    /// 设置垂直方向对齐
    /// - Parameter contentVerticalAlignment:对齐方式
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd_contentVerticalAlignment(.center)
    /// ```
    @discardableResult
    func dd_contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = contentVerticalAlignment
        return self
    }

    /// 设置水平方向对齐
    /// - Parameter contentHorizontalAlignment:对齐方式
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd_contentHorizontalAlignment(.right)
    /// ```
    @discardableResult
    func dd_contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = contentHorizontalAlignment
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
    /// button.dd_addTarget(self, action: #selector(buttonTapped))
    /// ```
    @discardableResult
    func dd_addTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        self.addTarget(target, action: action, for: event)
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
    /// button.dd_removeTarget(self, action: #selector(buttonTapped))
    /// ```
    @discardableResult
    func dd_removeTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        self.removeTarget(target, action: action, for: event)
        return self
    }

    /// 设置在指定时间内禁用多次点击
    /// - Parameter hitTime:禁用时长(单位:秒)
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let button = UIButton()
    /// button.dd_disableMultiTouch(1.5) // 禁止连续点击1.5秒
    /// ```
    @discardableResult
    func dd_disableMultiTouch(_ hitTime: Double = 1) -> Self {
        self.dd_doubleHit(hitTime: hitTime)
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
    /// button.dd_onEvent { control in
    ///     print("Button clicked!")
    /// }
    /// ```
    @discardableResult
    @objc func dd_onEvent(_ handler: ((UIControl) -> Void)?, for controlEvent: UIControl.Event = .touchUpInside) -> Self {
        self.control_onEventHandler = handler
        self.addTarget(self, action: #selector(dd_controlEventHandler(_:)), for: controlEvent)
        return self
    }
}
