//
//  UIProgressView+chain.swift
//  DuckDuck
//
//  Created by xxwang on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIProgressView {
    /// 设置当前进度值
    /// - Parameter progress: 当前进度值，取值范围为 0.0 到 1.0
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd.progress(0.5)
    /// ```
    func progress(_ progress: Float) -> Self {
        self.base.progress = progress
        return self
    }

    /// 设置进度视图的风格
    /// - Parameter style: 风格，默认为 `default`
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd.progressViewStyle(.bar)
    /// ```
    func progressViewStyle(_ style: UIProgressView.Style) -> Self {
        self.base.progressViewStyle = style
        return self
    }

    /// 设置进度条的颜色
    /// - Parameter progressTintColor: 进度条的颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd.progressTintColor(.blue)
    /// ```
    func progressTintColor(_ progressTintColor: UIColor?) -> Self {
        self.base.progressTintColor = progressTintColor
        return self
    }

    /// 设置背景轨道的颜色
    /// - Parameter trackTintColor: 背景轨道的颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd.trackTintColor(.lightGray)
    /// ```
    func trackTintColor(_ trackTintColor: UIColor?) -> Self {
        self.base.trackTintColor = trackTintColor
        return self
    }

    /// 设置进度条的自定义进度视图
    /// - Parameter progressImage: 自定义进度图像
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd.progressImage(UIImage(named: "progress_image"))
    /// ```
    func progressImage(_ progressImage: UIImage?) -> Self {
        self.base.progressImage = progressImage
        return self
    }

    /// 设置背景轨道的自定义图像
    /// - Parameter trackImage: 自定义背景图像
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd.trackImage(UIImage(named: "track_image"))
    /// ```
    func trackImage(_ trackImage: UIImage?) -> Self {
        self.base.trackImage = trackImage
        return self
    }
}
