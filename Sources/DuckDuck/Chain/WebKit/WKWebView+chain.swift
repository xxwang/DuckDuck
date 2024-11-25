//
//  WKWebView+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import WebKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: WKWebView {
    /// 设置网页导航代理
    /// - Parameter delegate: 导航代理对象
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.navigationDelegate(self)
    /// ```
    @discardableResult
    func navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        self.base.navigationDelegate = delegate
        return self
    }

    /// 设置UI代理
    /// - Parameter delegate: UI代理对象
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.uiDelegate(self)
    /// ```
    @discardableResult
    func uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        self.base.uiDelegate = delegate
        return self
    }

    /// 使用URL字符串加载网页
    /// - Parameter string: 网页URL字符串
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.loadPage(from: "https://www.example.com")
    /// ```
    @discardableResult
    func loadPage(from string: String?) -> Self {
        guard let string, let url = URL(string: string) else {
            return self
        }
        let request = URLRequest(url: url)
        self.base.load(request)
        return self
    }

    /// 使用URL对象加载网页
    /// - Parameter url: 网页URL对象
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// if let url = URL(string: "https://www.example.com") {
    ///     webView.dd.loadPage(from: url)
    /// }
    /// ```
    @discardableResult
    func loadPage(from url: URL?) -> Self {
        guard let url else {
            return self
        }
        let request = URLRequest(url: url)
        self.base.load(request)
        return self
    }

    /// 加载本地 HTML 文件
    /// - Parameter fileName: 本地 HTML 文件的名称
    /// - Parameter bundle: 文件所在的 `Bundle`，默认为主包
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.loadLocalHTML(fileName: "test.html")
    /// ```
    @discardableResult
    func loadLocalHTML(fileName: String, bundle: Bundle = .main) -> Self {
        if let path = bundle.path(forResource: fileName, ofType: "html") {
            let url = URL(fileURLWithPath: path)
            self.base.loadFileURL(url, allowingReadAccessTo: url)
        }
        return self
    }

    /// 手动刷新当前网页
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.reloadPage()
    /// ```
    @discardableResult
    func reloadPage() -> Self {
        self.base.reload()
        return self
    }

    /// 清除网页缓存
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.clearCache()
    /// ```
    func clearCache() -> Self {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            for record in records {
                dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record]) {
                    print("缓存清除成功")
                }
            }
        }
        return self
    }

    /// 设置自定义 User-Agent
    /// - Parameter userAgent: 自定义的 User-Agent 字符串
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.customUserAgent("xxx")
    /// ```
    func customUserAgent(_ userAgent: String) -> Self {
        self.base.customUserAgent = userAgent
        return self
    }

    /// 设置自定义错误页面
    /// - Parameter html: 自定义错误页面的 HTML 内容
    /// - Returns: `Self`
    /// ```swift
    /// webView.dd.customErrorPage(html: "html代码")
    /// ```
    func customErrorPage(html: String) -> Self {
        let script = "document.body.innerHTML = '\(html)';"
        Task {
            _ = try? await self.base.dd.executeJavaScript(script: script)
        }
        return self
    }

    /// 跳转到指定的锚点
    /// - Parameter anchor: 锚点的 ID
    /// - Returns: `Self`
    /// ```swift
    /// webView.dd.scrollToAnchor(anchor: "id")
    /// ```
    func scrollToAnchor(anchor: String) -> Self {
        let script = "document.getElementById('\(anchor)').scrollIntoView();"
        Task {
            _ = try? await self.base.dd.executeJavaScript(script: script)
        }
        return self
    }

    /// 监听网页加载的进度
    /// - Parameter progressHandler: 加载进度的回调，接收网页加载的进度值（0 到 1 之间的浮动值）。
    ///
    /// 该方法使用 KVO (Key-Value Observing) 监听 `WKWebView` 的 `estimatedProgress` 属性，
    /// 并通过回调方法 `progressHandler` 实时返回加载进度值。当页面的加载进度发生变化时，
    /// 该回调会自动被触发，进度值会在 0 到 1 之间变化。此方法适用于显示加载进度条、进度指示器等。
    ///
    /// - Example:
    /// ```swift
    /// webView.dd.addLoadingProgressObserver { progress in
    ///     print("网页加载进度：\(progress * 100)%")
    /// }
    /// ```
    func addLoadingProgressObserver(progressHandler: @escaping (Float) -> Void) {
        self.base.addObserver(self.base, forKeyPath: "estimatedProgress", options: .new, context: nil)
        // 保存闭包引用
        AssociatedObject.set(self.base, key: &AssociatedKeys.progressHandlerKey, value: progressHandler, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// 向WKWebView注入JavaScript脚本
    /// - Parameters:
    ///   - script: 要注入的JavaScript代码
    ///   - injectionTime: 脚本注入时机，默认是 `.atDocumentStart`
    ///   - forMainFrameOnly: 是否只注入到主框架，默认是 `false`
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd.injectJavaScript(script: "alert('Hello, World!')")
    /// ```
    @discardableResult
    func injectJavaScript(script: String,
                          injectionTime: WKUserScriptInjectionTime = .atDocumentStart,
                          forMainFrameOnly: Bool = false) -> Self
    {
        let userScript = WKUserScript(source: script,
                                      injectionTime: injectionTime,
                                      forMainFrameOnly: forMainFrameOnly)
        self.base.configuration.userContentController.addUserScript(userScript)
        return self
    }

    /// 异步执行 JavaScript 代码，并返回执行结果。
    /// - 参数 script: 要执行的 JavaScript 代码。
    /// - 返回: JavaScript 执行结果，类型为 `Any?`。
    /// - throws: 如果 JavaScript 执行失败，则抛出错误。
    ///
    /// - Example:
    /// ```swift
    /// do {
    ///     // 使用 async/await 执行 JavaScript 代码
    ///     let result = try await webView.dd.executeJavaScript(script: "document.title")
    ///     print("JavaScript 执行结果: \(String(describing: result))")
    /// } catch {
    ///     // 如果执行失败，捕获并打印错误信息
    ///     print("JavaScript 执行失败，错误信息: \(error)")
    /// }
    /// ```
    @discardableResult
    func executeJavaScript(script: String) async throws -> Any? {
        try await withCheckedThrowingContinuation { continuation in
            self.base.evaluateJavaScript(script) { result, error in
                if let error {
                    DispatchQueue.main.async {
                        continuation.resume(throwing: error)
                    }
                } else {
                    DispatchQueue.main.async {
                        continuation.resume(returning: result)
                    }
                }
            }
        }
    }
}
