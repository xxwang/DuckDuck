//
//  File.swift
//  
//
//  Created by 王哥 on 2024/7/4.
//

import UIKit

// MARK: - 计算属性
public extension DDExtension where Base: NSTextAttachment {
    /// 使用附件创建一个属性字符串
    var as2NSAttributedString: NSAttributedString {
        return NSAttributedString(attachment: self.base)
    }
}

// MARK: - Defaultable
public extension NSTextAttachment {
    public typealias Associatedtype = NSTextAttachment
    open override class func `default`() -> Associatedtype {
        return NSTextAttachment()
    }
}

// MARK: - 链式语法
public extension NSTextAttachment {
    /// 设置附件图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func dd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置附件边界
    /// - Parameter bounds: 边界
    /// - Returns: `Self`
    @discardableResult
    func dd_bounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
}
