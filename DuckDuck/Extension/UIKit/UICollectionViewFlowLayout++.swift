import UIKit

// MARK: - UICollectionViewFlowLayout 链式语法
public extension UICollectionViewFlowLayout {
    /// 设置滚动方向间距
    /// - Parameter spacing: 滚动方向的间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_minimumLineSpacing(10)
    /// ```
    @discardableResult
    func dd_minimumLineSpacing(_ spacing: CGFloat) -> Self {
        self.minimumLineSpacing = spacing
        return self
    }

    /// 设置垂直于滚动方向的间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_minimumInteritemSpacing(5)
    /// ```
    @discardableResult
    func dd_minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        self.minimumInteritemSpacing = spacing
        return self
    }

    /// 设置`cell`的大小
    /// - Parameter size: `cell`的大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_itemSize(CGSize(width: 100, height: 100))
    /// ```
    @discardableResult
    func dd_itemSize(_ size: CGSize) -> Self {
        self.itemSize = size
        return self
    }

    /// 设置预估`cell`的大小
    /// - Parameter size: 预估的`cell`大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_estimatedItemSize(CGSize(width: 100, height: 100))
    /// ```
    @discardableResult
    func dd_estimatedItemSize(_ size: CGSize) -> Self {
        self.estimatedItemSize = size
        return self
    }

    /// 设置滚动方向
    /// - Parameter scrollDirection: 滚动方向
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_scrollDirection(.vertical)
    /// ```
    @discardableResult
    func dd_scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        self.scrollDirection = scrollDirection
        return self
    }

    /// 设置头部视图的大小
    /// - Parameter size: 头部视图的大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_headerReferenceSize(CGSize(width: 0, height: 50))
    /// ```
    @discardableResult
    func dd_headerReferenceSize(_ size: CGSize) -> Self {
        self.headerReferenceSize = size
        return self
    }

    /// 设置底部视图的大小
    /// - Parameter size: 底部视图的大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_footerReferenceSize(CGSize(width: 0, height: 30))
    /// ```
    @discardableResult
    func dd_footerReferenceSize(_ size: CGSize) -> Self {
        self.footerReferenceSize = size
        return self
    }

    /// 设置组的内间距
    /// - Parameter sectionInset: 组的内间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_sectionInset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    /// ```
    @discardableResult
    func dd_sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        self.sectionInset = sectionInset
        return self
    }

    /// 设置布局参考
    /// - Parameter sectionInsetReference: 布局参考枚举
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_sectionInsetReference(.fromSafeArea)
    /// ```
    @discardableResult
    func dd_sectionInsetReference(_ sectionInsetReference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        self.sectionInsetReference = sectionInsetReference
        return self
    }

    /// 设置组头是否悬停
    /// - Parameter sectionHeadersPinToVisibleBounds: 组头是否悬停
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_sectionHeadersPinToVisibleBounds(true)
    /// ```
    @discardableResult
    func dd_sectionHeadersPinToVisibleBounds(_ sectionHeadersPinToVisibleBounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }

    /// 设置组尾是否悬停
    /// - Parameter sectionFootersPinToVisibleBounds: 组尾是否悬停
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd_sectionFootersPinToVisibleBounds(false)
    /// ```
    @discardableResult
    func dd_sectionFootersPinToVisibleBounds(_ sectionFootersPinToVisibleBounds: Bool) -> Self {
        self.sectionFootersPinToVisibleBounds = sectionFootersPinToVisibleBounds
        return self
    }
}
