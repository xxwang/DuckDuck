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

// MARK: - 常用方法
public extension UIView {
    /// 获取当前视图的布局方向
    /// - Returns: 布局方向 (`UIUserInterfaceLayoutDirection`)
    ///
    /// 示例：
    /// ```swift
    /// let direction = view.dd_layoutDirection()
    /// ```
    func dd_layoutDirection() -> UIUserInterfaceLayoutDirection {
        if #available(iOS 10.0, macCatalyst 13.0, tvOS 10.0, *) {
            return self.effectiveUserInterfaceLayoutDirection
        } else {
            return .leftToRight
        }
    }

    /// 获取当前视图所属的控制器
    /// - Returns: 控制器 (`UIViewController?`)，如果存在
    ///
    /// 示例：
    /// ```swift
    /// if let controller = view.dd_controller() {
    ///     print(controller)
    /// }
    /// ```
    func dd_controller() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }

    /// 递归查找当前视图及其子视图中的第一响应者
    /// - Returns: 第一响应者 (`UIView?`)，如果存在
    ///
    /// 示例：
    /// ```swift
    /// if let firstResponder = view.dd_firstResponder() {
    ///     print("Found first responder: \(firstResponder)")
    /// }
    /// ```
    func dd_firstResponder() -> UIView? {
        if self.isFirstResponder { return self }
        for subView in self.subviews {
            if let firstResponder = subView.dd_firstResponder() {
                return firstResponder
            }
        }
        return nil
    }

    /// 查找当前视图的所有子视图（递归）
    /// - Returns: 包含所有子视图的数组
    ///
    /// 示例：
    /// ```swift
    /// let allSubviews = view.dd_allSubViews()
    /// print("Total subviews: \(allSubviews.count)")
    /// ```
    func dd_allSubViews() -> [UIView] {
        var subviews = [UIView]()
        for subView in self.subviews {
            subviews.append(subView)
            subviews += subView.dd_allSubViews()
        }
        return subviews
    }
}

// MARK: - 常用方法扩展
public extension UIView {
    /// 为当前视图的子视图添加调试边框及背景色（仅在 Debug 环境生效）
    /// - Parameters:
    ///   - borderWidth: 边框宽度，默认为 `1`
    ///   - borderColor: 边框颜色，默认为随机颜色
    ///   - backgroundColor: 背景色，默认为随机颜色
    ///
    /// 示例：
    /// ```swift
    /// view.dd_stressView()
    /// ```
    func dd_stressView(_ borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.dd_random(), backgroundColor: UIColor = UIColor.dd_random()) {
        guard CommonHelper.isDebug else { return }
        for subview in self.subviews {
            subview.layer.borderWidth = borderWidth
            subview.layer.borderColor = borderColor.cgColor
            subview.backgroundColor = backgroundColor
            subview.dd_stressView(borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
        }
    }

    /// 移除当前视图的所有子视图
    ///
    /// 示例：
    /// ```swift
    /// view.dd_removeAllSubviews()
    /// ```
    func dd_removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }

    /// 隐藏键盘
    ///
    /// 示例：
    /// ```swift
    /// view.dd_hideKeyboard()
    /// ```
    func dd_hideKeyboard() {
        self.endEditing(true)
    }

    /// 判断某个点是否位于当前视图内
    /// - Parameter point: 需要判断的点
    /// - Returns: 是否位于当前视图内 (`Bool`)
    ///
    /// 示例：
    /// ```swift
    /// let isInside = view.dd_contains(CGPoint(x: 50, y: 50))
    /// ```
    func dd_contains(_ point: CGPoint) -> Bool {
        return point.x > self.frame.minX && point.x < self.frame.maxX && point.y > self.frame.minY && point.y < self.frame.maxY
    }

    /// 判断当前视图是否包含指定类型的子视图
    /// - Parameter name: 子视图的类型
    /// - Returns: 是否包含该类型子视图 (`Bool`)
    ///
    /// 示例：
    /// ```swift
    /// let containsButton = view.dd_contains(withClass: UIButton.self)
    /// ```
    func dd_contains<T: UIView>(withClass name: T.Type) -> Bool {
        if self.isKind(of: T.self) { return true }
        for subView in self.subviews {
            if subView.dd_contains(withClass: T.self) { return true }
        }
        return false
    }

    /// 查找指定类型的父视图
    /// - Parameter name: 父视图的类型
    /// - Returns: 父视图 (`UIView?`)，如果存在
    ///
    /// 示例：
    /// ```swift
    /// let superview = view.dd_findSuperview(withClass: UITableView.self)
    /// ```
    func dd_findSuperview<T: UIView>(withClass name: T.Type) -> T? {
        return self.dd_findSuperview(where: { $0 is T }) as? T
    }

    /// 查找符合条件的父视图
    /// - Parameter predicate: 判断条件的闭包
    /// - Returns: 父视图 (`UIView?`)，如果存在
    func dd_findSuperview(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(self.superview) { return self.superview }
        return self.superview?.dd_findSuperview(where: predicate)
    }

    /// 查找指定类型的子视图
    /// - Parameter name: 子视图的类型
    /// - Returns: 子视图 (`UIView?`)，如果存在
    ///
    /// 示例：
    /// ```swift
    /// let button = view.dd_findSubview(withClass: UIButton.self)
    /// ```
    func dd_findSubview<T: UIView>(withClass name: T.Type) -> T? {
        return self.dd_findSubview(where: { $0 is T }) as? T
    }

    /// 查找符合条件的子视图
    /// - Parameter predicate: 判断条件的闭包
    /// - Returns: 子视图 (`UIView?`)，如果存在
    func dd_findSubview(where predicate: (UIView?) -> Bool) -> UIView? {
        for subView in self.subviews {
            if predicate(subView) { return subView }
            if let result = subView.dd_findSubview(where: predicate) {
                return result
            }
        }
        return nil
    }

    /// 查找所有指定类型的子视图
    /// - Parameter name: 子视图的类型
    /// - Returns: 子视图数组
    ///
    /// 示例：
    /// ```swift
    /// let labels = view.dd_findSubviews(withClass: UILabel.self)
    /// ```
    func dd_findSubviews<T: UIView>(withClass name: T.Type) -> [T] {
        return self.dd_findSubviews(where: { $0 is T }).compactMap { $0 as? T }
    }

    /// 查找所有符合条件的子视图
    /// - Parameter predicate: 判断条件的闭包
    /// - Returns: 符合条件的子视图数组
    func dd_findSubviews(where predicate: (UIView?) -> Bool) -> [UIView] {
        var result: [UIView] = []
        for subView in self.subviews {
            if predicate(subView) { result.append(subView) }
            result += subView.dd_findSubviews(where: predicate)
        }
        return result
    }
}

// MARK: - 布局
public extension UIView {
    /// 获取当前视图的第一个宽度约束
    var dd_widthConstraint: NSLayoutConstraint? {
        return dd_findFirstConstraint(for: self, attribute: .width)
    }

    /// 获取当前视图的第一个高度约束
    var dd_heightConstraint: NSLayoutConstraint? {
        return dd_findFirstConstraint(for: self, attribute: .height)
    }

    /// 获取当前视图的第一个左侧约束
    var dd_leadingConstraint: NSLayoutConstraint? {
        return dd_findFirstConstraint(for: self, attribute: .leading)
    }

    /// 获取当前视图的第一个右侧约束
    var dd_trailingConstraint: NSLayoutConstraint? {
        return dd_findFirstConstraint(for: self, attribute: .trailing)
    }

    /// 获取当前视图的第一个顶部约束
    var dd_topConstraint: NSLayoutConstraint? {
        return dd_findFirstConstraint(for: self, attribute: .top)
    }

    /// 获取当前视图的第一个底部约束
    var dd_bottomConstraint: NSLayoutConstraint? {
        return dd_findFirstConstraint(for: self, attribute: .bottom)
    }

    /// 查找并返回第一个匹配给定属性的约束
    /// - Parameters:
    ///   - attribute: 需要查找的约束属性（例如 `.width`, `.top` 等）
    ///   - view: 需要查找约束的视图
    /// - Returns: 找到的约束或 `nil`
    /// - Example:
    /// ```swift
    /// if let widthConstraint = view.dd_findFirstConstraint(for: view, attribute: .width) {
    ///     print("Width constraint: \(widthConstraint)")
    /// }
    /// ```
    func dd_findFirstConstraint(for view: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        let constraint = constraints.first {
            ($0.firstAttribute == attribute && $0.firstItem as? UIView == view) ||
                ($0.secondAttribute == attribute && $0.secondItem as? UIView == view)
        }
        return constraint ?? superview?.dd_findFirstConstraint(for: view, attribute: attribute)
    }

    /// 使用视觉格式语言（VFL）添加约束
    /// - Parameters:
    ///   - format: VFL格式字符串，例如 `"H:|-[v0]-|"` 表示水平方向上的约束
    ///   - views: 视图数组，按索引顺序传入视图
    /// - Example:
    /// ```swift
    /// view.dd_addConstraints(withFormat: "H:|-[v0]-|", views: label)
    /// ```
    func dd_addConstraints(using format: String, views: UIView...) {
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: format,
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: viewsDictionary
        ))
    }

    /// 将当前视图的所有边缘锚定到其父视图（填充至父视图）
    /// - Example:
    /// ```swift
    /// view.dd_fillToSuperview()
    /// ```
    func dd_fillToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview {
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            let leading = leadingAnchor.constraint(equalTo: superview.leadingAnchor)
            let trailing = trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, leading, trailing])
        }
    }

    /// 将当前视图的中心点锚定到其父视图的中心点
    /// - Example:
    /// ```swift
    /// view.dd_anchorCenterToSuperview()
    /// ```
    func dd_anchorCenterToSuperview() {
        dd_anchorCenterXToSuperview()
        dd_anchorCenterYToSuperview()
    }

    /// 将当前视图的中心X锚定到其父视图的中心X，并可以设置常量偏移
    /// - Parameter offset: 偏移量，默认为 0
    /// - Example:
    /// ```swift
    /// view.dd_anchorCenterXToSuperview(offset: 10)
    /// ```
    func dd_anchorCenterXToSuperview(offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
        }
    }

    /// 将当前视图的中心Y锚定到其父视图的中心Y，并可以设置常量偏移
    /// - Parameter offset: 偏移量，默认为 0
    /// - Example:
    /// ```swift
    /// view.dd_anchorCenterYToSuperview(offset: -10)
    /// ```
    func dd_anchorCenterYToSuperview(offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
        }
    }

    /// 将当前视图的指定边锚定到另一个视图的边，并返回新创建的约束数组
    /// - Parameters:
    ///   - topAnchor: 顶部锚定，默认为 `nil`
    ///   - leftAnchor: 左侧锚定，默认为 `nil`
    ///   - bottomAnchor: 底部锚定，默认为 `nil`
    ///   - rightAnchor: 右侧锚定，默认为 `nil`
    ///   - topOffset: 顶部边距，默认为 0
    ///   - leftOffset: 左侧边距，默认为 0
    ///   - bottomOffset: 底部边距，默认为 0
    ///   - rightOffset: 右侧边距，默认为 0
    ///   - width: 宽度约束，默认为 0
    ///   - height: 高度约束，默认为 0
    /// - Returns: 新创建的约束数组
    /// - Example:
    /// ```swift
    /// view.dd_anchor(topAnchor: superview?.topAnchor, leftAnchor: superview?.leftAnchor, width: 100, height: 50)
    /// ```
    @discardableResult
    func dd_anchor(topAnchor: NSLayoutYAxisAnchor? = nil,
                   leftAnchor: NSLayoutXAxisAnchor? = nil,
                   bottomAnchor: NSLayoutYAxisAnchor? = nil,
                   rightAnchor: NSLayoutXAxisAnchor? = nil,
                   topOffset: CGFloat = 0,
                   leftOffset: CGFloat = 0,
                   bottomOffset: CGFloat = 0,
                   rightOffset: CGFloat = 0,
                   width: CGFloat = 0,
                   height: CGFloat = 0) -> [NSLayoutConstraint]
    {
        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()

        if let topAnchor {
            constraints.append(topAnchor.constraint(equalTo: topAnchor, constant: topOffset))
        }

        if let leftAnchor {
            constraints.append(leftAnchor.constraint(equalTo: leftAnchor, constant: leftOffset))
        }

        if let bottomAnchor {
            constraints.append(bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomOffset))
        }

        if let rightAnchor {
            constraints.append(rightAnchor.constraint(equalTo: rightAnchor, constant: -rightOffset))
        }

        if width > 0 {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }

        if height > 0 {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }

        constraints.forEach { $0.isActive = true }

        return constraints
    }
}

// MARK: - Transform
public extension UIView {
    /// 表示角度单位的枚举
    enum AngleUnit {
        /// 角度（degrees）
        case degrees
        /// 弧度（radians）
        case radians
    }

    /// 按相对轴上的角度旋转视图
    /// - Parameters:
    ///   - angle: 旋转视图的角度
    ///   - type: 旋转角度的类型（度或弧度）
    ///   - animated: 是否启用动画（默认为 `false`）
    ///   - duration: 动画持续时间，以秒为单位（默认为 `1` 秒）
    ///   - completion: 动画完成时的回调（默认为 `nil`）
    /// - Example:
    /// ```swift
    /// view.dd_rotate(byAngle: 90, ofType: .degrees, animated: true, duration: 0.5) { finished in
    ///     print("Rotation completed: \(finished)")
    /// }
    /// ```
    func dd_rotate(byAngle angle: CGFloat,
                   ofType type: AngleUnit,
                   animated: Bool = false,
                   duration: TimeInterval = 1,
                   completion: ((Bool) -> Void)? = nil)
    {
        let angleInRadians = (type == .degrees) ? .pi * angle / 180.0 : angle
        let animationDuration = animated ? duration : 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveLinear, animations: {
            self.transform = self.transform.rotated(by: angleInRadians)
        }, completion: completion)
    }

    /// 将视图旋转到指定角度
    /// - Parameters:
    ///   - angle: 目标角度
    ///   - type: 角度类型（度或弧度）
    ///   - animated: 是否启用动画（默认为 `false`）
    ///   - duration: 动画持续时间（默认为 `1` 秒）
    ///   - completion: 动画完成时的回调（默认为 `nil`）
    /// - Example:
    /// ```swift
    /// view.dd_rotate(toAngle: 180, ofType: .degrees, animated: true)
    /// ```
    func dd_rotate(toAngle angle: CGFloat,
                   ofType type: AngleUnit,
                   animated: Bool = false,
                   duration: TimeInterval = 1,
                   completion: ((Bool) -> Void)? = nil)
    {
        let angleInRadians = (type == .degrees) ? .pi * angle / 180.0 : angle
        let animationDuration = animated ? duration : 0
        UIView.animate(withDuration: animationDuration, animations: {
            self.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: completion)
    }

    /// 按指定的偏移缩放视图
    /// - Parameters:
    ///   - offset: 缩放偏移值，`x` 和 `y` 分别表示水平方向和垂直方向的缩放倍数
    ///   - animated: 是否启用动画（默认为 `false`）
    ///   - duration: 动画持续时间（默认为 `1` 秒）
    ///   - completion: 动画完成时的回调（默认为 `nil`）
    /// - Example:
    /// ```swift
    /// view.dd_scale(by: CGPoint(x: 1.5, y: 1.5), animated: true, duration: 0.3)
    /// ```
    func dd_scale(by offset: CGPoint,
                  animated: Bool = false,
                  duration: TimeInterval = 1,
                  completion: ((Bool) -> Void)? = nil)
    {
        let animations = {
            self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
        }
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: animations, completion: completion)
        } else {
            animations()
            completion?(true)
        }
    }

    /// 设置视图的平面旋转
    /// - Parameters:
    ///   - angle: 旋转角度（弧度制）
    ///   - isInverted: 是否逆向旋转（默认为 `false`）
    /// - Example:
    /// ```swift
    /// view.dd_rotation(.pi / 4)
    /// ```
    func dd_rotation(_ angle: CGFloat, isInverted: Bool = false) {
        transform = isInverted
            ? CGAffineTransform(rotationAngle: angle).inverted()
            : CGAffineTransform(rotationAngle: angle)
    }

    /// 沿X轴方向进行3D旋转
    /// - Parameter angle: 旋转角度（弧度制）
    /// - Example:
    /// ```swift
    /// view.dd_3DRotationX(.pi / 2)
    /// ```
    func dd_3DRotationX(_ angle: CGFloat) {
        layer.transform = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)
    }

    /// 沿Y轴方向进行3D旋转
    /// - Parameter angle: 旋转角度（弧度制）
    /// - Example:
    /// ```swift
    /// view.dd_3DRotationY(.pi)
    /// ```
    func dd_3DRotationY(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000.0 // 增加透视效果
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        layer.transform = transform
    }

    /// 沿Z轴方向进行3D旋转
    /// - Parameter angle: 旋转角度（弧度制）
    /// - Example:
    /// ```swift
    /// view.dd_3DRotationZ(.pi / 4)
    /// ```
    func dd_3DRotationZ(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    /// 沿X、Y、Z轴方向进行3D旋转
    /// - Parameters:
    ///   - xAngle: X轴旋转角度（弧度制）
    ///   - yAngle: Y轴旋转角度（弧度制）
    ///   - zAngle: Z轴旋转角度（弧度制）
    /// - Example:
    /// ```swift
    /// view.dd_rotation(xAngle: .pi / 4, yAngle: .pi / 4, zAngle: .pi / 4)
    /// ```
    func dd_rotation(xAngle: CGFloat, yAngle: CGFloat, zAngle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000.0
        transform = CATransform3DRotate(transform, xAngle, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, yAngle, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, zAngle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    /// 设置视图的缩放比例
    /// - Parameters:
    ///   - x: 水平方向缩放倍数
    ///   - y: 垂直方向缩放倍数
    /// - Example:
    /// ```swift
    /// view.dd_scale(x: 1.5, y: 0.8)
    /// ```
    func dd_scale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        layer.transform = transform
    }
}

// MARK: - 阴影
public extension UIView {
    /// 为视图添加阴影
    /// - Note: 适用于不透明的背景颜色，或者设置了 `shadowPath` 时，请参考参数 `opacity`
    /// - Parameters:
    ///   - color: 阴影的颜色，默认值为 `#137992`
    ///   - radius: 阴影的半径，默认值为 `3`
    ///   - offset: 阴影的偏移，默认值为 `.zero`
    ///   - opacity: 阴影的不透明度，默认值为 `0.5`，会受到 `alpha` 和 `backgroundColor` 的影响
    /// - Example:
    /// ```swift
    /// view.dd_addShadow(color: .black, radius: 5, offset: CGSize(width: 0, height: 3), opacity: 0.8)
    /// ```
    func dd_addShadow(color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
                      radius: CGFloat = 3,
                      offset: CGSize = .zero,
                      opacity: Float = 0.5)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    /// 为视图同时添加阴影和圆角
    /// - Note: 如果使用异步布局（如 `SnapKit`），需要在布局后调用 `layoutIfNeeded`，然后再调用此方法
    /// - Parameters:
    ///   - corners: 需要设置圆角的角（例如 `.topLeft`, `.bottomRight`）
    ///   - radius: 圆角半径，默认为 `3`
    ///   - shadowColor: 阴影的颜色
    ///   - shadowOffset: 阴影的偏移量，正值表示右下偏移，负值表示左上偏移
    ///   - shadowOpacity: 阴影的透明度
    ///   - shadowRadius: 阴影的半径，默认为 `3`
    /// - Example:
    /// ```swift
    /// view.dd_addCornerAndShadow(corners: .allCorners, radius: 10, shadowColor: .black, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.5)
    /// ```
    func dd_addCornerAndShadow(corners: UIRectCorner,
                               radius: CGFloat = 3,
                               shadowColor: UIColor,
                               shadowOffset: CGSize,
                               shadowOpacity: Float,
                               shadowRadius: CGFloat = 3)
    {
        // 添加圆角
        self.dd_applyCorner(radius: radius, corners: corners)

        // 设置阴影
        let subLayer = CALayer()
        subLayer.frame = frame
        subLayer.cornerRadius = shadowRadius
        subLayer.backgroundColor = shadowColor.cgColor
        subLayer.masksToBounds = false

        // 设置阴影属性
        subLayer.shadowColor = shadowColor.cgColor
        subLayer.shadowOffset = shadowOffset
        subLayer.shadowOpacity = shadowOpacity
        subLayer.shadowRadius = shadowRadius
        superview?.layer.insertSublayer(subLayer, below: layer)
    }

    /// 为视图添加内阴影效果
    /// - Parameters:
    ///   - shadowColor: 阴影的颜色
    ///   - shadowOffset: 阴影的偏移量，正值表示右下偏移，负值表示左上偏移
    ///   - shadowOpacity: 阴影的不透明度
    ///   - shadowRadius: 阴影的半径，默认值为 `3`
    ///   - insetBySize: 内阴影的偏移大小，默认值为 `CGSize(width: -42, height: -42)`
    /// - Example:
    /// ```swift
    /// view.dd_addInnerShadowLayer(shadowColor: .black, shadowOpacity: 0.6, insetBySize: CGSize(width: -20, height: -20))
    /// ```
    func dd_addInnerShadowLayer(shadowColor: UIColor,
                                shadowOffset: CGSize = CGSize(width: 0, height: 0),
                                shadowOpacity: Float = 0.5,
                                shadowRadius: CGFloat = 3,
                                insetBySize: CGSize = CGSize(width: -42, height: -42))
    {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.fillRule = .evenOdd

        // 创建路径，外部矩形与内部圆角路径
        let path = CGMutablePath()
        path.addRect(bounds.insetBy(dx: insetBySize.width, dy: insetBySize.height))

        let innerPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowRadius).cgPath
        path.addPath(innerPath)
        path.closeSubpath()

        shadowLayer.path = path

        let maskLayer = CAShapeLayer()
        maskLayer.path = innerPath
        shadowLayer.mask = maskLayer

        layer.addSublayer(shadowLayer)
    }
}

// MARK: - 边框
public extension UIView {
    /// 添加视图的边框
    /// - Parameters:
    ///   - width: 边框的宽度
    ///   - color: 边框的颜色
    /// - Example:
    /// ```swift
    /// view.dd_addBorder(width: 2, color: .red)
    /// ```
    func dd_addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    /// 添加顶部边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    /// - Example:
    /// ```swift
    /// view.dd_addBorderTop(width: 2, color: .blue)
    /// ```
    func dd_addBorderTop(width: CGFloat, color: UIColor) {
        dd_addBorderUtility(x: 0, y: 0, width: frame.width, height: width, color: color)
    }

    /// 添加底部边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    /// - Example:
    /// ```swift
    /// view.dd_addBorderBottom(width: 2, color: .green)
    /// ```
    func dd_addBorderBottom(width: CGFloat, color: UIColor) {
        dd_addBorderUtility(x: 0, y: frame.height - width, width: frame.width, height: width, color: color)
    }

    /// 添加左边边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    /// - Example:
    /// ```swift
    /// view.dd_addBorderLeft(width: 2, color: .orange)
    /// ```
    func dd_addBorderLeft(width: CGFloat, color: UIColor) {
        dd_addBorderUtility(x: 0, y: 0, width: width, height: frame.height, color: color)
    }

    /// 添加右边边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    /// - Example:
    /// ```swift
    /// view.dd_addBorderRight(width: 2, color: .purple)
    /// ```
    func dd_addBorderRight(width: CGFloat, color: UIColor) {
        dd_addBorderUtility(x: frame.width - width, y: 0, width: width, height: frame.height, color: color)
    }

    /// 为视图添加指定位置的边框
    /// - Parameters:
    ///   - x: 边框的 `x` 坐标
    ///   - y: 边框的 `y` 坐标
    ///   - width: 边框的宽度
    ///   - height: 边框的高度
    ///   - color: 边框的颜色
    /// - Note: 此方法是内部方法，直接调用即可添加任何位置的边框
    private func dd_addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(borderLayer)
    }

    /// 绘制一个圆环
    /// - Parameters:
    ///   - fillColor: 内环的填充颜色
    ///   - strokeColor: 外环的颜色
    ///   - strokeWidth: 外环的宽度
    /// - Example:
    /// ```swift
    /// view.dd_drawCircle(fillColor: .clear, strokeColor: .black, strokeWidth: 5)
    /// ```
    func dd_drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let circleRadius = min(bounds.width, bounds.height)
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius), cornerRadius: circleRadius / 2)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth

        layer.addSublayer(shapeLayer)
    }

    /// 绘制虚线边框
    /// - Parameters:
    ///   - strokeColor: 虚线颜色
    ///   - lineLength: 每段虚线的长度
    ///   - lineSpacing: 每段虚线之间的间隔
    ///   - isHorizontal: 是否是水平方向的虚线
    /// - Example:
    /// ```swift
    /// view.dd_drawDashLine(strokeColor: .black, lineLength: 4, lineSpacing: 4, isHorizontal: true)
    /// ```
    func dd_drawDashLine(strokeColor: UIColor, lineLength: Int = 4, lineSpacing: Int = 4, isHorizontal: Bool = true) {
        // 设置虚线方向
        let lineWidth = isHorizontal ? bounds.height : bounds.width
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]

        // 创建路径
        let path = CGMutablePath()
        if isHorizontal {
            path.move(to: CGPoint(x: 0, y: lineWidth / 2))
            path.addLine(to: CGPoint(x: bounds.width, y: lineWidth / 2))
        } else {
            path.move(to: CGPoint(x: lineWidth / 2, y: 0))
            path.addLine(to: CGPoint(x: lineWidth / 2, y: bounds.height))
        }

        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

    /// 绘制虚线边框，四周加虚线边框
    /// - Parameters:
    ///   - lineWidth: 边框宽度
    ///   - lineColor: 边框颜色
    ///   - lineLen: 每段虚线的长度
    ///   - lineSpacing: 虚线之间的间隔
    ///   - radius: 圆角半径
    /// - Example:
    /// ```swift
    /// view.dd_drawDashLineBorder(lineWidth: 2, lineColor: .black, lineLen: 5, lineSpacing: 5, radius: 10)
    /// ```
    @discardableResult
    func dd_drawDashLineBorder(lineWidth: CGFloat, lineColor: UIColor, lineLen: CGFloat, lineSpacing: CGFloat, radius: CGFloat) -> Self {
        let frame = self.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)

        let borderPath = UIBezierPath(roundedRect: frame, cornerRadius: radius).cgPath
        let borderLayer = CAShapeLayer()
        borderLayer.frame = frame
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = lineColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineDashPattern = [NSNumber(value: lineLen), NSNumber(value: lineSpacing)]
        borderLayer.path = borderPath
        borderLayer.cornerRadius = radius
        self.layer.addSublayer(borderLayer)

        return self
    }
}

// MARK: - 颜色渐变
public extension UIView {
    /// 设置线性渐变边框
    /// - Parameters:
    ///   - size: 渐变的大小
    ///   - colors: 渐变的颜色数组
    ///   - locations: 颜色位置数组，默认为 [0, 1]
    ///   - startPoint: 渐变的开始位置
    ///   - endPoint: 渐变的结束位置
    ///   - borderWidth: 边框宽度，默认为 1.0
    ///   - roundingCorners: 圆角方向，默认为所有角
    ///   - cornerRadius: 圆角半径，默认为 0
    ///
    /// 示例：
    /// ```swift
    /// view.dd_applyLinearGradientBorder(size: CGSize(width: 100, height: 100),
    ///                                    colors: [.red, .blue],
    ///                                    startPoint: CGPoint(x: 0, y: 0),
    ///                                    endPoint: CGPoint(x: 1, y: 1),
    ///                                    borderWidth: 2,
    ///                                    roundingCorners: .allCorners,
    ///                                    cornerRadius: 10)
    /// ```
    func dd_applyLinearGradientBorder(size: CGSize,
                                      colors: [UIColor],
                                      locations: [CGFloat] = [0, 1],
                                      startPoint: CGPoint,
                                      endPoint: CGPoint,
                                      borderWidth: CGFloat = 1.0,
                                      roundingCorners: UIRectCorner = .allCorners,
                                      cornerRadius: CGFloat = 0)
    {
        let gradientLayer = colors.dd_toLinearGradientLayer(size: size,
                                                            locations: locations,
                                                            startPoint: startPoint,
                                                            endPoint: endPoint)

        let maskLayer = CAShapeLayer.default()
            .dd_lineWidth(borderWidth)
            .dd_path(UIBezierPath(
                roundedRect: gradientLayer.bounds,
                byRoundingCorners: roundingCorners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).cgPath)
            .dd_fillColor(.clear)
            .dd_strokeColor(.black)

        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }

    /// 设置线性渐变背景图层
    /// - Parameters:
    ///   - size: 渐变的大小
    ///   - colors: 渐变的颜色数组
    ///   - locations: 颜色位置数组，默认为 [0, 1]
    ///   - startPoint: 渐变的开始位置
    ///   - endPoint: 渐变的结束位置
    ///
    /// 示例：
    /// ```swift
    /// view.dd_applyLinearGradientBackgroundLayer(size: CGSize(width: 100, height: 100),
    ///                                              colors: [.red, .yellow],
    ///                                              startPoint: CGPoint(x: 0, y: 0),
    ///                                              endPoint: CGPoint(x: 1, y: 1))
    /// ```
    func dd_applyLinearGradientBackgroundLayer(size: CGSize,
                                               colors: [UIColor],
                                               locations: [CGFloat] = [0, 1],
                                               startPoint: CGPoint,
                                               endPoint: CGPoint)
    {
        let gradientLayer = colors.dd_toLinearGradientLayer(size: size,
                                                            locations: locations,
                                                            startPoint: startPoint,
                                                            endPoint: endPoint)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    /// 设置线性渐变背景颜色
    /// - Parameters:
    ///   - size: 渐变的大小
    ///   - colors: 渐变的颜色数组
    ///   - locations: 颜色位置数组，默认为 [0, 1]
    ///   - startPoint: 渐变的开始位置
    ///   - endPoint: 渐变的结束位置
    ///
    /// 示例：
    /// ```swift
    /// view.dd_applyLinearGradientBackgroundColor(size: CGSize(width: 100, height: 100),
    ///                                              colors: [.green, .blue],
    ///                                              startPoint: CGPoint(x: 0, y: 0),
    ///                                              endPoint: CGPoint(x: 1, y: 1))
    /// ```
    func dd_applyLinearGradientBackgroundColor(size: CGSize,
                                               colors: [UIColor],
                                               locations: [CGFloat] = [0, 1],
                                               startPoint: CGPoint,
                                               endPoint: CGPoint)
    {
        let gradientColor = colors.dd_toLinearGradientColor(size: size,
                                                            locations: locations,
                                                            startPoint: startPoint,
                                                            endPoint: endPoint)
        backgroundColor = gradientColor
    }

    /// 启动线性渐变颜色动画
    /// - Parameters:
    ///   - size: 渐变的大小
    ///   - startColors: 渐变开始颜色数组
    ///   - endColors: 渐变结束颜色数组
    ///   - locations: 颜色位置数组
    ///   - startPoint: 渐变的开始位置
    ///   - endPoint: 渐变的结束位置
    ///   - duration: 动画时长，默认为 1.0
    ///
    /// 示例：
    /// ```swift
    /// view.dd_startLinearGradientColorAnimation(size: CGSize(width: 100, height: 100),
    ///                                            startColors: [.red, .blue],
    ///                                            endColors: [.green, .yellow],
    ///                                            locations: [0, 1],
    ///                                            startPoint: CGPoint(x: 0, y: 0),
    ///                                            endPoint: CGPoint(x: 1, y: 1),
    ///                                            duration: 2.0)
    /// ```
    func dd_startLinearGradientColorAnimation(size: CGSize,
                                              startColors: [UIColor],
                                              endColors: [UIColor],
                                              locations: [CGFloat],
                                              startPoint: CGPoint,
                                              endPoint: CGPoint,
                                              duration: CFTimeInterval = 1.0)
    {
        let gradientLayer = startColors.dd_toLinearGradientLayer(size: size,
                                                                 locations: locations,
                                                                 startPoint: startPoint,
                                                                 endPoint: endPoint)
        layer.insertSublayer(gradientLayer, at: 0)

        // 执行动画
        dd_animateLinearGradientColorTransition(
            gradientLayer,
            startColors: startColors,
            endColors: endColors,
            duration: duration
        )
    }

    /// 执行线性渐变颜色变化动画
    /// - Parameters:
    ///   - gradientLayer: 要执行动画的渐变图层
    ///   - startColors: 开始颜色数组
    ///   - endColors: 结束颜色数组
    ///   - duration: 动画时长，默认为 1.0
    private func dd_animateLinearGradientColorTransition(_ gradientLayer: CAGradientLayer,
                                                         startColors: [UIColor],
                                                         endColors: [UIColor],
                                                         duration: CFTimeInterval = 1.0)
    {
        let startColorArr = startColors.map(\.cgColor)
        let endColorArr = endColors.map(\.cgColor)

        // 创建渐变颜色的动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = duration
        colorChangeAnimation.fromValue = startColorArr
        colorChangeAnimation.toValue = endColorArr
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        colorChangeAnimation.isRemovedOnCompletion = false

        // 执行动画
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
}

// MARK: - 水波纹动画
public extension UIView {
    /// 开启水波纹动画（动画层数根据颜色数组变化）
    /// - Parameters:
    ///   - colors: 颜色数组，表示水波纹的颜色
    ///   - scale: 缩放倍数，控制水波纹的扩展大小
    ///   - duration: 动画时间，控制每个水波纹动画的持续时间
    ///
    /// 示例：
    /// ```swift
    /// view.dd_startWaterWaveAnimation(colors: [.blue, .green], scale: 2.0, duration: 2.0)
    /// ```
    final func dd_startWaterWaveAnimation(colors: [UIColor],
                                          scale: CGFloat,
                                          duration: TimeInterval)
    {
        if superview?.viewWithTag(3257) != nil { return } // 防止多次添加

        let animationView = UIView(frame: frame) // 创建动画视图
        animationView.tag = 3257 // 为视图设置唯一标识符
        animationView.layer.cornerRadius = layer.cornerRadius // 设置圆角
        superview?.insertSubview(animationView, belowSubview: self) // 插入到当前视图的下方

        let delay = Double(duration) / Double(colors.count) // 计算每个水波纹的延迟时间
        for (index, color) in colors.enumerated() {
            let delay = delay * Double(index) // 每个水波纹的延迟时间
            dd_setupAnimationView(animationView: animationView, color: color, scale: scale, delay: delay, duration: duration)
        }
    }

    /// 设置单个水波纹动画视图
    /// - Parameters:
    ///   - animationView: 包含水波纹的父视图
    ///   - color: 水波纹的颜色
    ///   - scale: 水波纹的缩放倍数
    ///   - delay: 动画延迟时间
    ///   - duration: 动画时长
    private func dd_setupAnimationView(animationView: UIView,
                                       color: UIColor,
                                       scale: CGFloat,
                                       delay: CFTimeInterval,
                                       duration: TimeInterval)
    {
        let waveView = UIView(frame: animationView.bounds) // 创建水波纹视图
        waveView.backgroundColor = color // 设置水波纹的背景颜色
        waveView.layer.cornerRadius = animationView.layer.cornerRadius // 设置水波纹的圆角
        waveView.layer.masksToBounds = true // 保证水波纹不超出父视图边界
        animationView.addSubview(waveView) // 将水波纹视图添加到动画视图

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // 水波纹的透明度动画
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = duration
            opacityAnimation.repeatCount = MAXFLOAT // 无限循环
            waveView.layer.add(opacityAnimation, forKey: "opacityAnimation")

            // 水波纹的缩放动画
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = scale
            scaleAnimation.duration = duration
            scaleAnimation.repeatCount = MAXFLOAT // 无限循环
            waveView.layer.add(scaleAnimation, forKey: "scaleAnimation")
        }
    }

    /// 停止水波纹动画
    /// 移除水波纹动画视图
    final func dd_stopWaterWaveAnimation() {
        if let view = superview?.viewWithTag(3257) {
            view.removeFromSuperview() // 从父视图移除水波纹动画视图
        }
    }
}

// MARK: - 角标(徽章)
public extension UIView {
    /// 添加角标
    /// - Parameter number: 角标的数字，"0" 表示移除角标，"" 表示显示小红点（无数字）
    ///
    /// 示例：
    /// ```swift
    /// view.dd_customBadge("99")
    /// ```
    func dd_customBadge(_ number: String) {
        var badgeLabel: UILabel? = viewWithTag(6202) as? UILabel
        if number == "0" {
            self.dd_removeCustomBadege() // 如果数字为 0，则移除角标
            return
        }

        if badgeLabel == nil {
            badgeLabel = UILabel()
                .dd_text(number)
                .dd_textColor("#FFFFFF".dd_toUIColor()) // 设置文本颜色为白色
                .dd_backgroundColor("#EE0565".dd_toUIColor()) // 设置背景颜色为红色
                .dd_font(.dd_system(.regular, size: 10))
                .dd_textAlignment(.center)
                .dd_tag(6202) // 设置角标的唯一标签
                .dd_add2(self) // 将角标添加到当前视图
        }

        badgeLabel?
            .dd_text((number.dd_toInt()) > 99 ? "99+" : number) // 如果角标数字大于 99，则显示 "99+"
            .dd_cornerRadius(2.5) // 设置角标的圆角
            .dd_masksToBounds(true) // 确保圆角有效

        badgeLabel?.translatesAutoresizingMaskIntoConstraints = false // 禁用自动布局转换
        if number.isEmpty {
            // 设置小红点的宽度和高度约束
            let widthCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: 5
            )
            let heightCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 5
            )
            // 设置角标的位置约束
            let centerXCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0
            )
            let centerYCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 0
            )
            addConstraints([widthCons, heightCons, centerXCons, centerYCons]) // 添加约束
        } else {
            var textWidth = (badgeLabel?.dd_calculateSize().width ?? 0) + 10
            textWidth = max(textWidth, 16) // 确保角标宽度至少为 16

            // 设置角标的宽度和高度约束
            let widthCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: textWidth
            )
            let heightCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 16
            )
            // 设置角标的位置约束
            let centerXCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0
            )
            let centerYCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 0
            )
            addConstraints([widthCons, heightCons, centerXCons, centerYCons]) // 添加约束
        }
    }

    /// 移除角标
    /// 清除当前视图上的角标
    func dd_removeCustomBadege() {
        DispatchQueue.main.async {
            let badge = self.viewWithTag(6202) // 根据标签查找角标视图
            badge?.removeFromSuperview() // 移除角标视图
        }
    }
}

// MARK: - 水印
public extension UIView {
    /// 为`UIView`添加文字水印
    /// - Parameters:
    ///   - text: 水印文字
    ///   - textColor: 水印文字颜色，默认为黑色
    ///   - font: 水印文字的字体和大小，默认为系统字体12号
    ///
    /// 示例：
    /// ```swift
    /// view.dd_addWatermark("Confidential", textColor: .gray, font: UIFont.boldSystemFont(ofSize: 14))
    /// ```
    func dd_addWatermark(
        _ text: String,
        textColor: UIColor = UIColor.black,
        font: UIFont = UIFont.systemFont(ofSize: 12)
    ) {
        // 将文字转换为NSString格式
        let waterMark = text.dd_toNSString()

        // 计算水印文字的大小
        let textSize = waterMark.size(withAttributes: [NSAttributedString.Key.font: font])

        // 计算水印可以显示多少行
        let rowNum = NSInteger(bounds.height * 3.5 / 80) // 水平间隔
        // 计算水印可以显示多少列
        let colNum = NSInteger(bounds.width / text.dd_calculateSize(forWidth: bounds.width, font: font).width)

        // 循环创建水印文字
        for i in 0 ..< rowNum {
            for j in 0 ..< colNum {
                let textLayer: CATextLayer = .init()
                // 设置textLayer的缩放比例，确保在不同分辨率下清晰显示
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = font
                textLayer.fontSize = font.pointSize
                textLayer.foregroundColor = textColor.cgColor // 设置水印颜色
                textLayer.string = waterMark // 设置水印内容
                // 设置文字的位置和大小
                textLayer.frame = CGRect(x: CGFloat(j) * (textSize.width + 30), y: CGFloat(i) * 60, width: textSize.width, height: textSize.height)
                // 旋转水印文字
                textLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi * 0.2), 0, 0, 3)
                layer.addSublayer(textLayer) // 将水印文字添加到视图的图层上
            }
        }
    }
}

// MARK: - 抖动效果
public extension UIView {
    /// 抖动方向
    enum ShakeDirection {
        /// 左右抖动
        case horizontal
        /// 上下抖动
        case vertical
    }

    /// 抖动动画类型
    enum ShakeAnimation {
        /// 线性动画
        case linear
        /// easeIn 动画
        case easeIn
        /// easeOut 动画
        case easeOut
        /// easeInOut 动画
        case easeInOut
    }

    /// 让`UIView`抖动
    /// - Parameters:
    ///   - shakeDirection: 抖动方向(水平或垂直)，默认为水平
    ///   - shakeAnimation: 动画类型，默认为.easeOut
    ///   - duration: 动画持续时间，以秒为单位，默认值为1秒
    ///   - completion: 动画完成后的回调，默认为nil
    ///
    /// 示例：
    /// ```swift
    /// view.dd_shake(shakeDirection: .horizontal, shakeAnimation: .easeInOut, duration: 1.5) {
    ///     print("Shake animation completed!")
    /// }
    /// ```
    func dd_shake(shakeDirection: ShakeDirection = .horizontal,
                  shakeAnimation: ShakeAnimation = .easeOut,
                  duration: TimeInterval = 1,
                  completion: (() -> Void)? = nil)
    {
        CATransaction.begin() // 开始动画事务

        // 根据方向选择抖动的动画类型
        let animation = switch shakeDirection {
        case .horizontal:
            CAKeyframeAnimation(keyPath: "transform.translation.x") // 水平抖动
        case .vertical:
            CAKeyframeAnimation(keyPath: "transform.translation.y") // 垂直抖动
        }

        // 设置动画的时间函数（平滑动画曲线）
        switch shakeAnimation {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }

        CATransaction.setCompletionBlock(completion) // 设置动画完成后的回调

        animation.duration = duration // 设置动画持续时间
        // 设置抖动的关键帧动画值
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]

        layer.add(animation, forKey: "shake") // 将动画添加到视图的图层
        CATransaction.commit() // 提交动画事务
    }
}

// MARK: - 粒子发射器
public extension UIView {
    /// 粒子发射器样式
    /// 用于配置粒子发射器和粒子的行为
    class EmitterStyle: NSObject {
        /*------------------- 粒子发射器 -------------------*/
        /// 是否开启三维效果，默认为true
        public var preservesDepth: Bool = true
        /// 发射器的发射位置，默认为屏幕中心下方
        public var emitterPosition: CGPoint = .init(x: ScreenInfo.screenWidth / 2.0, y: UIScreen.main.bounds.height - 30)
        /// 发射器的形状，默认为球型
        public var emitterShape: CAEmitterLayerEmitterShape = .sphere

        /*------------------- 粒子单元 -------------------*/
        /// 粒子的缩放比例，默认为0.7
        public var cellScale: CGFloat = 0.7
        /// 缩放比例范围，默认为0.3
        public var cellScaleRange: CGFloat = 0.3
        /// 粒子的生命周期，默认为3秒
        public var cellEmitterLifetime: Float = 3
        /// 生命周期增减范围，默认为3秒
        public var cellLifetimeRange: Float = 3
        /// 粒子每秒的发射量，默认为10个
        public var cellEmitterBirthRate: Float = 10
        /// 粒子的颜色，默认为白色
        public var cellColor: UIColor = .white
        /// 粒子的旋转速度，默认为π/2
        public var cellSpin: CGFloat = .init(Double.pi / 2)
        /// 粒子的旋转速度范围，默认为π/4
        public var cellSpinRange: CGFloat = .init(Double.pi / 4)
        /// 粒子的初始运动速度，默认为150
        public var cellVelocity: CGFloat = 150
        /// 速度范围，默认为100
        public var cellVelocityRange: CGFloat = 100
        /// 粒子的发射方向，默认为-π/2
        public var cellEmissionLongitude: CGFloat = .init(-Double.pi / 2)
        /// 粒子发射角度范围，默认为π/5
        public var cellEmissionRange: CGFloat = .init(Double.pi / 5)

        /// 粒子是否只发射一次，默认为false
        public var cellFireOnce: Bool = false
    }

    /// 启动粒子发射器
    /// - Parameters:
    ///   - emitterImageNames: 粒子单元图片名称数组
    ///   - style: 粒子发射器和粒子的样式配置
    /// - Returns: 返回`CAEmitterLayer`实例
    @discardableResult
    func dd_startEmitter(emitterImageNames: [String], style: EmitterStyle = EmitterStyle()) -> CAEmitterLayer {
        // 创建粒子发射器
        let emitter = CAEmitterLayer()
        emitter.backgroundColor = UIColor.brown.cgColor
        emitter.emitterPosition = style.emitterPosition // 设置发射器位置
        emitter.preservesDepth = style.preservesDepth // 开启或关闭三维效果

        // 创建粒子单元，并设置其相关属性
        let cells = dd_createEmitterCell(emitterImageNames: emitterImageNames, style: style)
        emitter.emitterCells = cells // 设置粒子单元到发射器中

        // 将粒子发射器添加到视图的图层中
        layer.addSublayer(emitter)

        // 如果粒子只发射一次，设置发射速率为0，然后停止发射
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard style.cellFireOnce else { return }
            emitter.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dd_stopEmitter()
            }
        }
        return emitter
    }

    /// 停止粒子发射器
    func dd_stopEmitter() {
        // 删除所有类型为`CAEmitterLayer`的子图层
        _ = layer.sublayers?.filter {
            $0.isKind(of: CAEmitterLayer.self)
        }.map {
            $0.removeFromSuperlayer()
        }
    }

    /// 创建粒子单元并设置其属性
    /// - Parameters:
    ///   - emitterImageNames: 粒子单元的图片名称数组
    ///   - style: 粒子发射器和粒子的样式配置
    /// - Returns: 返回设置好的粒子单元数组
    private func dd_createEmitterCell(emitterImageNames: [String], style: EmitterStyle) -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = []

        // 为每个图片名称创建一个粒子单元
        for emitterImageName in emitterImageNames {
            let cell = CAEmitterCell()
            // 设置粒子的运动速度
            cell.velocity = style.cellVelocity
            cell.velocityRange = style.cellVelocityRange
            // 设置粒子的旋转速度
            cell.spin = style.cellSpin
            cell.spinRange = style.cellSpinRange
            // 设置粒子的大小
            cell.scale = style.cellScale
            cell.scaleRange = style.cellScaleRange
            // 设置粒子的发射方向
            cell.emissionLongitude = style.cellEmissionLongitude
            cell.emissionRange = style.cellEmissionRange
            // 设置粒子的生命周期
            cell.lifetime = style.cellEmitterLifetime
            cell.lifetimeRange = style.cellLifetimeRange
            // 设置粒子每秒弹出的个数
            cell.birthRate = style.cellEmitterBirthRate
            // 设置粒子显示的图片
            cell.contents = UIImage(named: emitterImageName)?.cgImage
            // 设置粒子的颜色
            cell.color = style.cellColor.cgColor
            // 添加粒子单元到数组中
            cells.append(cell)
        }

        return cells
    }
}

// MARK: - 截图
public extension UIView {
    /// 截取整个视图的快照(截图)
    /// - Returns: 返回当前视图的截图，类型为`UIImage`。如果截图失败返回`nil`。
    /// - Example:
    ///   ```swift
    ///   if let screenshot = view.dd_captureScreenshot() {
    ///       // 使用截图
    ///   }
    ///   ```
    @objc func dd_captureScreenshot() -> UIImage? {
        // 获取屏幕分辨率，适配高分辨率设备
        let scale = UIScreen.main.scale
        // 创建图形上下文，设置为与视图大小一致，并根据屏幕分辨率来缩放
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)

        // 获取当前的图形上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext() // 无法获取上下文时结束上下文
            return nil
        }

        // 渲染视图的图层到图形上下文中
        layer.render(in: context)

        // 从当前图形上下文中获取图像
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()

        // 结束图形上下文
        UIGraphicsEndImageContext()

        // 返回截图
        return viewImage
    }

    /// 将当前视图渲染为图片，并根据指定的区域裁剪。
    ///
    /// 此方法会将整个视图渲染为一张图片，并根据提供的裁剪区域 (`rect`) 返回裁剪后的图片。
    ///
    /// - Parameter rect: 需要裁剪的区域，相对于视图坐标的矩形。
    /// - Returns: 裁剪后的图片（`UIImage`），如果渲染失败或裁剪区域无效则返回 `nil`。
    ///
    /// 示例：
    /// ```swift
    /// let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    /// view.backgroundColor = .red
    /// let cropRect = CGRect(x: 50, y: 50, width: 100, height: 100)
    ///
    /// if let croppedImage = view.dd_viewToImage(rect: cropRect) {
    ///     print("裁剪成功，图片大小：\(croppedImage.size)")
    /// } else {
    ///     print("裁剪失败")
    /// }
    /// ```
    func dd_viewToImage(rect: CGRect) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let viewImage = renderer.image { context in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return viewImage.dd_cropped(to: rect)
    }
}

// MARK: - 过渡动画效果
public extension UIView {
    /// view淡入效果(从透明到不透明)
    /// - Parameters:
    ///   - duration: 动画持续时间，以秒为单位，默认值为1秒。
    ///   - completion: 动画完成后的回调，默认值为`nil`。
    /// - Example:
    ///   ```swift
    ///   view.dd_fadeIn(duration: 2) { finished in
    ///       if finished {
    ///           print("淡入动画完成")
    ///       }
    ///   }
    ///   ```
    func dd_fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        // 如果视图被隐藏，则首先显示视图
        if isHidden { isHidden = false }

        // 执行淡入动画，将视图的透明度从0变为1
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// view淡出效果(从不透明到透明)
    /// - Parameters:
    ///   - duration: 动画持续时间，以秒为单位，默认值为1秒。
    ///   - completion: 动画完成后的回调，默认值为`nil`。
    /// - Example:
    ///   ```swift
    ///   view.dd_fadeOut(duration: 1) { finished in
    ///       if finished {
    ///           print("淡出动画完成")
    ///       }
    ///   }
    ///   ```
    func dd_fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        // 如果视图被隐藏，则首先显示视图
        if isHidden { isHidden = false }

        // 执行淡出动画，将视图的透明度从1变为0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
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

// MARK: - 链式语法
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

    /// 把`self`添加到父视图
    /// - Parameter superview: 父视图，`self`将被添加为该视图的子视图
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_add2(someSuperview)
    ///   ```
    @discardableResult
    func dd_add2(_ superview: UIView?) -> Self {
        if let superview {
            superview.addSubview(self)
            if self.needsLayoutUpdate {
                self.calculateLayout()
            }
        }
        return self
    }

    /// 添加子控件数组到当前视图上
    /// - Parameter subviews: 要添加的子控件数组
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_addSubviews([button, label])
    ///   ```
    @discardableResult
    func dd_addSubviews(_ subviews: [UIView]) -> Self {
        subviews.forEach { self.addSubview($0) }
        return self
    }

    /// 设置是否裁剪超出部分
    /// - Parameter clipsToBounds: 是否裁剪超出部分，`true`裁剪，`false`不裁剪
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_clipsToBounds(true)
    ///   ```
    @discardableResult
    func dd_clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }

    /// 设置是否`layer.masksToBounds`
    /// - Parameter masksToBounds: 是否裁切，`true`表示裁切，`false`表示不裁切
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_masksToBounds(true)
    ///   ```
    @discardableResult
    func dd_masksToBounds(_ masksToBounds: Bool) -> Self {
        self.layer.masksToBounds = masksToBounds
        return self
    }

    /// 设置`layer.cornerRadius`
    /// - Parameter cornerRadius: 圆角半径，设置为0表示没有圆角
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_cornerRadius(10)
    ///   ```
    @discardableResult
    func dd_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.layer.cornerRadius = cornerRadius
        return self
    }

    /// 设置`tag`
    /// - Parameter tag: 要设置的`tag`数值
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_tag(123)
    ///   ```
    @discardableResult
    func dd_tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }

    /// 设置内容填充模式
    /// - Parameter mode: 填充模式，例如 `.scaleAspectFit` 或 `.scaleToFill`
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   imageView.dd_contentMode(.scaleAspectFit)
    ///   ```
    @discardableResult
    func dd_contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }

    /// 设置是否允许用户交互
    /// - Parameter isUserInteractionEnabled: 是否允许交互，`true`表示允许交互，`false`表示禁用交互
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_isUserInteractionEnabled(true)
    ///   ```
    @discardableResult
    func dd_isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    /// 设置界面样式
    /// - Parameter userInterfaceStyle: 设置界面风格，默认为 `.light`，可以选择 `.dark` 或 `.light`
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_userInterfaceStyle(.dark)
    ///   ```
    @available(iOS 12.0, *)
    @discardableResult
    func dd_userInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle = .light) -> Self {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    /// 设置是否隐藏视图
    /// - Parameter isHidden: 是否隐藏视图，`true`表示隐藏，`false`表示显示
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_isHidden(true)
    ///   ```
    @discardableResult
    func dd_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置透明度
    /// - Parameter alpha: 透明度值，范围为`0.0`到`1.0`，`0.0`为完全透明，`1.0`为完全不透明
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_alpha(0.5)
    ///   ```
    @discardableResult
    func dd_alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    /// 设置`backgroundColor`
    /// - Parameter color: 背景颜色
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_backgroundColor(.blue)
    ///   ```
    @discardableResult
    @objc func dd_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    /// 设置`tintColor`
    /// - Parameter tintColor: 调整视图的 tintColor
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   button.dd_tintColor(.red)
    ///   ```
    @discardableResult
    @objc func dd_tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }

    /// 设置`layer.borderColor`
    /// - Parameter color: 边框颜色
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_borderColor(.green)
    ///   ```
    @discardableResult
    func dd_borderColor(_ color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        return self
    }

    /// 设置`layer.borderWidth`
    /// - Parameter width: 边框宽度，默认为`0.5`
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_borderWidth(2.0)
    ///   ```
    @discardableResult
    func dd_borderWidth(_ width: CGFloat = 0.5) -> Self {
        self.layer.borderWidth = width
        return self
    }

    /// 离屏渲染 + 栅格化 - 异步绘制之后, 会生成一张独立的图像，停止滚动后可以监听
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_rasterize()
    ///   ```
    @discardableResult
    func dd_rasterize() -> Self {
        self.layer.drawsAsynchronously = true
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化，`true`表示开启，`false`表示关闭
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_shouldRasterize(true)
    ///   ```
    @discardableResult
    func dd_shouldRasterize(_ rasterize: Bool) -> Self {
        self.layer.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 光栅化比例，通常为`UIScreen.main.scale`，用于优化性能
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_rasterizationScale(UIScreen.main.scale)
    ///   ```
    @discardableResult
    func dd_rasterizationScale(_ scale: CGFloat) -> Self {
        self.layer.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_shadowColor(.black)
    ///   ```
    @discardableResult
    func dd_shadowColor(_ color: UIColor) -> Self {
        self.layer.shadowColor = color.cgColor
        return self
    }

    /// 设置阴影偏移
    /// - Parameter offset: 阴影的偏移量，正值表示偏向右下，负值偏向左上
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_shadowOffset(CGSize(width: 0, height: 2))
    ///   ```
    @discardableResult
    func dd_shadowOffset(_ offset: CGSize) -> Self {
        self.layer.shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius: 阴影的圆角半径，设置为`0`表示没有圆角
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_shadowRadius(5)
    ///   ```
    @discardableResult
    func dd_shadowRadius(_ radius: CGFloat) -> Self {
        self.layer.shadowRadius = radius
        return self
    }

    /// 设置阴影不透明度
    /// - Parameter opacity: 阴影的透明度，范围是`0.0`到`1.0`，`0.0`表示完全透明，`1.0`表示完全不透明
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_shadowOpacity(0.5)
    ///   ```
    @discardableResult
    func dd_shadowOpacity(_ opacity: Float) -> Self {
        self.layer.shadowOpacity = opacity
        return self
    }

    /// 设置阴影路径
    /// - Parameter path: 用于阴影的`CGPath`路径，通常设置为视图的`boundingPath`，以优化阴影渲染性能
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   let path = UIBezierPath(rect: view.bounds).cgPath
    ///   view.dd_shadowPath(path)
    ///   ```
    @discardableResult
    func dd_shadowPath(_ path: CGPath) -> Self {
        self.layer.shadowPath = path
        return self
    }
}

// MARK: - 链式语法-手势相关
public extension UIView {
    /// 添加识别器到`self`
    /// - Parameter recognizer: 要添加的手势识别器
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_applyGesture(tapGesture)
    ///   ```
    @discardableResult
    func dd_applyGesture(_ recognizer: UIGestureRecognizer) -> Self {
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(recognizer)
        return self
    }

    /// 添加多个识别器到`self`
    /// - Parameter recognizers: 手势识别器数组
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_applyGestures([tapGesture, panGesture])
    ///   ```
    @discardableResult
    func dd_applyGestures(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            self.dd_applyGesture(recognizer)
        }
        return self
    }

    /// 从`self`中移除指定的手势识别器数组
    /// - Parameter recognizers: 要移除的手势识别器数组
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_removeGestures([tapGesture, panGesture])
    ///   ```
    @discardableResult
    func dd_removeGestures(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            self.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 删除所有手势识别器
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_removeAllGesture()
    ///   ```
    @discardableResult
    func dd_removeAllGesture() -> Self {
        self.gestureRecognizers?.forEach { recognizer in
            self.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 添加`UITapGestureRecognizer`(点击)
    /// - Parameter closure: 点击事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_applyTappedGesture { recognizer in
    ///       print("Tapped!")
    ///   }
    ///   ```
    @discardableResult
    func dd_applyTappedGesture(_ closure: @escaping (_ recognizer: UITapGestureRecognizer) -> Void) -> Self {
        let gesture = UITapGestureRecognizer(target: nil, action: nil)
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UITapGestureRecognizer {
                closure(recognizer)
            }
        }
        return self.dd_applyGesture(gesture)
    }

    /// 添加`UILongPressGestureRecognizer`(长按)
    /// - Parameters:
    ///   - closure: 长按事件的处理闭包
    ///   - minimumPressDuration: 最小长按持续时间
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_applyLongPressGesture(for: 1.0) { recognizer in
    ///       print("Long pressed!")
    ///   }
    ///   ```
    @discardableResult
    func dd_applyLongPressGesture(_ closure: @escaping (_ recognizer: UILongPressGestureRecognizer) -> Void, for minimumPressDuration: TimeInterval) -> Self {
        let gesture = UILongPressGestureRecognizer(target: nil, action: nil)
        gesture.minimumPressDuration = minimumPressDuration
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UILongPressGestureRecognizer {
                closure(recognizer)
            }
        }
        return self.dd_applyGesture(gesture)
    }

    /// 添加`UIPanGestureRecognizer`(拖拽)
    /// - Parameter closure: 拖拽事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_applyPanGesture { recognizer in
    ///       print("Panned!")
    ///   }
    ///   ```
    @discardableResult
    func dd_applyPanGesture(_ closure: @escaping (_ recognizer: UIPanGestureRecognizer) -> Void) -> Self {
        let gesture = UIPanGestureRecognizer(target: nil, action: nil)
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 3
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UIPanGestureRecognizer,
               let senderView = recognizer.view
            {
                let translate: CGPoint = recognizer.translation(in: senderView.superview)
                senderView.center = CGPoint(x: senderView.center.x + translate.x, y: senderView.center.y + translate.y)
                recognizer.setTranslation(.zero, in: senderView.superview)
                closure(recognizer)
            }
        }
        return self.dd_applyGesture(gesture)
    }

    /// 添加`UIScreenEdgePanGestureRecognizer`(屏幕边缘拖拽)
    /// - Parameters:
    ///   - closure: 屏幕边缘拖拽事件的处理闭包
    ///   - edges: 屏幕边缘方向
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_applyScreenEdgePanGesture(for: .left) { recognizer in
    ///       print("Edge pan!")
    ///   }
    ///   ```
    @discardableResult
    func dd_applyScreenEdgePanGesture(_ closure: @escaping (_ recognizer: UIScreenEdgePanGestureRecognizer) -> Void, for edges: UIRectEdge) -> Self {
        let gesture = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        gesture.edges = edges
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UIScreenEdgePanGestureRecognizer {
                closure(recognizer)
            }
        }
        return self.dd_applyGesture(gesture)
    }

    /// 添加`UISwipeGestureRecognizer`(轻扫)
    /// - Parameters:
    ///   - closure: 轻扫事件的处理闭包
    ///   - direction: 轻扫方向
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_addSwipeGesture(for: .left) { recognizer in
    ///       print("Swiped!")
    ///   }
    ///   ```
    @discardableResult
    func dd_addSwipeGesture(_ closure: @escaping (_ recognizer: UISwipeGestureRecognizer) -> Void, for direction: UISwipeGestureRecognizer.Direction) -> Self {
        let gesture = UISwipeGestureRecognizer(target: nil, action: nil)
        gesture.direction = direction
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UISwipeGestureRecognizer {
                closure(recognizer)
            }
        }
        return self.dd_applyGesture(gesture)
    }

    /// 添加`UIPinchGestureRecognizer`(捏合)
    /// - Parameter closure: 捏合事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_addPinchGesture { recognizer in
    ///       print("Pinched!")
    ///   }
    ///   ```
    @discardableResult
    func dd_addPinchGesture(_ closure: @escaping (_ recognizer: UIPinchGestureRecognizer) -> Void) -> Self {
        let gesture = UIPinchGestureRecognizer(target: nil, action: nil)
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: recognizer.view!.superview)
                recognizer.view!.center = location
                recognizer.view!.transform = recognizer.view!.transform.scaledBy(
                    x: recognizer.scale,
                    y: recognizer.scale
                )
                recognizer.scale = 1.0
                closure(recognizer)
            }
        }
        return self.dd_applyGesture(gesture)
    }

    /// 添加`UIRotationGestureRecognizer`(旋转)
    /// - Parameter closure: 旋转事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd_addRotationGesture { recognizer in
    ///       print("Rotated!")
    ///   }
    ///   ```
    @discardableResult
    func dd_applyRotationGesture(_ closure: @escaping (_ recognizer: UIRotationGestureRecognizer) -> Void) -> Self {
        let gesture = UIRotationGestureRecognizer(target: nil, action: nil)
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UIRotationGestureRecognizer {
                recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
                recognizer.rotation = 0.0
                closure(recognizer)
            }
        }
        return self.dd_applyGesture(gesture)
    }
}

// MARK: - 圆角
public extension UIView {
    /// 设置圆角（⚠️前提: 需要视图的 `frame` 已经确定）
    /// - Parameters:
    ///   - radius: 圆角的半径
    ///   - corners: 需要设置圆角的角（例如 `.topLeft`, `.topRight`, `.allCorners` 等）
    /// - Returns: 当前视图 `self`，以支持链式调用
    /// - Example:
    /// ```swift
    /// view.dd_applyCorner(radius: 10, corners: .topLeft)
    /// ```
    @discardableResult
    func dd_applyCorner(radius: CGFloat, corners: UIRectCorner) -> Self {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape

        return self
    }
}
