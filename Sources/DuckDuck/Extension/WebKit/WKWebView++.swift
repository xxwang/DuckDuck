//
//  WKWebView++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import WebKit

// MARK: - Creatable
public extension WKWebView {
    /// 纯净的创建方法
    static func create<T: WKWebView>(_ aClass: T.Type = WKWebView.self) -> T {
        let webView = WKWebView()
        return webView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: WKWebView>(_ aClass: T.Type = WKWebView.self) -> T {
        let webView: WKWebView = self.create()
        return webView as! T
    }
}

// MARK: - Associated Keys
class AssociatedKeys {
    // 使用静态常量来作为关联对象的键，避免暴露内部表示
    @MainActor static var progressHandlerKey: Void?
}

// MARK: - 移除加载进度观察者
public extension WKWebView {
    /// 移除网页加载进度观察者
    /// 在合适的时机调用此方法来移除 KVO 观察者，防止内存泄漏。
    func dd_removeLoadingProgressObserver() {
        // 移除 KVO 观察者
        self.removeObserver(self, forKeyPath: "estimatedProgress")

        // 清除保存的回调
        Task { @MainActor in
            AssociatedObject.set(self, key: &AssociatedKeys.progressHandlerKey, value: nil, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - 方法扩展
public extension WKWebView {
    /// 检查网页是否完全加载
    /// - Returns: `true` 如果页面已完全加载，`false` 如果页面仍在加载
    ///
    /// - Example:
    /// ```swift
    /// if webView.dd_isPageLoaded() {
    ///     print("页面加载完成")
    /// } else {
    ///     print("页面仍在加载中")
    /// }
    /// ```
    func dd_isPageLoaded() -> Bool {
        return !self.isLoading
    }

    /// 检查网页中所有图片是否加载完成
    /// - Returns: `true` 如果所有图片都加载完成，`false` 否则
    ///
    /// - Example:
    /// ```swift
    /// Task {
    ///     let areImagesLoaded = await webView.dd_checkImagesLoaded()
    ///     if areImagesLoaded {
    ///         print("所有图片已加载完成")
    ///     } else {
    ///         print("图片尚未加载完成")
    ///     }
    /// }
    /// ```
    func dd_checkImagesLoaded() async -> Bool {
        let script = """
        var images = document.getElementsByTagName('img');
        var loaded = true;
        for (var i = 0; i < images.length; i++) {
            if (!images[i].complete) {
                loaded = false;
                break;
            }
        }
        loaded;
        """
        do {
            let result = try await self.dd_executeJavaScript(script: script)
            return result as? Bool ?? false
        } catch {
            return false
        }
    }

    /// 获取当前网页的标题
    /// - Returns: 当前页面的标题，如果无标题则为 `nil`
    ///
    /// - Example:
    /// ```swift
    /// if let title = webView.dd_getPageTitle() {
    ///     print("当前页面标题：\(title)")
    /// } else {
    ///     print("页面无标题")
    /// }
    /// ```
    func dd_getPageTitle() -> String? {
        return self.title
    }

    /// 获取当前网页的 URL
    /// - Returns: 当前页面的 `URL`，如果无 URL 则为 `nil`
    ///
    /// - Example:
    /// ```swift
    /// if let url = webView.dd_getCurrentURL() {
    ///     print("当前页面 URL：\(url)")
    /// } else {
    ///     print("无有效 URL")
    /// }
    /// ```
    func dd_getCurrentURL() -> URL? {
        return self.url
    }

    /// 获取网页的 HTML 内容
    /// - Returns: 一个字符串，表示网页的 HTML 内容
    ///
    /// - Example:
    /// ```swift
    /// Task {
    ///     do {
    ///         if let html = try await webView.dd_getHTMLContent() {
    ///             print("页面 HTML 内容：\(html)")
    ///         } else {
    ///             print("无法获取 HTML 内容")
    ///         }
    ///     } catch {
    ///         print("获取 HTML 内容失败：\(error)")
    ///     }
    /// }
    /// ```
    func dd_getHTMLContent() async throws -> String? {
        let script = "document.documentElement.outerHTML"
        let result = try await self.dd_executeJavaScript(script: script)
        return result as? String
    }

    /// 调整网页文字大小
    /// - Parameter ratio: 文字大小调整比例（百分比）
    /// - Example:
    /// ```swift
    /// webView.dd_adjustTextSize(120)
    /// ```
    func dd_adjustTextSize(by ratio: CGFloat) {
        let script = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        Task {
            do {
                try await self.dd_executeJavaScript(script: script)
            } catch {
                print("JavaScript 执行失败，错误信息: \(error)")
            }
        }
    }

    /// 调整网页以适应手机屏幕，解决网页显示异常问题
    /// - Example:
    /// ```swift
    /// webView.dd_adjustForMobile()
    /// ```
    func dd_adjustForMobile() {
        let script = """
        var meta = document.createElement('meta');
        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width');
        document.getElementsByTagName('head')[0].appendChild(meta);
        """
        Task {
            do {
                try await self.dd_executeJavaScript(script: script)
            } catch {
                print("JavaScript 执行失败，错误信息: \(error)")
            }
        }
    }
}

// MARK: - 链式语法
public extension WKWebView {
    /// 设置网页导航代理
    /// - Parameter delegate: 导航代理对象
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd_navigationDelegate(self)
    /// ```
    @discardableResult
    func dd_navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        navigationDelegate = delegate
        return self
    }

    /// 设置UI代理
    /// - Parameter delegate: UI代理对象
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd_uiDelegate(self)
    /// ```
    @discardableResult
    func dd_uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        uiDelegate = delegate
        return self
    }

    /// 使用URL字符串加载网页
    /// - Parameter string: 网页URL字符串
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd_loadPage(from: "https://www.example.com")
    /// ```
    @discardableResult
    func dd_loadPage(from string: String?) -> Self {
        guard let string, let url = URL(string: string) else {
            return self
        }
        let request = URLRequest(url: url)
        self.load(request)
        return self
    }

    /// 使用URL对象加载网页
    /// - Parameter url: 网页URL对象
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// if let url = URL(string: "https://www.example.com") {
    ///     webView.dd_loadPage(from: url)
    /// }
    /// ```
    @discardableResult
    func dd_loadPage(from url: URL?) -> Self {
        guard let url else {
            return self
        }
        let request = URLRequest(url: url)
        self.load(request)
        return self
    }

    /// 加载本地 HTML 文件
    /// - Parameter fileName: 本地 HTML 文件的名称
    /// - Parameter bundle: 文件所在的 `Bundle`，默认为主包
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd_loadLocalHTML(fileName: "test.html")
    /// ```
    @discardableResult
    func dd_loadLocalHTML(fileName: String, bundle: Bundle = .main) -> Self {
        if let path = bundle.path(forResource: fileName, ofType: "html") {
            let url = URL(fileURLWithPath: path)
            self.loadFileURL(url, allowingReadAccessTo: url)
        }
        return self
    }

    /// 手动刷新当前网页
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd_reloadPage()
    /// ```
    @discardableResult
    func dd_reloadPage() -> Self {
        self.reload()
        return self
    }

    /// 清除网页缓存
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd_clearCache()
    /// ```
    func dd_clearCache() -> Self {
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
    /// webView.dd_customUserAgent("xxx")
    /// ```
    func dd_customUserAgent(_ userAgent: String) -> Self {
        self.customUserAgent = userAgent
        return self
    }

    /// 设置自定义错误页面
    /// - Parameter html: 自定义错误页面的 HTML 内容
    /// - Returns: `Self`
    /// ```swift
    /// webView.dd_customErrorPage(html: "html代码")
    /// ```
    func dd_customErrorPage(html: String) -> Self {
        let script = "document.body.innerHTML = '\(html)';"
        Task {
            _ = try? await self.dd_executeJavaScript(script: script)
        }
        return self
    }

    /// 跳转到指定的锚点
    /// - Parameter anchor: 锚点的 ID
    /// - Returns: `Self`
    /// ```swift
    /// webView.dd_scrollToAnchor(anchor: "id")
    /// ```
    func dd_scrollToAnchor(anchor: String) -> Self {
        let script = "document.getElementById('\(anchor)').scrollIntoView();"
        Task {
            _ = try? await self.dd_executeJavaScript(script: script)
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
    /// webView.dd_addLoadingProgressObserver { progress in
    ///     print("网页加载进度：\(progress * 100)%")
    /// }
    /// ```
    func dd_addLoadingProgressObserver(progressHandler: @escaping (Float) -> Void) {
        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        // 保存闭包引用
        AssociatedObject.set(self, key: &AssociatedKeys.progressHandlerKey, value: progressHandler, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// 向WKWebView注入JavaScript脚本
    /// - Parameters:
    ///   - script: 要注入的JavaScript代码
    ///   - injectionTime: 脚本注入时机，默认是 `.atDocumentStart`
    ///   - forMainFrameOnly: 是否只注入到主框架，默认是 `false`
    /// - Returns: `Self`
    /// - Example:
    /// ```swift
    /// webView.dd_injectJavaScript(script: "alert('Hello, World!')")
    /// ```
    @discardableResult
    func dd_injectJavaScript(script: String,
                             injectionTime: WKUserScriptInjectionTime = .atDocumentStart,
                             forMainFrameOnly: Bool = false) -> Self
    {
        let userScript = WKUserScript(source: script,
                                      injectionTime: injectionTime,
                                      forMainFrameOnly: forMainFrameOnly)
        self.configuration.userContentController.addUserScript(userScript)
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
    ///     let result = try await webView.dd_executeJavaScript(script: "document.title")
    ///     print("JavaScript 执行结果: \(String(describing: result))")
    /// } catch {
    ///     // 如果执行失败，捕获并打印错误信息
    ///     print("JavaScript 执行失败，错误信息: \(error)")
    /// }
    /// ```
    @discardableResult
    func dd_executeJavaScript(script: String) async throws -> Any? {
        try await withCheckedThrowingContinuation { continuation in
            self.evaluateJavaScript(script) { result, error in
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

// MARK: - KVO
public extension WKWebView {
    /// 处理 KVO 监听到的变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let progress = change?[.newKey] as? Float {
            // 获取保存的 progressHandler
            Task { @MainActor in
                if let handler = AssociatedObject.get(self, key: &AssociatedKeys.progressHandlerKey) as? (Float) -> Void {
                    handler(progress)
                }
            }
        }
    }
}
