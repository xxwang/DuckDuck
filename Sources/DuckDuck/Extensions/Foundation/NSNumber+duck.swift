//
//  NSNumber+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 方法
public extension DDExtension where Base: NSNumber {
    /// 按指定样式格式化数字
    /// - Parameters:
    ///   - style: 样式
    ///   - separator: 分隔符
    ///   - mode: 模式
    ///   - minDecimalPlaces: 小数点后最少保留位数
    ///   - maxDecimalPlaces: 小数点后最大保留位数
    /// - Returns: 结果字符串
    func formatter(style: NumberFormatter.Style = .none,
                   separator: String = ",",
                   mode: NumberFormatter.RoundingMode = .halfEven,
                   minDecimalPlaces: Int = 0,
                   maxDecimalPlaces: Int = 0) -> String?
    {
        let formater = NumberFormatter()
        // 样式
        formater.numberStyle = style
        // 分隔符
        formater.groupingSeparator = separator
        // 舍入模式
        formater.roundingMode = mode
        // 最小位数
        formater.minimumFractionDigits = minDecimalPlaces
        // 最大位数
        formater.maximumFractionDigits = maxDecimalPlaces

        return formater.string(from: self.base)
    }
}
