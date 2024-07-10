//
//  CALayer+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import QuartzCore
import UIKit

public extension DDExtension where Base: CALayer {
    /// 图层转图片(需要图层已经有`size`)
    var as2UIImage: UIImage? {
        self.as2UIImage()
    }

    /// 图层转颜色(`UIColor`)
    /// - Returns: `UIColor?`
    var as2UIColor: UIColor? {
        if let image = self.as2UIImage {
            return UIColor(patternImage: image)
        }
        return nil
    }
}

// MARK: - 方法
public extension DDExtension where Base: CALayer {
    /// `CALayer`转`UIImage?`
    /// - Parameters:
    ///   - scale: 缩放比例
    /// - Returns: `UIImage?`
    func as2UIImage(scale: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.base.frame.size, self.base.isOpaque, scale)
        defer { UIGraphicsEndImageContext() }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.base.render(in: ctx)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - `CABasicAnimation`
public extension DDExtension where Base: CALayer {
    /// `BasicAnimation` 移动到指定`CGPoint`
    /// - Parameters:
    ///   - point: 要移动到的`Point`
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 在动画完成后是否移除动画
    ///   - option: 动画节奏控制
    func basicAnimationMovePoint(_ point: CGPoint,
                                 duration: TimeInterval,
                                 delay: TimeInterval = 0,
                                 repeatCount: Float = 1,
                                 removedOnCompletion: Bool = false,
                                 option: CAMediaTimingFunctionName = .default)
    {
        self.baseBasicAnimation(
            keyPath: "position",
            startValue: self.base.position,
            endValue: point,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `BasicAnimation``x`值移动动画
    /// - Parameters:
    ///   - moveValue: 移动到的`x`值
    ///   - duration: 动画持续时长
    ///   - delay: 延时
    ///   - repeatCount: 重复动画次数
    ///   - removedOnCompletion: 在动画完成后是否移除动画
    ///   - option: 动画节奏控制
    func basicAnimationMoveX(_ moveValue: Any?,
                             duration: TimeInterval = 2.0,
                             delay: TimeInterval = 0,
                             repeatCount: Float = 1,
                             removedOnCompletion: Bool = false,
                             option: CAMediaTimingFunctionName = .default)
    {
        self.baseBasicAnimation(
            keyPath: "transform.translation.x",
            startValue: self.base.position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `BasicAnimation` `y`值移动动画
    /// - Parameters:
    ///   - moveValue:移动到的Y值
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func basicAnimationMoveY(_ moveValue: Any?,
                             duration: TimeInterval = 2.0,
                             delay: TimeInterval = 0,
                             repeatCount: Float = 1,
                             removedOnCompletion: Bool = false,
                             option: CAMediaTimingFunctionName = .default)
    {
        self.baseBasicAnimation(
            keyPath: "transform.translation.y",
            startValue: self.base.position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `BasicAnimation`圆角动画
    /// - Parameters:
    ///   - cornerRadius:圆角大小
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationCornerRadius(_ cornerRadius: Any?,
                               duration: TimeInterval = 2.0,
                               delay: TimeInterval = 0,
                               repeatCount: Float = 1,
                               removedOnCompletion: Bool = false,
                               option: CAMediaTimingFunctionName = .default)
    {
        self.baseBasicAnimation(
            keyPath: "cornerRadius",
            startValue: self.base.position,
            endValue: cornerRadius,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `BasicAnimation`缩放动画
    /// - Parameters:
    ///   - scaleValue:缩放值
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationScale(_ scaleValue: Any?,
                        duration: TimeInterval = 2.0,
                        delay: TimeInterval = 0,
                        repeatCount: Float = 1,
                        removedOnCompletion: Bool = true,
                        option: CAMediaTimingFunctionName = .default)
    {
        self.baseBasicAnimation(
            keyPath: "transform.scale",
            startValue: 1,
            endValue: scaleValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `BasicAnimation`旋转动画
    /// - Parameters:
    ///   - rotation:旋转的角度
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationRotation(_ rotation: Any?,
                           duration: TimeInterval = 2.0,
                           delay: TimeInterval = 0,
                           repeatCount: Float = 1,
                           removedOnCompletion: Bool = true,
                           option: CAMediaTimingFunctionName = .default)
    {
        self.baseBasicAnimation(
            keyPath: "transform.rotation",
            startValue: nil,
            endValue: rotation,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CABasicAnimation`动画
    /// - Parameters:
    ///   - keyPath:动画的类型
    ///   - startValue:开始值
    ///   - endValue:结束值
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func baseBasicAnimation(keyPath: String,
                            startValue: Any?,
                            endValue: Any?,
                            duration: TimeInterval = 2.0,
                            delay: TimeInterval = 0,
                            repeatCount: Float = 1,
                            removedOnCompletion: Bool = false,
                            option: CAMediaTimingFunctionName = .default)
    {
        let basicAnimation = CABasicAnimation()
        // 几秒后执行
        basicAnimation.beginTime = CACurrentMediaTime() + delay
        // 动画的类型
        basicAnimation.keyPath = keyPath
        // 起始的值
        basicAnimation.fromValue = startValue
        // 结束的值
        basicAnimation.toValue = endValue
        // 重复的次数
        basicAnimation.repeatCount = repeatCount
        // 动画持续的时间
        basicAnimation.duration = duration
        // 动画完成之后是否移除动画
        basicAnimation.isRemovedOnCompletion = removedOnCompletion
        // 图层保持动画执行后的状态,前提是fillMode设置为kCAFillModeForwards
        basicAnimation.fillMode = .forwards
        // 运动的时间函数
        basicAnimation.timingFunction = CAMediaTimingFunction(name: option)

        // 添加动画到图层
        self.base.add(basicAnimation, forKey: nil)
    }
}

// MARK: - `CAKeyframeAnimation`动画
public extension DDExtension where Base: CALayer {
    /// `position`动画(移动是以视图的`锚点`移动的, 默认是视图的`中心点`)
    /// - Parameters:
    ///   - values:位置数组`CGPoint`
    ///   - keyTimes:位置对应的时间点数组
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画选项
    func addKeyframeAnimationPosition(_ values: [Any],
                                      keyTimes: [NSNumber]?,
                                      duration: TimeInterval = 2.0,
                                      delay: TimeInterval = 0,
                                      repeatCount: Float = 1,
                                      removedOnCompletion: Bool = false,
                                      option: CAMediaTimingFunctionName = .default)
    {
        self.baseKeyframeAnimation(
            keyPath: "position",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// 抖动动画(根据传入的弧度)
    /// - Parameters:
    ///   - values:弧度数组
    ///   - keyTimes:每帧的时间点
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除
    ///   - option:动画选项
    func addKeyframeAnimationRotation(_ values: [Any] = [
        -5.dd.as2CGFloat.dd.as2radians,
        5.dd.as2CGFloat.dd.as2radians,
        -5.dd.as2CGFloat.dd.as2radians,
    ],
    keyTimes: [NSNumber]?,
    duration: TimeInterval = 1.0,
    delay: TimeInterval = 0,
    repeatCount: Float = 1,
    removedOnCompletion: Bool = true,
    option: CAMediaTimingFunctionName = .default) {
        self.baseKeyframeAnimation(
            keyPath: "transform.rotation",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CGPath`移动动画
    /// - Parameters:
    ///   - path:动画路径
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:是否在动画完成后移除动画
    ///   - option:动画控制选项
    func addKeyframeAnimationPositionBezierPath(_ path: CGPath? = nil,
                                                duration: TimeInterval = 2.0,
                                                delay: TimeInterval = 0,
                                                repeatCount: Float = 1,
                                                removedOnCompletion: Bool = false,
                                                option: CAMediaTimingFunctionName = .default)
    {
        self.baseKeyframeAnimation(
            keyPath: "position",
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: path,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CAKeyframeAnimation`动画
    /// - Parameters:
    ///   - keyPath:动画的类型(旋转/缩放/移动/...)
    ///   - values:对应动画类型的值数组(每个时间点的值)
    ///   - keyTimes:对应值数组的时间数组
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复的次数
    ///   - path:动画路径
    ///   - removedOnCompletion:是否在动画完成之后移除动画
    ///   - option:动画节奏控制选项
    func baseKeyframeAnimation(keyPath: String,
                               values: [Any]? = nil,
                               keyTimes: [NSNumber]? = nil,
                               duration: TimeInterval = 2.0,
                               delay: TimeInterval = 0,
                               repeatCount: Float = 1,
                               path: CGPath? = nil,
                               removedOnCompletion: Bool = false,
                               option: CAMediaTimingFunctionName = .default)
    {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)
        // 动画持续时长
        keyframeAnimation.duration = duration
        // 动画开始时间
        keyframeAnimation.beginTime = CACurrentMediaTime() + delay
        // 在动画完成时是否移除动画
        keyframeAnimation.isRemovedOnCompletion = removedOnCompletion
        // 填充模式
        keyframeAnimation.fillMode = .forwards
        // 动画次数
        keyframeAnimation.repeatCount = repeatCount
        // 旋转模式
        keyframeAnimation.rotationMode = .rotateAuto
        // 运动的时间函数
        keyframeAnimation.timingFunction = CAMediaTimingFunction(name: option)

        // 每帧的值
        if let values {
            keyframeAnimation.values = values
        }

        // 每帧的时间点
        if let keyTimes {
            keyframeAnimation.keyTimes = keyTimes
        }

        // 动画路径
        if let path {
            keyframeAnimation.path = path
            // 计算模式
            keyframeAnimation.calculationMode = .cubicPaced
        }

        // 添加到图层上
        self.base.add(keyframeAnimation, forKey: nil)
    }
}

// MARK: - CASpringAnimation 弹簧动画
public extension DDExtension where Base: CALayer {
    /// `CASpringAnimation``Bounds` 动画
    /// - Parameters:
    ///   - toValue:动画目标值(CGRect)
    ///   - delay:延时
    ///   - mass:质量(影响弹簧的惯性,质量越大,弹簧惯性越大,运动的幅度越大)
    ///   - stiffness:刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
    ///   - damping:阻尼系数(阻尼系数越大,弹簧的停止越快)
    ///   - initialVelocity:始速率(弹簧动画的初始速度大小,弹簧运动的初始方向与初始速率的正负一致,若初始速率为0,表示忽略该属性)
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画控制选项
    func addSpringAnimationBounds(_ toValue: Any?,
                                  delay: TimeInterval = 0,
                                  mass: CGFloat = 10.0,
                                  stiffness: CGFloat = 5000,
                                  damping: CGFloat = 100.0,
                                  initialVelocity: CGFloat = 5,
                                  repeatCount: Float = 1,
                                  removedOnCompletion: Bool = false,
                                  option: CAMediaTimingFunctionName = .default)
    {
        self.baseSpringAnimation(
            path: "bounds",
            toValue: toValue,
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CASpringAnimation`动画
    /// - Parameters:
    ///   - path:动画类型
    ///   - toValue:动画目标值
    ///   - delay:延时
    ///   - mass:质量(影响弹簧的惯性,质量越大,弹簧惯性越大,运动的幅度越大)
    ///   - stiffness:刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
    ///   - damping:阻尼系数(阻尼系数越大,弹簧的停止越快)
    ///   - initialVelocity:始速率(弹簧动画的初始速度大小,弹簧运动的初始方向与初始速率的正负一致,若初始速率为0,表示忽略该属性)
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画控制选项
    func baseSpringAnimation(path: String?,
                             toValue: Any? = nil,
                             delay: TimeInterval = 0,
                             mass: CGFloat = 10.0,
                             stiffness: CGFloat = 5000,
                             damping: CGFloat = 100.0,
                             initialVelocity: CGFloat = 5,
                             repeatCount: Float = 1,
                             removedOnCompletion: Bool = false,
                             option: CAMediaTimingFunctionName = .default)
    {
        let springAnimation = CASpringAnimation(keyPath: path)
        // 动画执行时间
        springAnimation.beginTime = CACurrentMediaTime() + delay
        // 质量,影响图层运动时的弹簧惯性,质量越大,弹簧拉伸和压缩的幅度越大
        springAnimation.mass = mass
        // 刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
        springAnimation.stiffness = stiffness
        // 阻尼系数,阻止弹簧伸缩的系数,阻尼系数越大,停止越快
        springAnimation.damping = damping
        // 初始速率,动画视图的初始速度大小;速率为正数时,速度方向与运动方向一致,速率为负数时,速度方向与运动方向相反
        springAnimation.initialVelocity = initialVelocity
        // settlingDuration:结算时间(根据动画参数估算弹簧开始运动到停止的时间,动画设置的时间最好根据此时间来设置)
        springAnimation.duration = springAnimation.settlingDuration
        // 目标值
        springAnimation.toValue = toValue
        // 完成后是否移除动画
        springAnimation.isRemovedOnCompletion = removedOnCompletion
        // 填充模式
        springAnimation.fillMode = CAMediaTimingFillMode.forwards
        // 运动的时间函数
        springAnimation.timingFunction = CAMediaTimingFunction(name: option)

        // 添加动画到图层
        self.base.add(springAnimation, forKey: nil)
    }
}

// MARK: - CAAnimationGroup动画组
public extension DDExtension where Base: CALayer {
    /// `CAAnimationGroup`动画
    /// - Parameters:
    ///   - animations:要执行的`CAAnimation`动画数组
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画控制选项
    func baseAnimationGroup(animations: [CAAnimation]? = nil,
                            duration: TimeInterval = 2.0,
                            delay: TimeInterval = 0,
                            repeatCount: Float = 1,
                            removedOnCompletion: Bool = false,
                            option: CAMediaTimingFunctionName = .default)
    {
        let animationGroup = CAAnimationGroup()
        // 几秒后执行
        animationGroup.beginTime = CACurrentMediaTime() + delay
        // 要执行的动画数组(CAAnimation)
        animationGroup.animations = animations
        // 动画时长
        animationGroup.duration = duration
        // 填充模式
        animationGroup.fillMode = .forwards
        // 动画完成是否移除动画
        animationGroup.isRemovedOnCompletion = removedOnCompletion
        // 运动的时间函数
        animationGroup.timingFunction = CAMediaTimingFunction(name: option)

        // 添加动画组到图层
        self.base.add(animationGroup, forKey: nil)
    }
}

// MARK: - CATransition 动画
public extension DDExtension where Base: CALayer {
    /// 过渡动画
    /// - Parameters:
    ///   - type:过渡动画的类型
    ///   - subtype:过渡动画的方向
    ///   - duration:动画的时间
    ///   - delay:延时
    func addTransition(_ type: CATransitionType,
                       subtype: CATransitionSubtype?,
                       duration: CFTimeInterval = 2.0,
                       delay: TimeInterval = 0)
    {
        let transition = CATransition()
        // 执行时间
        transition.beginTime = CACurrentMediaTime() + delay
        // 过渡动画类型
        transition.type = type
        // 动画方向
        transition.subtype = subtype
        // 动画时长
        transition.duration = duration

        // 添加动画
        self.base.add(transition, forKey: nil)
    }
}

// MARK: - Defaultable
extension CALayer: Defaultable {
    public typealias Associatedtype = CALayer

    @objc open class func `default`() -> Associatedtype {
        return CALayer()
    }
}

// MARK: - 链式语法
public extension CALayer {
    /// 设置frame
    /// - Parameter frame: `frame`
    /// - Returns: `Self`
    @discardableResult
    func dd_frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    /// 添加到父视图
    /// - Parameter superView: 父视图(`UIView`)
    /// - Returns: `Self`
    @discardableResult
    func dd_add2(_ superView: UIView) -> Self {
        superView.layer.addSublayer(self)
        return self
    }

    /// 添加到父视图(`CALayer`)
    /// - Parameter superLayer: 父视图(`CALayer`)
    /// - Returns: `Self`
    @discardableResult
    func dd_add2(_ superLayer: CALayer) -> Self {
        superLayer.addSublayer(self)
        return self
    }

    /// 设置背景色
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    @discardableResult
    func dd_backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color.cgColor
        return self
    }

    /// 是否隐藏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func dd_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置边框宽度
    /// - Parameter width: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func dd_borderWidth(_ width: CGFloat) -> Self {
        self.borderWidth = width
        return self
    }

    /// 设置边框颜色
    /// - Parameter color: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_borderColor(_ color: UIColor) -> Self {
        self.borderColor = color.cgColor
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化
    /// - Returns: `Self`
    @discardableResult
    func dd_shouldRasterize(_ rasterize: Bool) -> Self {
        self.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 光栅化比例
    /// - Returns: `Self`
    @discardableResult
    func dd_rasterizationScale(_ scale: CGFloat) -> Self {
        self.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowColor(_ color: UIColor) -> Self {
        self.shadowColor = color.cgColor
        return self
    }

    /// 设置阴影的透明度,范围:`0~1`
    /// - Parameter opacity: 阴影的透明度
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowOpacity(_ opacity: Float) -> Self {
        self.shadowOpacity = opacity
        return self
    }

    /// 设置阴影的偏移量
    /// - Parameter offset: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowOffset(_ offset: CGSize) -> Self {
        self.shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius: 圆角大小
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowRadius(_ radius: CGFloat) -> Self {
        self.shadowRadius = radius
        return self
    }

    /// 添加阴影
    /// - Parameter path: 阴影`CGPath`
    /// - Returns: `Self`
    @discardableResult
    func dd_shadowPath(_ path: CGPath) -> Self {
        self.shadowPath = path
        return self
    }

    /// 设置裁剪
    /// - Parameter masksToBounds: 是否裁剪
    /// - Returns: `Self`
    @discardableResult
    func dd_masksToBounds(_ masksToBounds: Bool = true) -> Self {
        self.masksToBounds = masksToBounds
        return self
    }

    /// 设置圆角
    /// - Parameter cornerRadius: 圆角
    /// - Returns: `Self`
    @discardableResult
    func dd_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    /// 设置圆角 ⚠️`frame`大小必须已确定
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 需要设置的角(默认全部)
    /// - Returns: `Self`
    @discardableResult
    func dd_corner(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        let size = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.mask = maskLayer

        return self
    }
}

