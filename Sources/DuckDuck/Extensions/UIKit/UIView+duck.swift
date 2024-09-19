//
//  UIView+duck.swift
//
//
//  Created by 王哥 on 2024/6/18.
//

import UIKit

// MARK: - 布局相关计算属性
public extension UIView {
    /// 控件的`frame`
    var dd_frame: CGRect {
        get { return self.frame }
        set { self.frame = newValue }
    }

    /// 控件的`bounds`
    var dd_bounds: CGRect {
        get { return self.bounds }
        set { self.bounds = CGRect(origin: .zero, size: newValue.size) }
    }

    /// 控件的`origin`
    var dd_origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame = CGRect(origin: newValue, size: self.dd_size) }
    }

    /// 控件`x`
    var dd_left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(origin: CGPoint(x: newValue, y: self.dd_origin.y), size: self.dd_size) }
    }

    /// 控件右边`maxX`
    var dd_right: CGFloat {
        get { return self.frame.maxX }
        set { self.frame = CGRect(origin: CGPoint(x: newValue - self.dd_width, y: self.dd_top), size: self.dd_size) }
    }

    /// 控件`y`
    var dd_top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame = CGRect(origin: CGPoint(x: self.dd_origin.x, y: newValue), size: self.dd_size) }
    }

    /// 控件底部`maxY`
    var dd_bottom: CGFloat {
        get { return self.frame.maxY }
        set { self.frame = CGRect(origin: CGPoint(x: self.dd_left, y: newValue - self.dd_height), size: self.dd_size) }
    }

    /// 控件的`size`
    var dd_size: CGSize {
        get { return self.frame.size }
        set { self.frame = CGRect(origin: self.dd_origin, size: newValue) }
    }

    /// 控件的`width`
    var dd_width: CGFloat {
        get { return self.frame.width }
        set { self.frame = CGRect(origin: self.dd_origin, size: CGSize(width: newValue, height: self.dd_size.height)) }
    }

    /// 控件的`height`
    var dd_height: CGFloat {
        get { return self.frame.height }
        set { self.frame = CGRect(origin: self.dd_origin, size: CGSize(width: self.dd_size.width, height: newValue)) }
    }

    /// 以`bounds`为基准的中心点(只读)
    var dd_middle: CGPoint {
        return CGPoint(x: self.dd_width / 2, y: self.dd_height / 2)
    }

    /// 以`frame`为基准的中心点
    var dd_center: CGPoint {
        get { return self.dd_center }
        set { self.dd_center = newValue }
    }

    /// 控件中心点`x`
    var dd_centerX: CGFloat {
        get { return self.center.x }
        set { self.dd_center = CGPoint(x: newValue, y: self.dd_center.y) }
    }

    /// 控件中心点`y`
    var dd_centerY: CGFloat {
        get { return self.dd_center.y }
        set { self.center = CGPoint(x: self.dd_center.x, y: newValue) }
    }
}

// MARK: - 计算属性
public extension UIView {
    /// 获取`self`的布局方向
    func dd_layoutDirection() -> UIUserInterfaceLayoutDirection {
        if #available(iOS 10.0, macCatalyst 13.0, tvOS 10.0, *) {
            return self.effectiveUserInterfaceLayoutDirection
        } else {
            return .leftToRight
        }
    }

    /// `self`所在控制器
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

    /// 递归查找`self`及子视图中的第一响应者
    func dd_firstResponder() -> UIView? {
        if self.isFirstResponder { return self }
        for subView in self.subviews {
            if let firstResponder = subView.dd_firstResponder() {
                return firstResponder
            }
        }
        return nil
    }

    /// 查找`self`的所有子视图(递归)
    func dd_allSubViews() -> [UIView] {
        var subviews = [UIView]()
        for subView in self.subviews {
            subviews.append(subView)
            if !subView.subviews.isEmpty { subviews += subView.dd_allSubViews() }
        }
        return subviews
    }
}

// MARK: - 常用方法
public extension UIView {
    /// 为当前视图的子视图添加边框及背景颜色(只在Debug环境生效)
    /// - Parameters:
    ///   - borderWidth: 视图的边框宽度
    ///   - borderColor: 视图的边框颜色
    ///   - backgroundColor: 视图的背景色
    func dd_stressView(_ borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.dd_random(), backgroundColor: UIColor = UIColor.dd_random()) {
        guard DDHelper.isDebug else { return }
        guard self.subviews.count > 0 else { return }

        for subview in self.subviews {
            subview.layer.borderWidth = borderWidth
            subview.layer.borderColor = borderColor.cgColor
            subview.backgroundColor = backgroundColor
            subview.dd_stressView(borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
        }
    }

    /// 移除所有的子视图
    func dd_removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }

    /// 隐藏键盘
    func dd_hideKeyboard() {
        self.endEditing(true)
    }

    /// 判断`point`是否位于当前视图中
    /// - Parameter point: 位置点
    /// - Returns: 是否位于当前视图中
    func dd_contains(_ point: CGPoint) -> Bool {
        return point.x > self.frame.minX && point.x < self.frame.maxX && point.y > self.frame.minY && point.y < self.frame.maxY
    }

    /// 判断当前视图是否包涵类型的子视图
    /// - Parameter name: 要查询的类型
    /// - Returns: 是否包涵
    func dd_contains<T: UIView>(withClass name: T.Type) -> Bool {
        if self.isKind(of: T.self) { return true }
        for subView in self.subviews {
            if subView.dd_contains(withClass: T.self) { return true }
        }
        return false
    }

    /// 查找`T`类型的父视图, 直到找到为止
    /// - Parameter name: 要查找的类型
    func dd_findSuperview<T: UIView>(withClass name: T.Type) -> T? {
        return self.dd_findSuperview(where: { $0 is T }) as? T
    }

    /// 查找符合条件的父视图
    /// - Parameter predicate: 条件
    func dd_findSuperview(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(self.superview) { return self.superview }
        return self.superview?.dd_findSuperview(where: predicate)
    }

    /// 查找与`T`一样的子视图, 直到找到为止
    /// - Parameter name: 要查找的类型
    func dd_findSubview<T: UIView>(withClass name: T.Type) -> T? {
        return self.dd_findSubview(where: { $0 is T }) as? T
    }

    /// 查找符合条件的子视图
    /// - Parameter predicate: 条件
    func dd_findSubview(where predicate: (UIView?) -> Bool) -> UIView? {
        guard self.subviews.count > 0 else { return nil }
        for subView in self.subviews {
            if predicate(subView) { return subView }
            return subView.dd_findSubview(where: predicate)
        }
        return nil
    }

    /// 查找所有与`T`一样的子视图
    /// - Parameter name: 要查找的类型
    func dd_findSubviews<T: UIView>(withClass name: T.Type) -> [T] {
        return self.dd_findSubviews(where: { $0 is T }).map { view in view as! T }
    }

    /// 查找所有符合条件的子视图
    /// - Parameter predicate: 条件
    func dd_findSubviews(where predicate: (UIView?) -> Bool) -> [UIView] {
        guard self.subviews.count > 0 else { return [] }

        var result: [UIView] = []
        for subView in self.subviews {
            if predicate(subView) { result.append(subView) }
            result += subView.dd_findSubviews(where: predicate)
        }
        return result
    }
}

// MARK: - 链式语法-布局相关设置
public extension UIView {
    /// 强制更新布局(立即更新)
    /// - Returns: `Self`
    @discardableResult
    func dd_updateLayout() -> Self {
        // 标记视图,runloop的下一个周期调用layoutSubviews
        self.setNeedsLayout()
        // 如果这个视图有被setNeedsLayout方法标记的, 会立即执行layoutSubviews方法
        self.layoutIfNeeded()
        return self
    }

    /// 设置控件`frame`
    /// - Parameter frame: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_frame(_ frame: CGRect) -> Self {
        self.dd_frame = frame
        return self
    }

    /// 设置控件的`origin`
    /// - Parameter origin: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_origin(_ origin: CGPoint) -> Self {
        self.dd_origin = origin
        return self
    }

    /// 设置控件`x`
    /// - Parameter left: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_left(_ left: CGFloat) -> Self {
        self.dd_left = left
        return self
    }

    /// 设置控件`maxX`
    /// - Parameter right: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_right(_ right: CGFloat) -> Self {
        self.dd_right = right
        return self
    }

    /// 设置控件`y`
    /// - Parameter top: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_top(_ top: CGFloat) -> Self {
        self.dd_top = top
        return self
    }

    /// 设置控件`maxY`
    /// - Parameter bottom: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_bottom(_ bottom: CGFloat) -> Self {
        self.dd_bottom = bottom
        return self
    }

    /// 设置控件`size`
    /// - Parameter size: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_size(_ size: CGSize) -> Self {
        self.dd_size = size
        return self
    }

    /// 设置控件`width`
    /// - Parameter width: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_width(_ width: CGFloat) -> Self {
        self.dd_width = width
        return self
    }

    /// 设置控件`height`
    /// - Parameter height: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_height(_ height: CGFloat) -> Self {
        self.dd_height = height
        return self
    }

    /// 设置控件`center`
    /// - Parameter center: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_center(_ center: CGPoint) -> Self {
        self.dd_center = center
        return self
    }

    /// 设置控件`center.x`
    /// - Parameter centerX: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_centerX(_ centerX: CGFloat) -> Self {
        self.dd_centerX = centerX
        return self
    }

    /// 设置控件`center.y`
    /// - Parameter centerY: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func dd_centerY(_ centerY: CGFloat) -> Self {
        self.dd_centerY = centerY
        return self
    }
}

// MARK: - 链式语法
public extension UIView {
    /// 把`self`添加到父视图
    /// - Parameter superview: 父视图
    /// - Returns: `Self`
    @discardableResult
    func dd_add2(_ superview: UIView?) -> Self {
        if let superview {
            superview.addSubview(self)
        }
        return self
    }

    /// 添加子控件数组到当前视图上
    /// - Parameter subviews: 要添加的子控件数组
    /// - Returns: `Self`
    @discardableResult
    func dd_addSubviews(_ subviews: [UIView]) -> Self {
        subviews.forEach { self.addSubview($0) }
        return self
    }

    /// 设置是否裁剪超出部分
    /// - Parameter clipsToBounds: 是否裁剪超出部分
    /// - Returns: `Self`
    @discardableResult
    func dd_clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }

    /// 设置是否`layer.masksToBounds`
    /// - Parameter masksToBounds: 是否裁切
    /// - Returns:`Self`
    @discardableResult
    func dd_masksToBounds(_ masksToBounds: Bool) -> Self {
        self.layer.masksToBounds = masksToBounds
        return self
    }

    /// 设置`layer.cornerRadius`
    /// - Parameter cornerRadius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func dd_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.layer.cornerRadius = cornerRadius
        return self
    }

    /// 设置`tag`
    /// - Parameter tag: 要设置的`tag`数值
    /// - Returns: `Self`
    @discardableResult
    func dd_tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }

    /// 内容填充模式
    /// - Parameter mode: 模式
    /// - Returns: 返回图片的模式
    @discardableResult
    func dd_contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }

    /// 设置是否允许交互
    /// - Parameter isUserInteractionEnabled: 是否允许交互
    /// - Returns: `Self`
    @discardableResult
    func dd_isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    /// 设置界面样式
    /// - Parameter userInterfaceStyle: 样式
    /// - Returns: `Self`
    @available(iOS 12.0, *)
    @discardableResult
    func dd_userInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle = .light) -> Self {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    /// 设置是否隐藏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func dd_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置透明度
    /// - Parameter alpha: 透明度
    /// - Returns: `Self`
    @discardableResult
    func dd_alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    /// 设置`backgroundColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    @objc func dd_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    /// 设置`tintColor`
    /// - Parameter tintColor: 颜色
    /// - Returns:`Self`
    @discardableResult
    @objc func dd_tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }

    /// 设置`layer.borderColor`
    /// - Parameters:
    ///   - color: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_borderColor(_ color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        return self
    }

    /// 设置`layer.borderWidth`
    /// - Parameters:
    ///   - width: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func dd_borderWidth(_ width: CGFloat = 0.5) -> Self {
        self.layer.borderWidth = width
        return self
    }

    /// 离屏渲染 + 栅格化 - 异步绘制之后,会生成一张独立的图像,停止滚动之后,可以监听
    /// - Returns: `Self`
    @discardableResult
    func dd_rasterize() -> Self {
        self.layer.drawsAsynchronously = true
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化
    /// - Returns: `Self`
    @discardableResult
    func dd_shouldRasterize(_ rasterize: Bool) -> Self {
        self.layer.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 光栅化比例
    /// - Returns: `Self`
    @discardableResult
    func dd_rasterizationScale(_ scale: CGFloat) -> Self {
        self.layer.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowColor(_ color: UIColor) -> Self {
        self.layer.shadowColor = color.cgColor
        return self
    }

    /// 设置阴影偏移
    /// - Parameter offset: 偏移
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowOffset(_ offset: CGSize) -> Self {
        self.layer.shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius: 圆角
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowRadius(_ radius: CGFloat) -> Self {
        self.layer.shadowRadius = radius
        return self
    }

    /// 设置不透明度
    /// - Parameter opacity: 不透明度
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowOpacity(_ opacity: Float) -> Self {
        self.layer.shadowOpacity = opacity
        return self
    }

    /// 设置阴影路径
    /// - Parameter path: 路径
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowPath(_ path: CGPath) -> Self {
        self.layer.shadowPath = path
        return self
    }
}

// MARK: - 链式语法-手势相关
public extension UIView {
    /// 添加识别器到`self`
    /// - Parameter recognizer: 要添加的识别器
    /// - Returns: `Self`
    @discardableResult
    func dd_addGesture(_ recognizer: UIGestureRecognizer) -> Self {
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(recognizer)
        return self
    }

    /// 添加识别器数组到`self`
    /// - Parameter recognizers: 识别器数组
    /// - Returns: `Self`
    @discardableResult
    func dd_addGestures(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            self.dd_addGesture(recognizer)
        }
        return self
    }

    /// 将数组中的手势识别器从`self`中移除
    /// - Parameter recognizers: 手势数组
    /// - Returns: `Self`
    @discardableResult
    func dd_removeGestures(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            self.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 删除所有手势识别器
    /// - Returns: `Self`
    @discardableResult
    func dd_removeAllGesture() -> Self {
        self.gestureRecognizers?.forEach { recognizer in
            self.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 添加`UITapGestureRecognizer`(点击)
    /// - Parameter block: 事件处理
    /// - Returns: `Self`
    @discardableResult
    func dd_addTapGesture(_ block: @escaping (_ recognizer: UITapGestureRecognizer) -> Void) -> Self {
        let gesture = UITapGestureRecognizer(target: nil, action: nil)
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        gesture.dd_block { recognizer in
            if let recognizer = recognizer as? UITapGestureRecognizer {
                block(recognizer)
            }
        }
        return self.dd_addGesture(gesture)
    }

    /// 添加`UILongPressGestureRecognizer`(长按)
    /// - Parameters:
    ///   - block: 事件处理
    ///   - minimumPressDuration: 最小长按时间
    /// - Returns: `Self`
    @discardableResult
    func dd_addLongPressGesture(_ block: @escaping (_ recognizer: UILongPressGestureRecognizer) -> Void, for minimumPressDuration: TimeInterval) -> Self {
        let gesture = UILongPressGestureRecognizer(target: nil, action: nil)
        gesture.minimumPressDuration = minimumPressDuration
        gesture.dd_block { recognizer in
            if let recognizer = recognizer as? UILongPressGestureRecognizer {
                block(recognizer)
            }
        }
        return self.dd_addGesture(gesture)
    }

    /// 添加`UIPanGestureRecognizer`(拖拽)
    /// - Parameter block: 事件处理
    /// - Returns: `Self`
    @discardableResult
    func dd_addPanGesture(_ block: @escaping (_ recognizer: UIPanGestureRecognizer) -> Void) -> Self {
        let gesture = UIPanGestureRecognizer(target: nil, action: nil)
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 3
        gesture.dd_block { recognizer in
            if let recognizer = recognizer as? UIPanGestureRecognizer,
               let senderView = recognizer.view
            {
                let translate: CGPoint = recognizer.translation(in: senderView.superview)
                senderView.center = CGPoint(x: senderView.center.x + translate.x, y: senderView.center.y + translate.y)
                recognizer.setTranslation(.zero, in: senderView.superview)
                block(recognizer)
            }
        }
        return self.dd_addGesture(gesture)
    }

    /// 添加`UIScreenEdgePanGestureRecognizer`(屏幕边缘拖拽)
    /// - Parameters:
    ///   - block: 事件处理
    ///   - edges: 屏幕边缘距离
    /// - Returns: `Self`
    @discardableResult
    func dd_addScreenEdgePanGesture(_ block: @escaping (_ recognizer: UIScreenEdgePanGestureRecognizer) -> Void, for edges: UIRectEdge) -> Self {
        let gesture = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        gesture.edges = edges
        gesture.dd_block { recognizer in
            if let recognizer = recognizer as? UIScreenEdgePanGestureRecognizer {
                block(recognizer)
            }
        }
        return self.dd_addGesture(gesture)
    }

    /// 添加`UISwipeGestureRecognizer`(轻扫)
    /// - Parameters:
    ///   - block: 事件处理
    ///   - direction: 轻扫方向
    /// - Returns: `Self`
    @discardableResult
    func dd_addSwipeGesture(_ block: @escaping (_ recognizer: UISwipeGestureRecognizer) -> Void, for direction: UISwipeGestureRecognizer.Direction) -> Self {
        let gesture = UISwipeGestureRecognizer(target: nil, action: nil)
        gesture.direction = direction
        gesture.dd_block { recognizer in
            if let recognizer = recognizer as? UISwipeGestureRecognizer {
                block(recognizer)
            }
        }
        return self.dd_addGesture(gesture)
    }

    /// 添加`UIPinchGestureRecognizer`(捏合)
    /// - Parameter block: 事件处理
    /// - Returns: `Self`
    @discardableResult
    func dd_addPinchGesture(_ block: @escaping (_ recognizer: UIPinchGestureRecognizer) -> Void) -> Self {
        let gesture = UIPinchGestureRecognizer(target: nil, action: nil)
        gesture.dd_block { recognizer in
            if let recognizer = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: recognizer.view!.superview)
                recognizer.view!.center = location
                recognizer.view!.transform = recognizer.view!.transform.scaledBy(
                    x: recognizer.scale,
                    y: recognizer.scale
                )
                recognizer.scale = 1.0
                block(recognizer)
            }
        }
        return self.dd_addGesture(gesture)
    }

    /// 添加`UIRotationGestureRecognizer`(旋转)
    /// - Parameter block: 事件处理
    /// - Returns: `UIRotationGestureRecognizer`
    @discardableResult
    func dd_addRotationGesture(_ block: @escaping (_ recognizer: UIRotationGestureRecognizer) -> Void) -> Self {
        let gesture = UIRotationGestureRecognizer(target: nil, action: nil)
        gesture.dd_block { recognizer in
            if let recognizer = recognizer as? UIRotationGestureRecognizer {
                recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
                recognizer.rotation = 0.0
                block(recognizer)
            }
        }
        return self.dd_addGesture(gesture)
    }
}
