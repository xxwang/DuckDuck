//
//  WKWebViewConfiguration++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import WebKit

// MARK: - 默认配置扩展
public extension WKWebViewConfiguration {
    /// 默认配置
    /// - Returns: 默认的 `WKWebViewConfiguration` 配置实例
    ///
    /// - Example:
    /// ```swift
    /// let webViewConfig = WKWebViewConfiguration.defaultConfiguration()
    /// ```
    static func defaultConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.selectionGranularity = .dynamic
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false

        // 配置 JavaScript 支持，根据 iOS 版本进行不同设置
        if #available(iOS 14, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }

        return configuration
    }
}
