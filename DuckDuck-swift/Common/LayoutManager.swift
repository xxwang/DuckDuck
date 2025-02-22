import UIKit

public extension UIView {
    
    private struct LayoutKeys {
        static var top = UnsafeRawPointer(bitPattern: "UIView.LayoutKeys.top".hashValue)
        static var bottom = UnsafeRawPointer(bitPattern: "UIView.LayoutKeys.bottom".hashValue)
        static var left = UnsafeRawPointer(bitPattern: "UIView.LayoutKeys.left".hashValue)
        static var right = UnsafeRawPointer(bitPattern: "UIView.LayoutKeys.right".hashValue)
        static var width = UnsafeRawPointer(bitPattern: "UIView.LayoutKeys.width".hashValue)
        static var height = UnsafeRawPointer(bitPattern: "UIView.LayoutKeys.height".hashValue)
        static var needsLayoutUpdate = UnsafeRawPointer(bitPattern: "UIView.LayoutKeys.needsLayoutUpdate".hashValue)
    }

    // MARK: - 关联属性
    var topLayout: CGFloat? {
        get { AssociatedObject.get(self, key: &LayoutKeys.top) as? CGFloat }
        set { AssociatedObject.set(self, key: &LayoutKeys.top, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var bottomLayout: CGFloat? {
        get { AssociatedObject.get(self, key: &LayoutKeys.bottom) as? CGFloat }
        set { AssociatedObject.set(self, key: &LayoutKeys.bottom, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var leftLayout: CGFloat? {
        get { AssociatedObject.get(self, key: &LayoutKeys.left) as? CGFloat }
        set { AssociatedObject.set(self, key: &LayoutKeys.left, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var rightLayout: CGFloat? {
        get { AssociatedObject.get(self, key: &LayoutKeys.right) as? CGFloat }
        set { AssociatedObject.set(self, key: &LayoutKeys.right, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var widthLayout: CGFloat? {
        get { AssociatedObject.get(self, key: &LayoutKeys.width) as? CGFloat }
        set { AssociatedObject.set(self, key: &LayoutKeys.width, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var heightLayout: CGFloat? {
        get { AssociatedObject.get(self, key: &LayoutKeys.height) as? CGFloat }
        set { AssociatedObject.set(self, key: &LayoutKeys.height, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var needsLayoutUpdate: Bool {
        get { AssociatedObject.get(self, key: &LayoutKeys.needsLayoutUpdate) as? Bool ?? false }
        set { AssociatedObject.set(self, key: &LayoutKeys.needsLayoutUpdate, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // MARK: - 布局计算
    func calculateLayout() {
        guard let superview = self.superview else {
            self.needsLayoutUpdate = true // 标记为需要更新布局
            return
        }

        // 计算宽高
        let (width, height) = self.calculateSize()

        // 计算 x 和 y
        let x = self.leftLayout ?? (self.rightLayout != nil ? superview.frame.width - (self.rightLayout ?? 0) - width : self.frame.origin.x)
        let y = self.topLayout ?? (self.bottomLayout != nil ? superview.frame.height - (self.bottomLayout ?? 0) - height : self.frame.origin.y)

        self.frame = CGRect(x: x, y: y, width: width, height: height)
        self.needsLayoutUpdate = false
    }

    func calculateSize() -> (CGFloat, CGFloat) {
        // 计算宽度
        let left = self.leftLayout ?? 0
        let right = self.rightLayout ?? 0
        let superviewWidth = self.superview?.frame.width ?? 0
        let width: CGFloat = if let _ = self.leftLayout, let _ = self.rightLayout {
            superviewWidth - left - right
        } else {
            self.widthLayout ?? self.frame.width
        }

        // 计算高度
        let top = self.topLayout ?? 0
        let bottom = self.bottomLayout ?? 0
        let superviewHeight = self.superview?.frame.height ?? 0
        let height: CGFloat = if let _ = self.topLayout, let _ = self.bottomLayout {
            superviewHeight - top - bottom
        } else {
            self.heightLayout ?? self.frame.height
        }

        return (width, height)
    }
}

// MARK: - 布局设置（链式调用）
public extension DDExtension where Base: UIView {
    @discardableResult
    func horizontal(_ left: CGFloat, right: CGFloat) -> Self {
        self.base.leftLayout = left
        self.base.rightLayout = right

        self.base.widthLayout = nil

        self.base.calculateLayout()

        return self
    }

    @discardableResult
    func vertical(_ top: CGFloat, bottom: CGFloat) -> Self {
        self.base.topLayout = top
        self.base.bottomLayout = bottom

        self.base.heightLayout = nil

        self.base.calculateLayout()

        return self
    }

    @discardableResult
    func top(_ value: CGFloat) -> Self {
        self.base.topLayout = value
        self.base.bottomLayout = nil
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func bottom(_ value: CGFloat) -> Self {
        self.base.bottomLayout = value
        self.base.topLayout = nil
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func left(_ value: CGFloat) -> Self {
        self.base.leftLayout = value
        self.base.rightLayout = nil
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func right(_ value: CGFloat) -> Self {
        self.base.rightLayout = value
        self.base.leftLayout = nil
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func width(_ value: CGFloat) -> Self {
        self.base.widthLayout = value
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func height(_ value: CGFloat) -> Self {
        self.base.heightLayout = value
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func size(_ size: CGSize) -> Self {
        self.base.widthLayout = size.width
        self.base.heightLayout = size.height
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func origin(_ origin: CGPoint) -> Self {
        self.base.leftLayout = origin.x
        self.base.topLayout = origin.y
        self.base.calculateLayout()
        return self
    }

    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.base.topLayout = frame.origin.y
        self.base.bottomLayout = nil

        self.base.leftLayout = frame.origin.x
        self.base.rightLayout = nil

        self.base.widthLayout = frame.width
        self.base.heightLayout = frame.height

        self.base.calculateLayout()

        return self
    }

    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        self.base.topLayout = nil
        self.base.bottomLayout = nil

        self.base.leftLayout = nil
        self.base.rightLayout = nil

        self.base.widthLayout = bounds.width
        self.base.heightLayout = bounds.height

        self.base.calculateLayout()

        return self
    }

    // MARK: - 填充父视图
    @discardableResult
    func fillSuperview(insets: UIEdgeInsets = .zero) -> Self {
        guard let superview = self.base.superview else { return self }
        self.base.topLayout = insets.top
        self.base.leftLayout = insets.left
        self.base.widthLayout = superview.frame.width - insets.left - insets.right
        self.base.heightLayout = superview.frame.height - insets.top - insets.bottom
        self.base.calculateLayout()
        return self
    }
}
