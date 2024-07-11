//
//  UINavigationItem+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 方法
public extension DDExtension where Base: UINavigationItem {
    /// 设置导航栏`titleView`为图片
    /// - Parameters:
    ///   - image: 要设置的图片
    ///   - size: 大小
    func titleView(with image: UIImage, size: CGSize = CGSize(width: 100, height: 30)) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.base.titleView = imageView
    }
}

// MARK: - Defaultable
extension UINavigationItem: Defaultable {
    public typealias Associatedtype = UINavigationItem

    @objc open class func `default`() -> Associatedtype {
        return UINavigationItem()
    }
}

// MARK: - 链式语法
public extension UINavigationItem {
    /// 设置大导航显示模型
    /// - Parameter mode:模型
    /// - Returns:`Self`
    @discardableResult
    func dd_largeTitleDisplayMode(_ mode: LargeTitleDisplayMode) -> Self {
        self.largeTitleDisplayMode = mode
        return self
    }

    /// 设置导航标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func dd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置标题栏自定义标题
    /// - Parameter view:自定义标题view
    /// - Returns:`Self`
    @discardableResult
    func dd_titleView(_ view: UIView?) -> Self {
        self.titleView = view
        return self
    }
}
