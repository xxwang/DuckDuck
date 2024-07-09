//
//  URL+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import AVFoundation
import UIKit

extension URL: WGable {}

// MARK: - 构造方法
public extension URL {
    /// 使用基础`URL`和`路径字符串`初始化`URL`对象
    /// - Parameters:
    ///   - string: `URL`路径
    ///   - url: 基础`URL`
    init?(path string: String?, base url: URL? = nil) {
        guard let string else { return nil }
        self.init(string: string, relativeTo: url)
    }
}

// MARK: - 方法
public extension DDExtension where Base == URL {
    /// 检测应用是否能打开这个`URL`
    /// - Returns: `Bool`
    func canOpen() -> Bool {
        return UIApplication.shared.canOpenURL(self.base)
    }

    /// 以字典形式返回`URL`的参数
    /// - Returns: 参数字典
    func parameters() -> [String: String]? {
        guard let components = URLComponents(url: self.base, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

    /// 给`URL`添加参数列表,并返回`URL`
    ///
    ///     let url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.dd.appendParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数列表
    /// - Returns: 带参数列表的`URL`
    func appendParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self.base, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        return urlComponents.url!
    }

    /// 给`URL`添加参数列表
    ///
    ///     var url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.dd.appendParameters(params)
    ///     print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数列表
    func appendParameters(_ parameters: [String: String]) {
        self.base = self.appendParameters(parameters)
    }

    /// 获取查询参数中键对应的值
    ///
    ///     var url = URL(string:"https://google.com?code=12345")!
    ///     url.dd.queryValue(for:"code") -> "12345"
    ///
    /// - Parameter key: 键
    /// - Returns: 参数字符串
    func queryValue(for key: String) -> String? {
        return URLComponents(string: self.base.absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// 删除所有路径组件返回新`URL`
    ///
    ///     let url = URL(string:"https://domain.com/path/other")!
    ///     print(url.dd.deleteAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns: 结果`URL`
    func deleteAllPathComponents() -> URL {
        var url: URL = self.base
        for _ in 0 ..< self.base.pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// 从`URL`中删除所有路径组件
    ///
    ///     var url = URL(string:"https://domain.com/path/other")!
    ///     url.dd.deleteAllPathComponents()
    ///     print(url) // prints "https://domain.com/"
    ///
    func deleteAllPathComponents() {
        for _ in 0 ..< self.base.pathComponents.count - 1 {
            self.base.deleteLastPathComponent()
        }
    }

    /// 删除`URL`中的协议部分
    ///
    ///     let url = URL(string:"https://domain.com")!
    ///     print(url.dd.droppedScheme()) // prints "domain.com"
    ///
    /// - Returns: 新的`URL`
    func droppedScheme() -> URL? {
        if let scheme = self.base.scheme {
            let droppedScheme = String(self.base.absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }
        guard self.base.host != nil else { return self.base }
        let droppedScheme = String(self.base.absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    /// 根据视频`URL`在指定时间`秒`截取图像
    ///
    ///     var url = URL(string:"https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    ///     var thumbnail = url.dd.thumbnail()
    ///     thumbnail = url.dd.thumbnail(fromTime:5)
    ///
    ///     DisptachQueue.main.async {
    ///      someImageView.image = url.thumbnail()
    ///     }
    ///
    /// - Parameter time: 需要生成图片的视频的时间`秒`
    /// - Returns: 截取的图片
    func thumbnail(from time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self.base))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}


// MARK: - 链式语法
public extension URL {
    /// 向`URL`中追加路径
    /// - Parameter path: 要追加的路径
    /// - Returns: `Self`
    func dd_appendingPathComponent(_ path: String) -> Self {
        if #available(iOS 16.0, *) {
            return self.appending(component: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }
}
