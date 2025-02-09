import UIKit

extension UIView: DDExtensionable {}

// MARK: - 链式语法-功能方法
@MainActor
public extension DDExtension where Base: UIView {
    /// 为类型提供的功能
    /// - Parameter closure: 配置闭包
    /// - Returns: `Self`
    @discardableResult
    func apply(_ closure: (Base) -> Void) -> Self {
        closure(self.base)
        return self
    }
}

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIView {
    /// 把`self`添加到父视图
    /// - Parameter superview: 父视图，`self`将被添加为该视图的子视图
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.add2(someSuperview)
    ///   ```
    @discardableResult
    func add2(_ superview: UIView?) -> Self {
        if let superview {
            superview.addSubview(self.base)
            if self.base.needsLayoutUpdate {
                self.base.calculateLayout()
            }
        }
        return self
    }

    /// 添加子控件数组到当前视图上
    /// - Parameter subviews: 要添加的子控件数组
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.addSubviews([button, label])
    ///   ```
    @discardableResult
    func addSubviews(_ subviews: [UIView]) -> Self {
        subviews.forEach { self.base.addSubview($0) }
        return self
    }

    /// 设置是否裁剪超出部分
    /// - Parameter clipsToBounds: 是否裁剪超出部分，`true`裁剪，`false`不裁剪
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.clipsToBounds(true)
    ///   ```
    @discardableResult
    func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.base.clipsToBounds = clipsToBounds
        return self
    }

    /// 设置是否`layer.masksToBounds`
    /// - Parameter masksToBounds: 是否裁切，`true`表示裁切，`false`表示不裁切
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.masksToBounds(true)
    ///   ```
    @discardableResult
    func masksToBounds(_ masksToBounds: Bool) -> Self {
        self.base.layer.masksToBounds = masksToBounds
        return self
    }

    /// 设置`layer.cornerRadius`
    /// - Parameter cornerRadius: 圆角半径，设置为0表示没有圆角
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.cornerRadius(10)
    ///   ```
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.base.layer.cornerRadius = cornerRadius
        return self
    }

    /// 设置`tag`
    /// - Parameter tag: 要设置的`tag`数值
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.tag(123)
    ///   ```
    @discardableResult
    func tag(_ tag: Int) -> Self {
        self.base.tag = tag
        return self
    }

    /// 设置内容填充模式
    /// - Parameter mode: 填充模式，例如 `.scaleAspectFit` 或 `.scaleToFill`
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   imageView.dd.contentMode(.scaleAspectFit)
    ///   ```
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        self.base.contentMode = mode
        return self
    }

    /// 设置是否允许用户交互
    /// - Parameter isUserInteractionEnabled: 是否允许交互，`true`表示允许交互，`false`表示禁用交互
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.isUserInteractionEnabled(true)
    ///   ```
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.base.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    /// 设置界面样式
    /// - Parameter userInterfaceStyle: 设置界面风格，默认为 `.light`，可以选择 `.dark` 或 `.light`
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.userInterfaceStyle(.dark)
    ///   ```
    @available(iOS 12.0, *)
    @discardableResult
    func userInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle = .light) -> Self {
        if #available(iOS 13.0, *) {
            self.base.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    /// 设置是否隐藏视图
    /// - Parameter isHidden: 是否隐藏视图，`true`表示隐藏，`false`表示显示
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.isHidden(true)
    ///   ```
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.base.isHidden = isHidden
        return self
    }

    /// 设置透明度
    /// - Parameter alpha: 透明度值，范围为`0.0`到`1.0`，`0.0`为完全透明，`1.0`为完全不透明
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.alpha(0.5)
    ///   ```
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.base.alpha = alpha
        return self
    }

    /// 设置`backgroundColor`
    /// - Parameter color: 背景颜色
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.backgroundColor(.blue)
    ///   ```
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.base.backgroundColor = backgroundColor
        return self
    }

    /// 设置`tintColor`
    /// - Parameter tintColor: 调整视图的 tintColor
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   button.dd.tintColor(.red)
    ///   ```
    @discardableResult
    func tintColor(_ tintColor: UIColor) -> Self {
        self.base.tintColor = tintColor
        return self
    }

    /// 设置`layer.borderColor`
    /// - Parameter color: 边框颜色
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.borderColor(.green)
    ///   ```
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        self.base.layer.borderColor = color.cgColor
        return self
    }

    /// 设置`layer.borderWidth`
    /// - Parameter width: 边框宽度，默认为`0.5`
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.borderWidth(2.0)
    ///   ```
    @discardableResult
    func borderWidth(_ width: CGFloat = 0.5) -> Self {
        self.base.layer.borderWidth = width
        return self
    }

    /// 离屏渲染 + 栅格化 - 异步绘制之后, 会生成一张独立的图像，停止滚动后可以监听
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.rasterize()
    ///   ```
    @discardableResult
    func rasterize() -> Self {
        self.base.layer.drawsAsynchronously = true
        self.base.layer.shouldRasterize = true
        self.base.layer.rasterizationScale = UIScreen.main.scale
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化，`true`表示开启，`false`表示关闭
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.shouldRasterize(true)
    ///   ```
    @discardableResult
    func shouldRasterize(_ rasterize: Bool) -> Self {
        self.base.layer.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 光栅化比例，通常为`UIScreen.main.scale`，用于优化性能
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.rasterizationScale(UIScreen.main.scale)
    ///   ```
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        self.base.layer.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.shadowColor(.black)
    ///   ```
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        self.base.layer.shadowColor = color.cgColor
        return self
    }

    /// 设置阴影偏移
    /// - Parameter offset: 阴影的偏移量，正值表示偏向右下，负值偏向左上
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.shadowOffset(CGSize(width: 0, height: 2))
    ///   ```
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        self.base.layer.shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius: 阴影的圆角半径，设置为`0`表示没有圆角
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.shadowRadius(5)
    ///   ```
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        self.base.layer.shadowRadius = radius
        return self
    }

    /// 设置阴影不透明度
    /// - Parameter opacity: 阴影的透明度，范围是`0.0`到`1.0`，`0.0`表示完全透明，`1.0`表示完全不透明
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.shadowOpacity(0.5)
    ///   ```
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        self.base.layer.shadowOpacity = opacity
        return self
    }

    /// 设置阴影路径
    /// - Parameter path: 用于阴影的`CGPath`路径，通常设置为视图的`boundingPath`，以优化阴影渲染性能
    /// - Returns: 返回`Self`，以便链式调用
    /// - Example:
    ///   ```swift
    ///   let path = UIBezierPath(rect: view.bounds).cgPath
    ///   view.dd.shadowPath(path)
    ///   ```
    @discardableResult
    func shadowPath(_ path: CGPath) -> Self {
        self.base.layer.shadowPath = path
        return self
    }
}

// MARK: - 链式语法-手势相关
@MainActor
public extension DDExtension where Base: UIView {
    /// 添加识别器到`self`
    /// - Parameter recognizer: 要添加的手势识别器
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.applyGesture(tapGesture)
    ///   ```
    @discardableResult
    func applyGesture(_ recognizer: UIGestureRecognizer) -> Self {
        self.base.isUserInteractionEnabled = true
        self.base.isMultipleTouchEnabled = true
        self.base.addGestureRecognizer(recognizer)
        return self
    }

    /// 添加多个识别器到`self`
    /// - Parameter recognizers: 手势识别器数组
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.applyGestures([tapGesture, panGesture])
    ///   ```
    @discardableResult
    func applyGestures(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            self.base.dd_applyGesture(recognizer)
        }
        return self
    }

    /// 从`self`中移除指定的手势识别器数组
    /// - Parameter recognizers: 要移除的手势识别器数组
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.removeGestures([tapGesture, panGesture])
    ///   ```
    @discardableResult
    func removeGestures(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            self.base.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 删除所有手势识别器
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.removeAllGesture()
    ///   ```
    @discardableResult
    func removeAllGesture() -> Self {
        self.base.gestureRecognizers?.forEach { recognizer in
            self.base.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 添加`UITapGestureRecognizer`(点击)
    /// - Parameter closure: 点击事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.applyTappedGesture { recognizer in
    ///       print("Tapped!")
    ///   }
    ///   ```
    @discardableResult
    func applyTappedGesture(_ closure: @escaping (_ recognizer: UITapGestureRecognizer) -> Void) -> Self {
        let gesture = UITapGestureRecognizer(target: nil, action: nil)
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UITapGestureRecognizer {
                closure(recognizer)
            }
        }
        self.base.dd_applyGesture(gesture)
        return self
    }

    /// 添加`UILongPressGestureRecognizer`(长按)
    /// - Parameters:
    ///   - closure: 长按事件的处理闭包
    ///   - minimumPressDuration: 最小长按持续时间
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.applyLongPressGesture(for: 1.0) { recognizer in
    ///       print("Long pressed!")
    ///   }
    ///   ```
    @discardableResult
    func applyLongPressGesture(_ closure: @escaping (_ recognizer: UILongPressGestureRecognizer) -> Void, for minimumPressDuration: TimeInterval) -> Self {
        let gesture = UILongPressGestureRecognizer(target: nil, action: nil)
        gesture.minimumPressDuration = minimumPressDuration
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UILongPressGestureRecognizer {
                closure(recognizer)
            }
        }
        self.base.dd_applyGesture(gesture)
        return self
    }

    /// 添加`UIPanGestureRecognizer`(拖拽)
    /// - Parameter closure: 拖拽事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.applyPanGesture { recognizer in
    ///       print("Panned!")
    ///   }
    ///   ```
    @discardableResult
    func applyPanGesture(_ closure: @escaping (_ recognizer: UIPanGestureRecognizer) -> Void) -> Self {
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
        self.base.dd_applyGesture(gesture)
        return self
    }

    /// 添加`UIScreenEdgePanGestureRecognizer`(屏幕边缘拖拽)
    /// - Parameters:
    ///   - closure: 屏幕边缘拖拽事件的处理闭包
    ///   - edges: 屏幕边缘方向
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.applyScreenEdgePanGesture(for: .left) { recognizer in
    ///       print("Edge pan!")
    ///   }
    ///   ```
    @discardableResult
    func applyScreenEdgePanGesture(_ closure: @escaping (_ recognizer: UIScreenEdgePanGestureRecognizer) -> Void, for edges: UIRectEdge) -> Self {
        let gesture = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        gesture.edges = edges
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UIScreenEdgePanGestureRecognizer {
                closure(recognizer)
            }
        }
        self.base.dd_applyGesture(gesture)
        return self
    }

    /// 添加`UISwipeGestureRecognizer`(轻扫)
    /// - Parameters:
    ///   - closure: 轻扫事件的处理闭包
    ///   - direction: 轻扫方向
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.addSwipeGesture(for: .left) { recognizer in
    ///       print("Swiped!")
    ///   }
    ///   ```
    @discardableResult
    func addSwipeGesture(_ closure: @escaping (_ recognizer: UISwipeGestureRecognizer) -> Void, for direction: UISwipeGestureRecognizer.Direction) -> Self {
        let gesture = UISwipeGestureRecognizer(target: nil, action: nil)
        gesture.direction = direction
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UISwipeGestureRecognizer {
                closure(recognizer)
            }
        }
        self.base.dd_applyGesture(gesture)
        return self
    }

    /// 添加`UIPinchGestureRecognizer`(捏合)
    /// - Parameter closure: 捏合事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.addPinchGesture { recognizer in
    ///       print("Pinched!")
    ///   }
    ///   ```
    @discardableResult
    func addPinchGesture(_ closure: @escaping (_ recognizer: UIPinchGestureRecognizer) -> Void) -> Self {
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
        self.base.dd_applyGesture(gesture)
        return self
    }

    /// 添加`UIRotationGestureRecognizer`(旋转)
    /// - Parameter closure: 旋转事件的处理闭包
    /// - Returns: `Self`，以便进行链式调用
    /// - Example:
    ///   ```swift
    ///   view.dd.addRotationGesture { recognizer in
    ///       print("Rotated!")
    ///   }
    ///   ```
    @discardableResult
    func applyRotationGesture(_ closure: @escaping (_ recognizer: UIRotationGestureRecognizer) -> Void) -> Self {
        let gesture = UIRotationGestureRecognizer(target: nil, action: nil)
        gesture.dd_onRecognized { recognizer in
            if let recognizer = recognizer as? UIRotationGestureRecognizer {
                recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
                recognizer.rotation = 0.0
                closure(recognizer)
            }
        }
        self.base.dd_applyGesture(gesture)
        return self
    }
}

// MARK: - 圆角
@MainActor
public extension DDExtension where Base: UIView {
    /// 设置圆角（⚠️前提: 需要视图的 `frame` 已经确定）
    /// - Parameters:
    ///   - radius: 圆角的半径
    ///   - corners: 需要设置圆角的角（例如 `.topLeft`, `.topRight`, `.allCorners` 等）
    /// - Returns: 当前视图 `self`，以支持链式调用
    /// - Example:
    /// ```swift
    /// view.dd.applyCorner(radius: 10, corners: .topLeft)
    /// ```
    @discardableResult
    func applyCorner(radius: CGFloat, corners: UIRectCorner) -> Self {
        let maskPath = UIBezierPath(
            roundedRect: self.base.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.base.layer.mask = shape

        return self
    }
}
