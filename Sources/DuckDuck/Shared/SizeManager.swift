//
//  SizeManager.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import UIKit

// MARK: - SizeManager
public struct SizeManager {
    /// 设计图屏幕尺寸
    fileprivate static var sketchSize = CGSize(width: 375, height: 812)

    /// 设置设计图尺寸
    static func setupSketch(size: CGSize) {
        self.sketchSize = size
    }
}

private extension SizeManager {
    /// 宽度比例
    static var wRatio: CGFloat {
        var sketchW = min(self.sketchSize.width, sketchSize.height)
        var screenW = min(kScreenWidth, kScreenHeight)
        if DDHelper.isLandscape {
            sketchW = max(self.sketchSize.width, self.sketchSize.height)
            screenW = max(kScreenWidth, kScreenHeight)
        }
        return screenW / sketchW
    }

    /// 高度比例
    static var hRatio: CGFloat {
        var sketchH = max(self.sketchSize.width, self.sketchSize.height)
        var screenH = max(kScreenWidth, kScreenHeight)
        if DDHelper.isLandscape {
            sketchH = min(self.sketchSize.width, sketchSize.height)
            screenH = min(kScreenWidth, kScreenHeight)
        }
        return screenH / sketchH
    }

    /// `Any`转`CGFloat`
    /// - Parameter value: 要转换的数据
    /// - Returns: 转换结果
    static func format(from value: Any) -> CGFloat {
        if let value = value as? CGFloat { return value }
        if let value = value as? Double { return value }
        if let value = value as? Float { return value.dd.as2CGFloat }
        if let value = value as? Int { return value.dd.as2CGFloat }
        return 0
    }

    /// 计算`宽度`
    static func calcWidth(from value: Any) -> CGFloat {
        return self.wRatio * self.format(from: value)
    }

    /// 计算`高度`
    static func calcHeight(from value: Any) -> CGFloat {
        return self.hRatio * self.format(from: value)
    }

    /// 计算`最大宽高`
    static func calcMax(from value: Any) -> CGFloat {
        return max(self.calcWidth(from: value), self.calcHeight(from: value))
    }

    /// 计算`最小宽高`
    static func calcMin(from value: Any) -> CGFloat {
        return min(self.calcWidth(from: value), self.calcHeight(from: value))
    }
}

// MARK: - 屏幕适配(整形)
public extension BinaryInteger {
    /// 适配宽度
    var wAuto: CGFloat { SizeManager.calcWidth(from: self) }

    /// 适配高度
    var hAuto: CGFloat { SizeManager.calcHeight(from: self) }

    /// 最大适配(特殊情况)
    var maxAuto: CGFloat { SizeManager.calcMax(from: self) }

    /// 最小适配(特殊情况)
    var minAuto: CGFloat { SizeManager.calcMin(from: self) }
}

// MARK: - 屏幕适配(浮点)
public extension BinaryFloatingPoint {
    /// 适配宽度
    var wAuto: CGFloat { SizeManager.calcWidth(from: self) }

    /// 适配高度
    var hAuto: CGFloat { SizeManager.calcHeight(from: self) }

    /// 最大适配(特殊情况)
    var maxAuto: CGFloat { SizeManager.calcMax(from: self) }

    /// 最小适配(特殊情况)
    var minAuto: CGFloat { SizeManager.calcMin(from: self) }
}
