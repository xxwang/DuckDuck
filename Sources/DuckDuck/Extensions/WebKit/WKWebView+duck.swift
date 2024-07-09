//
//  WKWebView+duck.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import WebKit

// MARK: - Defaultable
public extension WKWebView {
    public typealias Associatedtype = WKWebView
    
    open override class func `default`() -> Associatedtype {
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
        
        return WKWebView(frame: .zero, configuration: configuration)
    }
}

// MARK: - 链式语法
public extension WKWebView {
    /// 设置导航代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func dd_navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        navigationDelegate = delegate
        return self
    }

    /// 设置UI代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func  uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        uiDelegate = delegate
        return self
    }

    /// 使用`URL`字符串加载网页
    /// - Parameter string: `URL`字符串
    /// - Returns: `Self`
    @discardableResult
    func dd_load(_ string: String?) -> Self {
        guard let string,
              let url = URL(string: string) else {
            return self
        }
        let request = URLRequest(url: url)
        self.load(request)
        
        return self
    }

    /// 使用`URL`对象加载网页
    /// - Parameter string: `URL`对象
    /// - Returns: `Self`
    @discardableResult
    func dd_load(_ url: URL?) -> Self {
        guard let url else {
            return self
        }
        let request = URLRequest(url: url)
        self.load(request)
        
        return self
    }

    /// 向`WKWebView`注入`javascript`代码
    /// - Parameter script: 要注册的脚本
    /// - Returns: `Self`
    @discardableResult
    func dd_injection(script: String) -> Self {
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        self.configuration.userContentController.addUserScript(userScript)
        return self
    }

    /// 在`WKWebView`执行`javascript`代码
    /// - Parameters:
    ///   - script: 要执行的`JS`脚本
    ///   - completion: 完成回调
    /// - Returns: `Self`
    @discardableResult
    func dd_execute(script: String, completion: ((Any?, Error?) -> Void)? = nil) -> Self {
        self.evaluateJavaScript(script, completionHandler: completion)
        return self
    }
}

