//
//  WKWebViewConfiguration+duck.swift
//  DuckDuck
//
//  Created by 王哥 on 2024/9/19.
//

import WebKit

public extension WKWebViewConfiguration {
    /// 默认配置
    /// - Returns: `WKWebViewConfiguration`
    static func `default`() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.selectionGranularity = .dynamic
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        if #available(iOS 14, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        return configuration
    }
}
