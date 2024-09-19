//
//  UISegmentedControl+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 属性
public extension UISegmentedControl {
    /// 图片数组
    var dd_images: [UIImage] {
        get {
            let range = 0 ..< self.numberOfSegments
            return range.compactMap { self.imageForSegment(at: $0) }
        }
        set {
            self.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                self.insertSegment(with: image, at: index, animated: false)
            }
        }
    }

    /// 标题数组
    var dd_titles: [String] {
        get {
            let range = 0 ..< self.numberOfSegments
            return range.compactMap { self.titleForSegment(at: $0) }
        }
        set {
            self.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                self.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
}

// MARK: - 链式语法
public extension UISegmentedControl {}
