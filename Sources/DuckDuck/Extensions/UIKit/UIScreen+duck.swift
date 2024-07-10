//
//  UIScreen+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import UIKit

public enum ScreenShotType {
    case screenshot
    case recording
}

public extension DDExtension where Base: UIScreen {
    /// 检查截屏或者录屏并发送通知
    /// - Parameter block:回调
    static func detectScreenShot(_ block: @escaping (ScreenShotType) -> Void) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            block(.screenshot)
        }
        // 监听录屏通知,iOS 11后才有录屏
        if #available(iOS 11.0, *) {
            // 如果正在捕获此屏幕(例如,录制、空中播放、镜像等),则为真
            if UIScreen.main.isCaptured {
                block(.recording)
            }
            // 捕获的屏幕状态发生变化时,会发送UIScreenCapturedDidChange通知,监听该通知
            NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: mainQueue) { notification in
                block(.recording)
            }
        }
    }
}
