//
//  UIButton+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

/// 按钮所有状态
private var kStates: [UIControl.State] {
    [.normal, .selected, .highlighted, .disabled]
}

// MARK: - 方法
public extension DDExtension where Base: UIButton {
    /// 为按钮的所有状态设置同样的图片
    /// - Parameter image:要设置的图片
    func setImageForAllStates(_ image: UIImage) {
        kStates.forEach { self.base.setImage(image, for: $0) }
    }

    /// 为按钮的所有状态设置同样的标题颜色
    /// - Parameter color:要设置的颜色
    func setTitleColorForAllStates(_ color: UIColor) {
        kStates.forEach { self.base.setTitleColor(color, for: $0) }
    }

    /// 为按钮的所有状态设置同样的标题
    /// - Parameter title:标题文字
    func setTitleForAllStates(_ title: String) {
        kStates.forEach { self.base.setTitle(title, for: $0) }
    }
}

// MARK: - 按钮布局
public extension DDExtension where Base: UIButton {
    enum WGImagePosition {
        case top
        case bottom
        case left
        case right
    }

    /// 按枚举将 btn 的 image 和 title 之间位置处理
    ///  ⚠️ frame 大小必须已确定
    /// - Parameters:
    ///   - spacing:间距
    ///   - position:图片位置
    func changeLayout(_ spacing: CGFloat, position: WGImagePosition) {
        let imageRect: CGRect = self.base.imageView?.frame ?? .zero
        let titleRect: CGRect = self.base.titleLabel?.frame ?? .zero
        let buttonWidth: CGFloat = frame.size.width
        let buttonHeight: CGFloat = frame.size.height
        let totalHeight = titleRect.size.height + spacing + imageRect.size.height

        switch position {
        case .left:
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
            self.base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        case .right:
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.size.width + spacing / 2), bottom: 0, right: imageRect.size.width + spacing / 2)
            self.base.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleRect.size.width + spacing / 2, bottom: 0, right: -(titleRect.size.width + spacing / 2))
        case .top:
            self.base.titleEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 + imageRect.size.height + spacing - titleRect.origin.y,
                left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2,
                bottom: -((buttonHeight - totalHeight) / 2 + imageRect.size.height + spacing - titleRect.origin.y),
                right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2
            )
            self.base.imageEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 - imageRect.origin.y,
                left: buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2,
                bottom: -((buttonHeight - totalHeight) / 2 - imageRect.origin.y),
                right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2)
            )
        case .bottom:
            self.base.titleEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 - titleRect.origin.y,
                left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2,
                bottom: -((buttonHeight - totalHeight) / 2 - titleRect.origin.y),
                right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2
            )
            self.base.imageEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 + titleRect.size.height + spacing - imageRect.origin.y,
                left: buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2,
                bottom: -((buttonHeight - totalHeight) / 2 + titleRect.size.height + spacing - imageRect.origin.y),
                right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2)
            )
        }
    }

    /// 将标题文本和图像居中对齐
    /// - Parameters:
    ///   - imageAboveText:设置为true可使图像位于标题文本上方,默认值为false,图像位于文本左侧
    ///   - spacing:标题文本和图像之间的间距
    func centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
        if imageAboveText {
            guard let imageSize = self.base.imageView?.image?.size else { return }
            guard let text = self.base.titleLabel?.text else { return }
            guard let font = self.base.titleLabel?.font else { return }

            let titleSize = text.size(withAttributes: [.font: font])

            let titleOffset = -(imageSize.height + spacing)
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)

            let imageOffset = -(titleSize.height + spacing)
            self.base.imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)

            let edgeOffset = Swift.abs(titleSize.height - imageSize.height) / 2.0
            self.base.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        } else {
            let insetAmount = spacing / 2
            self.base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            self.base.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }

    /// 调整图标与文字的间距(必须左图右字)
    func spacing(_ spacing: CGFloat) {
        let spacing = spacing * 0.5
        self.base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
        self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
    }
}

// MARK: - 计算按钮尺寸
public extension DDExtension where Base: UIButton {
    /// 获取指定宽度下字符串的Size
    /// - Parameter lineWidth: 最大行宽度
    /// - Returns: 文字尺寸
    func titleSize(with lineWidth: CGFloat = kScreenWidth) -> CGSize {
        if let currentAttributedTitle = self.base.currentAttributedTitle {
            return currentAttributedTitle.dd.attributedSize(lineWidth)
        }
        return self.base.titleLabel?.dd.textSize(lineWidth) ?? .zero
    }
}

// MARK: - 关联键
private class AssociateKeys {
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UIButton" + "CallbackKey").hashValue)
    static var ExpandSizeKey = UnsafeRawPointer(bitPattern: ("UIButton" + "ExpandSizeKey").hashValue)
}

// MARK: - AssociatedAttributes
extension UIButton: AssociatedEventBlock {
    public typealias T = UIButton

    public var eventBlock: EventBlock? {
        get { AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? EventBlock }
        set { AssociatedObject.set(self, &AssociateKeys.CallbackKey, newValue) }
    }

    @objc func tapAction(_ button: UIButton) {
        self.eventBlock?(button)
    }
}

// MARK: - Button扩大点击事件
public extension DDExtension where Base: UIButton {
    /// 扩大UIButton的点击区域,向四周扩展10像素的点击范围
    /// - Parameter size:向四周扩展像素的点击范围
    func expandSize(size: CGFloat = 10) {
        AssociatedObject.set(self.base, &AssociateKeys.ExpandSizeKey, size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
}

// MARK: - 触摸范围
public extension UIButton {
    private func expandRect() -> CGRect {
        let expandSize = AssociatedObject.get(self, &AssociateKeys.ExpandSizeKey)
        if expandSize != nil {
            return CGRect(
                x: bounds.origin.x - (expandSize as! CGFloat),
                y: bounds.origin.y - (expandSize as! CGFloat),
                width: bounds.size.width + 2 * (expandSize as! CGFloat),
                height: bounds.size.height + 2 * (expandSize as! CGFloat)
            )
        } else {
            return bounds
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = self.expandRect()
        if buttonRect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        } else {
            return buttonRect.contains(point)
        }
    }
}

// MARK: - Defaultable
public extension UIButton {
    typealias Associatedtype = UIButton
    override open class func `default`() -> Associatedtype {
        return UIButton()
    }
}

// MARK: - 链式语法
public extension UIButton {
    /// 设置`title`
    /// - Parameters:
    ///   - text:文字
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_title(_ text: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(text, for: state)
        return self
    }

    /// 设置属性文本标题
    /// - Parameters:
    ///   - title:属性文本标题
    ///   - state:状态
    /// - Returns:`Self`
    func dd_setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        self.setAttributedTitle(title, for: state)
        return self
    }

    /// 设置文字颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setTitleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }

    /// 设置字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func dd_font(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }

    /// 设置图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }

    /// 设置图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName:图片名字
    ///   - bundle:Bundle
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setImage(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.setImage(image, for: state)
        return self
    }

    /// 设置图片(通过`Bundle`加载)
    /// - Parameters:
    ///   - imageName:图片的名字
    ///   - bundleName:`bundle` 的名字
    ///   - aClass:`className` `bundle`所在的类的类名
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setImage(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        self.setImage(image, for: state)
        return self
    }

    /// 设置图片(纯颜色的图片)
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    ///   - state: 状态
    /// - Returns: `Self`
    @discardableResult
    func dd_setImage(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0), for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color, size: size)
        self.setImage(image, for: state)
        return self
    }

    /// 设置背景图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setBackgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName:图片的名字
    ///   - bundleName:bundle 的名字
    ///   - aClass:className bundle所在的类的类名
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setBackgroundImage(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName:图片的名字
    ///   - bundle:Bundle
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setBackgroundImage(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(纯颜色的图片)
    /// - Parameters:
    ///   - color:背景色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func dd_setBackgroundImage(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color)
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 按钮点击回调
    /// - Parameter callback: 按钮点击回调
    /// - Returns: `Self`
    @discardableResult
    func dd_tapBlock(_ block: ((_ button: UIButton?) -> Void)?) -> Self {
        self.block = block
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        return self
    }

    /// 扩大按钮的点击区域
    /// - Parameter size: 向四周扩展的像素大小
    /// - Returns: `Self`
    @discardableResult
    func dd_expandClickArea(_ size: CGFloat = 10) -> Self {
        self.dd.expandSize(size: size)
        return self
    }
}
