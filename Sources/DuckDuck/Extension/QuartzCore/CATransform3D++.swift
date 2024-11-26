//
//  CATransform3D++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import QuartzCore

// MARK: - 类型转换
public extension CATransform3D {
    /// 将 `CATransform3D` 转换为 `CGAffineTransform`。
    /// 如果转换失败，则返回默认值 `CGAffineTransform.identity`。
    /// - Returns: 转换后的 `CGAffineTransform`
    ///
    /// ## 示例
    /// ```swift
    /// let transform3D = CATransform3DMakeTranslation(10, 20, 0)
    /// let affineTransform = transform3D.dd_toCGAffineTransform()
    /// print(affineTransform) // 打印转换后的仿射变换
    /// ```
    func dd_toCGAffineTransform() -> CGAffineTransform {
        return CATransform3DGetAffineTransform(self)
    }

    /// 返回默认的 `CATransform3D` 值 `[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]`。
    /// - Returns: 默认值 `CATransform3DIdentity`
    ///
    /// ## 示例
    /// ```swift
    /// let identityTransform = CATransform3D.dd_identity()
    /// print(identityTransform) // 打印默认的 CATransform3D
    /// ```
    static func dd_identity() -> CATransform3D {
        return CATransform3DIdentity
    }
}

// MARK: - 构造方法
public extension CATransform3D {
    /// 创建一个值为 `(tx, ty, tz)` 的 `CATransform3D`，用于平移操作。
    /// - Parameters:
    ///   - tx: x 轴平移距离
    ///   - ty: y 轴平移距离
    ///   - tz: z 轴平移距离
    ///
    /// 示例：
    /// ```swift
    /// let translationTransform = CATransform3D(tx: 10, ty: 20, tz: 30)
    /// ```
    @inlinable
    init(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        self = CATransform3DMakeTranslation(tx, ty, tz)
    }

    /// 创建一个按 `(sx, sy, sz)` 缩放的 `CATransform3D`。
    /// - Parameters:
    ///   - sx: x 轴缩放比例
    ///   - sy: y 轴缩放比例
    ///   - sz: z 轴缩放比例
    ///
    /// 示例：
    /// ```swift
    /// let scaleTransform = CATransform3D(sx: 2.0, sy: 2.0, sz: 1.0)
    /// ```
    @inlinable
    init(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        self = CATransform3DMakeScale(sx, sy, sz)
    }

    /// 创建一个围绕向量 `(x, y, z)` 旋转 `angle` 弧度的 `CATransform3D`。
    /// - Parameters:
    ///   - angle: 旋转角度（以弧度为单位）
    ///   - x: 旋转轴向量的 x 分量
    ///   - y: 旋转轴向量的 y 分量
    ///   - z: 旋转轴向量的 z 分量
    ///
    /// 示例：
    /// ```swift
    /// let rotationTransform = CATransform3D(angle: .pi / 4, x: 0, y: 0, z: 1)
    /// ```
    @inlinable
    init(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DMakeRotation(angle, x, y, z)
    }
}

// MARK: - 方法
public extension CATransform3D {
    /// 判断是否是 `CATransform3D` 默认对象
    ///
    /// 示例：
    /// ```swift
    /// let transform = CATransform3DIdentity
    /// let isIdentity = transform.dd_isIdentity() // true
    /// ```
    /// - Returns: 如果是默认对象，返回 `true`
    func dd_isIdentity() -> Bool {
        return CATransform3DIsIdentity(self)
    }

    /// 如果 `CATransform3D` 可以用 `CGAffineTransform`（仿射变换）精确表示，则返回 `true`
    ///
    /// 示例：
    /// ```swift
    /// let transform = CATransform3DMakeScale(1.0, 1.0, 0.0)
    /// let isAffine = transform.dd_isAffine() // true
    /// ```
    /// - Returns: 是否可以表示为仿射变换
    func dd_isAffine() -> Bool {
        return CATransform3DIsAffine(self)
    }

    /// 通过平移 `(tx, ty, tz)` 返回新的 `CATransform3D`
    ///
    /// 示例：
    /// ```swift
    /// let transform = CATransform3DIdentity.dd_translatedBy(tx: 10, ty: 20, tz: 30)
    /// ```
    /// - Parameters:
    ///   - tx: x 轴平移
    ///   - ty: y 轴平移
    ///   - tz: z 轴平移
    /// - Returns: 平移后的 `CATransform3D`
    func dd_translatedBy(tx: CGFloat, ty: CGFloat, tz: CGFloat) -> CATransform3D {
        return CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 通过缩放 `(sx, sy, sz)` 返回新的 `CATransform3D`
    ///
    /// 示例：
    /// ```swift
    /// let transform = CATransform3DIdentity.dd_scaledBy(sx: 2.0, sy: 2.0, sz: 1.0)
    /// ```
    /// - Parameters:
    ///   - sx: x 轴缩放
    ///   - sy: y 轴缩放
    ///   - sz: z 轴缩放
    /// - Returns: 缩放后的 `CATransform3D`
    func dd_scaledBy(sx: CGFloat, sy: CGFloat, sz: CGFloat) -> CATransform3D {
        return CATransform3DScale(self, sx, sy, sz)
    }

    /// 通过旋转 `(x, y, z)` 返回新的 `CATransform3D`
    ///
    /// 示例：
    /// ```swift
    /// let transform = CATransform3DIdentity.dd_rotated(angle: .pi / 4, x: 0, y: 0, z: 1)
    /// ```
    /// - Parameters:
    ///   - angle: 旋转的角度
    ///   - x: 向量的 x 位置
    ///   - y: 向量的 y 位置
    ///   - z: 向量的 z 位置
    /// - Returns: 旋转后的 `CATransform3D`
    func dd_rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        return CATransform3DRotate(self, angle, x, y, z)
    }

    /// 反转 `CATransform3D`
    ///
    /// 示例：
    /// ```swift
    /// let transform = CATransform3DIdentity.dd_inverted()
    /// ```
    /// - Returns: 反转后的 `CATransform3D`
    func dd_inverted() -> CATransform3D {
        return CATransform3DInvert(self)
    }

    /// 将两个 `CATransform3D` 连接并生成新的 `CATransform3D`
    ///
    /// 示例：
    /// ```swift
    /// let transform1 = CATransform3DMakeScale(2.0, 2.0, 1.0)
    /// let transform2 = CATransform3DMakeTranslation(10.0, 20.0, 0.0)
    /// let combined = transform1.dd_concatenating(transform2)
    /// ```
    /// - Parameter t2: 另一个 `CATransform3D`
    /// - Returns: 新的 `CATransform3D`
    func dd_concatenating(_ t2: CATransform3D) -> CATransform3D {
        return CATransform3DConcat(self, t2)
    }

    /// 对当前对象进行平移并赋值
    ///
    /// 示例：
    /// ```swift
    /// var transform = CATransform3DIdentity
    /// transform.dd_translatedBy(tx: 10, ty: 20, tz: 30)
    /// ```
    /// - Parameters:
    ///   - tx: x 轴平移
    ///   - ty: y 轴平移
    ///   - tz: z 轴平移
    mutating func dd_translatedBy(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        self = CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 对当前对象进行缩放并赋值
    ///
    /// 示例：
    /// ```swift
    /// var transform = CATransform3DIdentity
    /// transform.dd_scaledBy(sx: 2.0, sy: 2.0, sz: 1.0)
    /// ```
    /// - Parameters:
    ///   - sx: x 轴缩放
    ///   - sy: y 轴缩放
    ///   - sz: z 轴缩放
    mutating func dd_scaledBy(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        self = CATransform3DScale(self, sx, sy, sz)
    }

    /// 对当前对象进行旋转并赋值
    ///
    /// 示例：
    /// ```swift
    /// var transform = CATransform3DIdentity
    /// transform.dd_rotated(angle: .pi / 4, x: 0, y: 0, z: 1)
    /// ```
    /// - Parameters:
    ///   - angle: 旋转的角度
    ///   - x: 向量的 x 位置
    ///   - y: 向量的 y 位置
    ///   - z: 向量的 z 位置
    mutating func dd_rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DRotate(self, angle, x, y, z)
    }

    /// 反转当前对象并赋值
    ///
    /// 示例：
    /// ```swift
    /// var transform = CATransform3DIdentity
    /// transform.dd_inverted()
    /// ```
    mutating func dd_inverted() {
        self = CATransform3DInvert(self)
    }

    /// 将当前对象与另一个 `CATransform3D` 连接并赋值
    ///
    /// 示例：
    /// ```swift
    /// var transform1 = CATransform3DMakeScale(2.0, 2.0, 1.0)
    /// let transform2 = CATransform3DMakeTranslation(10.0, 20.0, 0.0)
    /// transform1.dd_concatenating(transform2)
    /// ```
    /// - Parameter t2: 另一个 `CATransform3D`
    mutating func dd_concatenating(_ t2: CATransform3D) {
        self = CATransform3DConcat(self, t2)
    }
}

// MARK: - 运算符
public extension CATransform3D {
    /// 判断两个 `CATransform3D` 是否相等。
    ///
    /// 示例：
    /// ```swift
    /// let transform1 = CATransform3DMakeScale(1.0, 1.0, 1.0)
    /// let transform2 = CATransform3DMakeScale(1.0, 1.0, 1.0)
    /// let areEqual = (transform1 == transform2) // true
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: 左侧的 `CATransform3D` 对象
    ///   - rhs: 右侧的 `CATransform3D` 对象
    /// - Returns: 如果两个 `CATransform3D` 对象相等，返回 `true`；否则返回 `false`
    @inlinable
    static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        return CATransform3DEqualToTransform(lhs, rhs)
    }
}
