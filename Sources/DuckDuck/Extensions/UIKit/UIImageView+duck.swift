//
//  UIImageView+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - Defaultable
public extension UIImageView {
    public typealias Associatedtype = UIImageView
    open override class func `default`() -> Associatedtype {
        return UIImageView()
    }
}

// MARK: - 链式语法
public extension UIImageView {
    /// 设置图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func dd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置高亮状态的图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func dd_highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    /// 设置模糊效果
    /// - Parameter style:模糊效果样式
    /// - Returns:`Self`
    @discardableResult
    func dd_blur(_ style: UIBlurEffect.Style = .light) -> Self {
        self.dd.blur(with: style)
        return self
    }
}
