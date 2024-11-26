//
//  UIScreen++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - 屏幕事件
public enum ScreenshotAction {
    case screenshot // 截屏
    case recording // 录屏
}

// MARK: - 扩展 UIScreen
public extension UIScreen {
    /// 检查截屏或录屏并发送通知
    /// - Parameter block: 回调，提供捕获类型（截屏或录屏）
    ///
    /// 示例：
    /// ```swift
    /// UIScreen.dd_detectScreenshot { action in
    ///     switch action {
    ///     case .screenshot:
    ///         print("User took a screenshot")
    ///     case .recording:
    ///         print("User is recording the screen")
    ///     }
    /// }
    /// ```
    static func dd_detectScreenshot(_ completion: @Sendable @escaping (_ action: ScreenshotAction) -> Void) {
        // 监听截屏通知
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: .main) { notification in
            completion(.screenshot) // 截屏事件
        }

        // 监听录屏通知，iOS 11及以上版本
        if #available(iOS 11.0, *) {
            // 如果正在捕获此屏幕(例如,录制、空中播放、镜像等)
            if UIScreen.main.isCaptured {
                completion(.recording) // 录屏事件
            }

            // 捕获屏幕状态发生变化时，监听UIScreenCapturedDidChange通知
            NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main) { notification in
                completion(.recording) // 录屏事件
            }
        }
    }
}
