import UIKit

public class SizeCalculator {
    /// 设计图的尺寸
    private nonisolated(unsafe) static var sketchSize: CGSize = .zero

    private init() {}
}

public extension SizeCalculator {
    /// 设置设计图的尺寸，适配不同设备的设计图尺寸（默认使用 iPhone8 尺寸）。
    ///
    /// - Parameter size: 设计图的尺寸，通常为设计图的宽度和高度。
    /// - Default value: 默认设置为 CGSize(width: 375, height: 812)，适配 iPhone 8 尺寸。
    ///
    /// - Example:
    /// ```swift
    /// let size = CGSize(width: 375, height: 667)
    /// SizeCalculator.setupSketch(size: size)  // 设置为 iPhone 6, 7, 8 的设计图尺寸
    /// ```
    static func setupSketch(size: CGSize = CGSize(width: 375, height: 812)) {
        self.sketchSize = size
    }
}

// MARK: - 屏幕适配功能
@MainActor
private extension SizeCalculator {
    /// 根据设计图宽度计算适配后的宽度。
    ///
    /// - Parameter value: 需要计算适配的宽度值，通常是视图的宽度。
    /// - Returns: 适配后的宽度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedWidth = SizeCalculator.calculateWidth(from: 200)
    /// ```
    static func calculateWidth(from value: Any) -> CGFloat {
        return self.calculateWidthRatio() * self.convertValueToCGFloat(from: value)
    }

    /// 根据设计图高度计算适配后的高度。
    ///
    /// - Parameter value: 需要计算适配的高度值，通常是视图的高度。
    /// - Returns: 适配后的高度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedHeight = SizeCalculator.calculateHeight(from: 100)
    /// ```
    static func calculateHeight(from value: Any) -> CGFloat {
        return self.calculateHeightRatio() * self.convertValueToCGFloat(from: value)
    }

    /// 计算适配后的最大值（根据设计图的宽度和高度，选择较大的值）。
    ///
    /// - Parameter value: 需要计算适配的值。
    /// - Returns: 适配后的最大宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMax = SizeCalculator.calculateMax(from: 100)
    /// ```
    static func calculateMax(from value: Any) -> CGFloat {
        return max(self.calculateWidth(from: value), self.calculateHeight(from: value))
    }

    /// 计算适配后的最小值（根据设计图的宽度和高度，选择较小的值）。
    ///
    /// - Parameter value: 需要计算适配的值。
    /// - Returns: 适配后的最小宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMin = SizeCalculator.calculateMin(from: 100)
    /// ```
    static func calculateMin(from value: Any) -> CGFloat {
        return min(self.calculateWidth(from: value), self.calculateHeight(from: value))
    }

    /// 获取宽度适配比例（即当前屏幕宽度与设计图宽度的比例）。
    ///
    /// - Returns: 屏幕宽度与设计图宽度的适配比例。
    ///
    /// - Example:
    /// ```swift
    /// let widthRatio = SizeCalculator.calculateWidthRatio()
    /// ```
    @MainActor
    static func calculateWidthRatio() -> CGFloat {
        return ScreenInfo.screenWidth / self.sketchSize.width
    }

    /// 获取高度适配比例（即当前屏幕高度与设计图高度的比例）。
    ///
    /// - Returns: 屏幕高度与设计图高度的适配比例。
    ///
    /// - Example:
    /// ```swift
    /// let heightRatio = SizeCalculator.calculateHeightRatio()
    /// ```
    @MainActor
    static func calculateHeightRatio() -> CGFloat {
        return ScreenInfo.screenHeight / self.sketchSize.height
    }

    /// 将输入的值转换为 `CGFloat` 类型。
    ///
    /// - Parameter value: 需要转换的值，支持 `CGFloat`、`Double`、`Float` 和 `Int` 类型。
    /// - Returns: 转换后的 `CGFloat` 值。
    ///
    /// - Example:
    /// ```swift
    /// let cgValue = SizeCalculator.convertValueToCGFloat(from: 200)
    /// ```
    static func convertValueToCGFloat(from value: Any) -> CGFloat {
        if let value = value as? CGFloat { return value }
        if let value = value as? Double { return CGFloat(value) }
        if let value = value as? Float { return CGFloat(value) }
        if let value = value as? Int { return CGFloat(value) }
        return 0
    }
}

// MARK: - 整数适配扩展
@MainActor
public extension BinaryInteger {
    /// 自动适配宽度（将整数值按设计图宽度比例适配）。
    ///
    /// - Returns: 自动适配后的宽度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedWidth = 200.wAuto
    /// ```
    var wAuto: CGFloat { SizeCalculator.calculateWidth(from: self) }

    /// 自动适配高度（将整数值按设计图高度比例适配）。
    ///
    /// - Returns: 自动适配后的高度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedHeight = 150.hAuto
    /// ```
    var hAuto: CGFloat { SizeCalculator.calculateHeight(from: self) }

    /// 自动适配最大值（根据设计图宽度和高度适配后的最大值）。
    ///
    /// - Returns: 自动适配后的最大宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMax = 200.maxAuto
    /// ```
    var maxAuto: CGFloat { SizeCalculator.calculateMax(from: self) }

    /// 自动适配最小值（根据设计图宽度和高度适配后的最小值）。
    ///
    /// - Returns: 自动适配后的最小宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMin = 100.minAuto
    /// ```
    var minAuto: CGFloat { SizeCalculator.calculateMin(from: self) }
}

// MARK: - 浮动数字适配扩展
@MainActor
public extension BinaryFloatingPoint {
    /// 自动适配宽度（将浮动数字按设计图宽度比例适配）。
    ///
    /// - Returns: 自动适配后的宽度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedWidth = 200.5.wAuto
    /// ```
    var wAuto: CGFloat { SizeCalculator.calculateWidth(from: self) }

    /// 自动适配高度（将浮动数字按设计图高度比例适配）。
    ///
    /// - Returns: 自动适配后的高度值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedHeight = 150.75.hAuto
    /// ```
    var hAuto: CGFloat { SizeCalculator.calculateHeight(from: self) }

    /// 自动适配最大值（根据设计图宽度和高度适配后的最大值）。
    ///
    /// - Returns: 自动适配后的最大宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMax = 200.5.maxAuto
    /// ```
    var maxAuto: CGFloat { SizeCalculator.calculateMax(from: self) }

    /// 自动适配最小值（根据设计图宽度和高度适配后的最小值）。
    ///
    /// - Returns: 自动适配后的最小宽高值。
    ///
    /// - Example:
    /// ```swift
    /// let adaptedMin = 100.25.minAuto
    /// ```
    var minAuto: CGFloat { SizeCalculator.calculateMin(from: self) }
}
