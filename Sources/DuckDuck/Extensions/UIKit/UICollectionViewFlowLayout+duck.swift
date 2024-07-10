//
//  UICollectionViewFlowLayout+duck.swift
//
//
//  Created by 王哥 on 2024/6/18.
//

import UIKit

public extension UICollectionViewFlowLayout: Defaultable {
    typealias Associatedtype = UICollectionViewFlowLayout
    @objc open class func `default`() -> Associatedtype {
        return UICollectionViewFlowLayout()
    }
}

// MARK: - 链式语法
public extension UICollectionViewFlowLayout {
    /// 设置滚动方向间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func dd_minimumLineSpacing(_ spacing: CGFloat) -> Self {
        self.minimumLineSpacing = spacing
        return self
    }

    /// 设置垂直于滚动方向间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func dd_minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        self.minimumInteritemSpacing = spacing
        return self
    }

    /// 设置`cell`大小
    /// - Parameter size: `cell`大小
    /// - Returns: `Self`
    @discardableResult
    func dd_itemSize(_ size: CGSize) -> Self {
        self.itemSize = size
        return self
    }

    /// 设置预估`cell`大小
    /// - Parameter size: 预估`cell`大小
    /// - Returns: `Self`
    @discardableResult
    func dd_estimatedItemSize(_ size: CGSize) -> Self {
        self.estimatedItemSize = size
        return self
    }

    /// 设置滚动方向
    /// - Parameter scrollDirection: 滚动方向
    /// - Returns: `Self`
    @discardableResult
    func dd_scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        self.scrollDirection = scrollDirection
        return self
    }

    /// 设置头部视图大小
    /// - Parameter size: 大小
    /// - Returns: `Self`
    @discardableResult
    func dd_headerReferenceSize(_ size: CGSize) -> Self {
        self.headerReferenceSize = size
        return self
    }

    /// 设置底部视图大小
    /// - Parameter size: 大小
    /// - Returns: `Self`
    @discardableResult
    func dd_footerReferenceSize(_ size: CGSize) -> Self {
        self.footerReferenceSize = size
        return self
    }

    @discardableResult
    /// 设置组的内间距
    /// - Parameter sectionInset: 内间距
    /// - Returns: `Self`
    func dd_sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        self.sectionInset = sectionInset
        return self
    }

    /// 设置布局参考
    /// - Parameter sectionInsetReference: 布局参考枚举
    /// - Returns: `Self`
    @discardableResult
    func dd_sectionInsetReference(_ sectionInsetReference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        self.sectionInsetReference = sectionInsetReference
        return self
    }

    /// 设置组头是否悬停
    /// - Parameter sectionHeadersPinToVisibleBounds: 是否悬停
    /// - Returns: `Self`
    @discardableResult
    func dd_sectionHeadersPinToVisibleBounds(_ sectionHeadersPinToVisibleBounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }

    /// 设置组尾是否悬停
    /// - Parameter sectionHeadersPinToVisibleBounds: 是否悬停
    /// - Returns: `Self`
    @discardableResult
    func dd_sectionFootersPinToVisibleBounds(_ sectionFootersPinToVisibleBounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }
}
