import UIKit

extension UICollectionViewFlowLayout: DDExtensionable {}

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UICollectionViewFlowLayout {
    /// 设置滚动方向间距
    /// - Parameter spacing: 滚动方向的间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.minimumLineSpacing(10)
    /// ```
    @discardableResult
    func minimumLineSpacing(_ spacing: CGFloat) -> Self {
        self.base.minimumLineSpacing = spacing
        return self
    }

    /// 设置垂直于滚动方向的间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.minimumInteritemSpacing(5)
    /// ```
    @discardableResult
    func minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        self.base.minimumInteritemSpacing = spacing
        return self
    }

    /// 设置`cell`的大小
    /// - Parameter size: `cell`的大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.itemSize(CGSize(width: 100, height: 100))
    /// ```
    @discardableResult
    func itemSize(_ size: CGSize) -> Self {
        self.base.itemSize = size
        return self
    }

    /// 设置预估`cell`的大小
    /// - Parameter size: 预估的`cell`大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.estimatedItemSize(CGSize(width: 100, height: 100))
    /// ```
    @discardableResult
    func estimatedItemSize(_ size: CGSize) -> Self {
        self.base.estimatedItemSize = size
        return self
    }

    /// 设置滚动方向
    /// - Parameter scrollDirection: 滚动方向
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.scrollDirection(.vertical)
    /// ```
    @discardableResult
    func scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        self.base.scrollDirection = scrollDirection
        return self
    }

    /// 设置头部视图的大小
    /// - Parameter size: 头部视图的大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.headerReferenceSize(CGSize(width: 0, height: 50))
    /// ```
    @discardableResult
    func headerReferenceSize(_ size: CGSize) -> Self {
        self.base.headerReferenceSize = size
        return self
    }

    /// 设置底部视图的大小
    /// - Parameter size: 底部视图的大小
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.footerReferenceSize(CGSize(width: 0, height: 30))
    /// ```
    @discardableResult
    func footerReferenceSize(_ size: CGSize) -> Self {
        self.base.footerReferenceSize = size
        return self
    }

    /// 设置组的内间距
    /// - Parameter sectionInset: 组的内间距
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.sectionInset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    /// ```
    @discardableResult
    func sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        self.base.sectionInset = sectionInset
        return self
    }

    /// 设置布局参考
    /// - Parameter sectionInsetReference: 布局参考枚举
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.sectionInsetReference(.fromSafeArea)
    /// ```
    @discardableResult
    func sectionInsetReference(_ sectionInsetReference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        self.base.sectionInsetReference = sectionInsetReference
        return self
    }

    /// 设置组头是否悬停
    /// - Parameter sectionHeadersPinToVisibleBounds: 组头是否悬停
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.sectionHeadersPinToVisibleBounds(true)
    /// ```
    @discardableResult
    func sectionHeadersPinToVisibleBounds(_ sectionHeadersPinToVisibleBounds: Bool) -> Self {
        self.base.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }

    /// 设置组尾是否悬停
    /// - Parameter sectionFootersPinToVisibleBounds: 组尾是否悬停
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// let layout = UICollectionViewFlowLayout()
    /// layout.dd.sectionFootersPinToVisibleBounds(false)
    /// ```
    @discardableResult
    func sectionFootersPinToVisibleBounds(_ sectionFootersPinToVisibleBounds: Bool) -> Self {
        self.base.sectionFootersPinToVisibleBounds = sectionFootersPinToVisibleBounds
        return self
    }
}
