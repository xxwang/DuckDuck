//
//  UISegmentedControl+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 属性
public extension DDExtension where Base: UISegmentedControl {
    /// 图片数组
    var images: [UIImage] {
        get {
            let range = 0 ..< self.base.numberOfSegments
            return range.compactMap { self.base.imageForSegment(at: $0) }
        }
        set {
            self.base.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                self.base.insertSegment(with: image, at: index, animated: false)
            }
        }
    }

    /// 标题数组
    var titles: [String] {
        get {
            let range = 0 ..< self.base.numberOfSegments
            return range.compactMap { self.base.titleForSegment(at: $0) }
        }
        set {
            self.base.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                self.base.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
}

// MARK: - Defaultable
public extension UISegmentedControl {
    typealias Associatedtype = UISegmentedControl

    @objc override class func `default`() -> Associatedtype {
        return UISegmentedControl()
    }
}

// MARK: - 链式语法
public extension UISegmentedControl {}
