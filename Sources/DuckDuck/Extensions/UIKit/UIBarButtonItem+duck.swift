//
//  UIBarButtonItem+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - 构造方法
public extension UIBarButtonItem {
    /// 创建固定宽度的弹簧
    /// - Parameter width: 宽度
    convenience init(flexible width: CGFloat) {
        self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.width = width
    }

    /// 创建自定义`UIBarButtonItem`
    /// - Parameters:
    ///   - image: 默认图片
    ///   - highlightedImage:高亮图片
    ///   - title:标题
    ///   - font:字体
    ///   - titleColor:标题颜色
    ///   - highlightedTitleColor:高亮标题颜色
    ///   - target:事件响应方
    ///   - action:事件处理方法
    convenience init(image: UIImage? = nil,
                     highlightedImage: UIImage? = nil,
                     title: String? = nil,
                     font: UIFont? = nil,
                     titleColor: UIColor? = nil,
                     highlightedTitleColor: UIColor? = nil,
                     target: Any? = nil,
                     action: Selector?)
    {
        let button = UIButton(type: .custom)
        // 设置默认图片
        if let image { button.setImage(image, for: .normal) }
        // 设置高亮图片
        if let highlightedImage { button.setImage(highlightedImage, for: .highlighted) }
        // 设置标题文字
        if let title { button.setTitle(title, for: .normal) }
        // 设置标题字体
        if let font { button.titleLabel?.font = font }
        // 设置标题颜色
        if let titleColor { button.setTitleColor(titleColor, for: .normal) }
        // 设置高亮标题颜色
        if let highlightedTitleColor { button.setTitleColor(highlightedTitleColor, for: .highlighted) }
        // 设置响应方法
        if let target, let action { button.addTarget(target, action: action, for: .touchUpInside) }
        // 设置图标与标题之间的间距
        button.dd_spacing(3)

        self.init(customView: button)
    }
}

// MARK: - 关联键
private class DDAssociateKeys {
    static var kBlockKey = UnsafeRawPointer(bitPattern: ("UIBarButtonItem" + "BlockKey").hashValue)
}

// MARK: - AssociatedAttributes
extension UIBarButtonItem: AssociatedEventBlock {
    public typealias T = UIBarButtonItem
    public var eventBlock: EventBlock? {
        get { AssociatedObject.get(self, &AssociateKeys.kBlockKey) as? EventBlock }
        set { AssociatedObject.set(self, &AssociateKeys.kBlockKey, newValue) }
    }

    /// 事件处理
    /// - Parameter event:事件发生者
    @objc func eventHandler(_ event: UIBarButtonItem) {
        self.eventBlock?(event)
    }
}

// MARK: - 链式方法
public extension UIBarButtonItem {
    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func dd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`
    @discardableResult
    func dd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置宽度
    /// - Parameter width: 宽度
    /// - Returns: `Self`
    @discardableResult
    func dd_width(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }

    /// 将事件响应者及事件响应方法添加到`UIBarButtonItem`
    /// - Parameters:
    ///   - target:事件响应者
    ///   - action:事件响应方法
    @discardableResult
    func dd_addTarget(_ target: AnyObject, action: Selector) -> Self {
        self.target = target
        self.action = action
        return self
    }

    /// 添加事件响应者
    /// - Parameter action: 事件响应者
    /// - Returns: `Self`
    @discardableResult
    func dd_target(_ target: AnyObject) -> Self {
        self.target = target
        return self
    }

    /// 添加事件响应方法
    /// - Parameter action: 事件响应方法
    /// - Returns: `Self`
    @discardableResult
    func dd_action(_ action: Selector) -> Self {
        self.action = action
        return self
    }

    /// 添加事件处理回调
    /// - Parameters:
    ///   - callback:事件处理回调
    /// - Returns:`Self`
    @discardableResult
    func dd_callback(_ block: ((UIBarButtonItem?) -> Void)?) -> Self {
        self.eventBlock = block
        self.dd_addTarget(self, action: #selector(eventHandler(_:)))
        return self
    }
}
