//
//  UIProgressView++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - 方法
public extension UIProgressView {
    /// 设置动画进度的速度
    /// - Parameters:
    ///   - progress: 要设置的进度值，范围为 0.0 到 1.0
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间
    ///   - completion: 完成回调，动画结束时调用
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd_setProgressAnimated(0.5, animated: true, duration: 0.3) {
    ///     // 动画完成后的回调
    /// }
    /// ```
    func dd_setProgressAnimated(_ progress: Float, animated: Bool = true, duration: TimeInterval = 0.15, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.progress = progress
            }) { _ in
                completion?()
            }
        } else {
            self.progress = progress
            completion?()
        }
    }
}

// MARK: - 链式语法
public extension UIProgressView {
    /// 设置当前进度值
    /// - Parameter progress: 当前进度值，取值范围为 0.0 到 1.0
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd_progress(0.5)
    /// ```
    func dd_progress(_ progress: Float) -> Self {
        self.progress = progress
        return self
    }

    /// 设置进度视图的风格
    /// - Parameter style: 风格，默认为 `default`
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd_progressViewStyle(.bar)
    /// ```
    func dd_progressViewStyle(_ style: UIProgressView.Style) -> Self {
        self.progressViewStyle = style
        return self
    }

    /// 设置进度条的颜色
    /// - Parameter progressTintColor: 进度条的颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd_progressTintColor(.blue)
    /// ```
    func dd_progressTintColor(_ progressTintColor: UIColor?) -> Self {
        self.progressTintColor = progressTintColor
        return self
    }

    /// 设置背景轨道的颜色
    /// - Parameter trackTintColor: 背景轨道的颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd_trackTintColor(.lightGray)
    /// ```
    func dd_trackTintColor(_ trackTintColor: UIColor?) -> Self {
        self.trackTintColor = trackTintColor
        return self
    }

    /// 设置进度条的自定义进度视图
    /// - Parameter progressImage: 自定义进度图像
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd_progressImage(UIImage(named: "progress_image"))
    /// ```
    func dd_progressImage(_ progressImage: UIImage?) -> Self {
        self.progressImage = progressImage
        return self
    }

    /// 设置背景轨道的自定义图像
    /// - Parameter trackImage: 自定义背景图像
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// progressView.dd_trackImage(UIImage(named: "track_image"))
    /// ```
    func dd_trackImage(_ trackImage: UIImage?) -> Self {
        self.trackImage = trackImage
        return self
    }
}
