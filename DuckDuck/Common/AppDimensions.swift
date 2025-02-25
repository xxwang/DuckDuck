//
//  AppDimensions.swift
//  DuckDuck
//
//  Created by 王斌 on 2025/2/25.
//

import UIKit

struct AppDimensions {}

extension AppDimensions {
        /// 屏幕的整体边界 (CGRect)
        static var screenBounds: CGRect {
            return UIScreen.main.bounds
        }
     
        /// 屏幕尺寸 (CGSize)
        static var screenSize: CGSize { screenBounds.size }

        /// 屏幕宽度 (CGFloat)
        static var screenWidth: CGFloat { screenBounds.width }

        /// 屏幕高度 (CGFloat)
        static var screenHeight: CGFloat { screenBounds.height }
}
