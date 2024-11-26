//
//  UISegmentedControl++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - 属性
public extension UISegmentedControl {
    /// 图片数组
    /// 获取或设置所有分段控件的图片。
    /// - Get: 返回一个包含所有分段图片的数组。
    /// - Set: 设置分段控件的图片，移除所有现有的分段并根据提供的图片数组进行重新插入。
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd_images = [image1, image2, image3]
    /// let images = segmentedControl.dd_images
    /// ```
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
    /// 获取或设置所有分段控件的标题。
    /// - Get: 返回一个包含所有分段标题的数组。
    /// - Set: 设置分段控件的标题，移除所有现有的分段并根据提供的标题数组进行重新插入。
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd_titles = ["First", "Second", "Third"]
    /// let titles = segmentedControl.dd_titles
    /// ```
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
public extension UISegmentedControl {
    /// 设置选中的分段
    /// - Parameter selectedSegmentIndex: 选中的分段索引
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd_selectSegment(at: 1)
    /// ```
    @discardableResult
    func dd_selectSegment(at selectedSegmentIndex: Int) -> Self {
        self.selectedSegmentIndex = selectedSegmentIndex
        return self
    }

    /// 设置控件的背景图片
    /// - Parameters:
    ///   - image: 背景图片
    ///   - state: 控件状态（例如 `normal`, `highlighted`）
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd_setBackgroundImage(image, for: .normal)
    /// ```
    @discardableResult
    func dd_setBackgroundImage(_ image: UIImage, for state: UIControl.State) -> Self {
        self.setBackgroundImage(image, for: state, barMetrics: .default)
        return self
    }

    /// 设置控件是否为瞬时的
    /// - Parameter isMomentary: 是否为瞬时的
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd_isMomentary(true)
    /// ```
    @discardableResult
    func dd_isMomentary(_ isMomentary: Bool) -> Self {
        self.isMomentary = isMomentary
        return self
    }

    /// 设置控件是否自动根据内容调整分段宽度
    /// - Parameter isAdjusted: 是否调整
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd_apportionsSegmentWidthsByContent(true)
    /// ```
    @discardableResult
    func dd_apportionsSegmentWidthsByContent(_ isAdjusted: Bool) -> Self {
        self.apportionsSegmentWidthsByContent = isAdjusted
        return self
    }

    /// 设置某个分段的宽度
    /// - Parameters:
    ///   - width: 宽度
    ///   - index: 分段索引
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd_setWidth(100, forSegmentAt: 0)
    /// ```
    @discardableResult
    func dd_setWidth(_ width: CGFloat, forSegmentAt index: Int) -> Self {
        self.setWidth(width, forSegmentAt: index)
        return self
    }
}
