//
//  UISlider+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UISlider {
    /// 设置值
    /// - Parameter value: 设置的值
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.value(0.7)
    /// ```
    func value(_ value: Float) -> Self {
        self.base.value = value
        return self
    }

    /// 设置最小值
    /// - Parameter minimumValue: 设置的最小值
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.minimumValue(0.0)
    /// ```
    func minimumValue(_ minimumValue: Float) -> Self {
        self.base.minimumValue = minimumValue
        return self
    }

    /// 设置最大值
    /// - Parameter maximumValue: 设置的最大值
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.maximumValue(1.0)
    /// ```
    func maximumValue(_ maximumValue: Float) -> Self {
        self.base.maximumValue = maximumValue
        return self
    }

    /// 设置最小值图片
    /// - Parameter minimumValueImage: 设置的最小值图片
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.minimumValueImage(UIImage(named: "minImage"))
    /// ```
    func minimumValueImage(_ minimumValueImage: UIImage?) -> Self {
        self.base.minimumValueImage = minimumValueImage
        return self
    }

    /// 设置最大值图片
    /// - Parameter maximumValueImage: 设置的最大值图片
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.maximumValueImage(UIImage(named: "maxImage"))
    /// ```
    func maximumValueImage(_ maximumValueImage: UIImage?) -> Self {
        self.base.maximumValueImage = maximumValueImage
        return self
    }

    /// 设置是否连续
    /// - Parameter isContinuous: 是否连续
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.isContinuous(true)
    /// ```
    func isContinuous(_ isContinuous: Bool) -> Self {
        self.base.isContinuous = isContinuous
        return self
    }

    /// 设置最小值轨道颜色
    /// - Parameter minimumTrackTintColor: 最小值轨道颜色
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.minimumTrackTintColor(.blue)
    /// ```
    func minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> Self {
        self.base.minimumTrackTintColor = minimumTrackTintColor
        return self
    }

    /// 设置最大值轨道颜色
    /// - Parameter maximumTrackTintColor: 最大值轨道颜色
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.maximumTrackTintColor(.gray)
    /// ```
    func maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> Self {
        self.base.maximumTrackTintColor = maximumTrackTintColor
        return self
    }

    /// 设置滑动标识颜色
    /// - Parameter thumbTintColor: 滑动标识颜色
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.thumbTintColor(.red)
    /// ```
    func thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        self.base.thumbTintColor = thumbTintColor
        return self
    }

    /// 添加事件处理
    /// - Parameters:
    ///   - closure: 响应事件的闭包
    ///   - controlEvent: 事件类型
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd.closure({ value in
    ///     print("Slider value changed: \(value)")
    /// })
    /// ```
    func onEvent(_ closure: ((Float?) -> Void)?, for controlEvent: UIControl.Event = .valueChanged) -> Self {
        self.base.onEvent = closure
        self.base.addTarget(self.base, action: #selector(self.base.dd_sliderValueChanged), for: controlEvent)
        return self
    }
}
