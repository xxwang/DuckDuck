//
//  CALayer+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import QuartzCore
import UIKit

extension CALayer: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: CALayer {
    /// 设置 frame
    /// - Parameter frame: 需要设置的 `frame`，定义了图层的位置和大小
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.frame(CGRect(x: 10, y: 20, width: 100, height: 100))`
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.base.frame = frame
        return self
    }

    /// 添加到父视图
    /// - Parameter superView: 父视图（`UIView`），要将当前图层添加到该视图的图层中
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.add2(superView)`
    @MainActor @discardableResult
    func add2(_ superView: UIView) -> Self {
        superView.layer.addSublayer(self.base)
        return self
    }

    /// 添加到父层 (`CALayer`)
    /// - Parameter superLayer: 父层（`CALayer`），要将当前图层添加到该图层中
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.add2(superLayer)`
    @discardableResult
    func add2(_ superLayer: CALayer) -> Self {
        superLayer.addSublayer(self.base)
        return self
    }

    /// 设置背景色
    /// - Parameter color: 设置背景色的 `UIColor`
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.backgroundColor(.red)`
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.base.backgroundColor = color.cgColor
        return self
    }

    /// 设置是否隐藏图层
    /// - Parameter isHidden: 设置图层是否隐藏，`true` 隐藏，`false` 显示
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.isHidden(true)`
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.base.isHidden = isHidden
        return self
    }

    /// 设置边框宽度
    /// - Parameter width: 设置边框的宽度
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.borderWidth(2.0)`
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        self.base.borderWidth = width
        return self
    }

    /// 设置边框颜色
    /// - Parameter color: 设置边框的颜色
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.borderColor(.black)`
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        self.base.borderColor = color.cgColor
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化，开启光栅化可以提高图层的渲染性能
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.shouldRasterize(true)`
    @discardableResult
    func shouldRasterize(_ rasterize: Bool) -> Self {
        self.base.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 设置光栅化的比例，通常使用 `UIScreen.main.scale`
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.rasterizationScale(UIScreen.main.scale)`
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        self.base.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 设置阴影的颜色
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.shadowColor(.gray)`
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        self.base.shadowColor = color.cgColor
        return self
    }

    /// 设置阴影透明度
    /// - Parameter opacity: 设置阴影的透明度，范围 `0` 到 `1`
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.shadowOpacity(0.5)`
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        self.base.shadowOpacity = opacity
        return self
    }

    /// 设置阴影的偏移量
    /// - Parameter offset: 设置阴影的偏移量，使用 `CGSize` 来指定偏移
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.shadowOffset(CGSize(width: 2, height: 2))`
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        self.base.shadowOffset = offset
        return self
    }

    /// 设置阴影半径
    /// - Parameter radius: 设置阴影的半径
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.shadowRadius(5.0)`
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        self.base.shadowRadius = radius
        return self
    }

    /// 设置阴影路径
    /// - Parameter path: 设置阴影的路径，使用 `CGPath` 来定义
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.shadowPath(path)`
    @discardableResult
    func shadowPath(_ path: CGPath) -> Self {
        self.base.shadowPath = path
        return self
    }

    /// 设置是否显示阴影
    /// - Parameter hasShadow: 是否显示阴影
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CALayer()
    /// shapeLayer.dd.showShadow(true)
    /// ```
    @discardableResult
    func showShadow(_ hasShadow: Bool) -> Self {
        self.base.shadowOpacity = hasShadow ? 0.5 : 0
        return self
    }

    /// 设置透明度
    /// - Parameter opacity: 透明度值 (0.0 - 1.0)
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.opacity(0.5)
    /// ```
    @discardableResult
    func opacity(_ opacity: Float) -> Self {
        self.base.opacity = opacity
        return self
    }

    /// 设置是否裁剪图层内容
    /// - Parameter masksToBounds: 是否裁剪，`true` 表示裁剪，`false` 不裁剪
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.masksToBounds(true)`
    @discardableResult
    func masksToBounds(_ masksToBounds: Bool = true) -> Self {
        self.base.masksToBounds = masksToBounds
        return self
    }

    /// 设置圆角
    /// - Parameter cornerRadius: 圆角的半径
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.cornerRadius(10.0)`
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.base.cornerRadius = cornerRadius
        return self
    }

    /// 设置圆角，⚠️ `frame` 必须已经确定
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 设置需要圆角的角，默认是所有角
    /// - Returns: 返回 `Self` 以支持链式调用
    /// - Example: `layer.dd.corner(10.0, corners: .topLeft)`
    @discardableResult
    func corner(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        let size = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: self.base.bounds, byRoundingCorners: corners, cornerRadii: size)

        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.base.bounds
        maskLayer.path = maskPath.cgPath
        self.base.mask = maskLayer

        return self
    }

    /// 设置是否旋转
    /// - Parameter isRotated: 是否旋转
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CALayer()
    /// shapeLayer.dd.rotation(true)
    /// ```
    @discardableResult
    func rotation(_ isRotated: Bool) -> Self {
        if isRotated {
            self.base.transform = CATransform3DMakeRotation(.pi / 4, 0, 0, 1)
        }
        return self
    }

    /// 旋转图层
    /// - Parameter angle: 旋转角度（单位：弧度）
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// layer.dd.rotate(by: .pi / 4)  // 旋转图层 45 度
    /// ```
    @discardableResult
    func rotate(by angle: CGFloat) -> Self {
        // 使用 CATransform3DRotate 应用旋转变换，绕 Z 轴旋转指定角度
        self.base.transform = CATransform3DRotate(self.base.transform, angle, 0, 0, 1)
        return self
    }

    /// 缩放图层
    /// - Parameter scale: 缩放比例，值大于 1 表示放大，介于 0 和 1 之间表示缩小
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// layer.dd.scale(by: 1.5)  // 缩放图层 1.5 倍
    /// ```
    @discardableResult
    func scale(by scale: CGFloat) -> Self {
        // 使用 CATransform3DScale 应用缩放变换，等比例缩放图层（X 和 Y 轴）
        self.base.transform = CATransform3DScale(self.base.transform, scale, scale, 1)
        return self
    }

    /// 平移图层
    /// - Parameter translation: 平移位移量，x 和 y 分别表示水平方向和垂直方向的位移
    /// - Returns: `Self`，允许链式调用
    ///
    /// **示例**：
    /// ```swift
    /// layer.dd.translate(by: CGPoint(x: 100, y: 200))  // 平移图层 100 单位 x 和 200 单位 y
    /// ```
    @discardableResult
    func translate(by translation: CGPoint) -> Self {
        // 使用 CATransform3DTranslate 应用平移变换，沿 X 和 Y 轴分别移动指定的距离
        self.base.transform = CATransform3DTranslate(self.base.transform, translation.x, translation.y, 0)
        return self
    }

    /// 设置是否启用光栅化
    /// - Parameter isRasterized: 是否启用光栅化
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let shapeLayer = CAShapeLayer()
    /// shapeLayer.dd.rasterization(true)
    /// ```
    @discardableResult
    func rasterization(_ isRasterized: Bool) -> Self {
        self.base.shouldRasterize = isRasterized
        return self
    }

    /// 设置遮罩图层
    /// - Parameter mask: 遮罩
    /// - Returns: `Self`
    ///
    /// 示例:
    /// ```swift
    /// let textLayer = CALayer()
    /// let maskLayer = CALayer()
    /// textLayer.dd.mask(maskLayer)
    /// ```
    @discardableResult
    func mask(_ mask: CALayer) -> Self {
        self.base.mask = mask
        return self
    }
}
