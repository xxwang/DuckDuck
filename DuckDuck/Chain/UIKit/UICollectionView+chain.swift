import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UICollectionView {
    /// 设置 `delegate` 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置 `dataSource` 代理
    /// - Parameter dataSource: 数据源对象
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.dataSource(self)
    /// ```
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.base.dataSource = dataSource
        return self
    }

    /// 注册 `UICollectionViewCell` (类名方式)
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.register(MyCustomCell.self)
    /// ```
    @discardableResult
    func register<T: UICollectionViewCell>(_ cell: T.Type) -> Self {
        self.base.dd_register(cellWithClass: T.self)
        return self
    }

    /// 设置 `UICollectionView` 布局
    /// - Parameters:
    ///   - layout: 新的布局
    ///   - animated: 是否启用动画
    ///   - completion: 布局设置完成后的回调
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.setCollectionViewLayout(newLayout, animated: true) { success in
    ///     // 布局设置完成后的处理
    /// }
    /// ```
    @discardableResult
    func setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> Self {
        self.base.setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 设置键盘消失模式
    /// - Parameter mode: 键盘消失模式
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.keyboardDismissMode(.onDrag)
    /// ```
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.base.keyboardDismissMode = mode
        return self
    }

    /// 滚动到指定的 `IndexPath`
    /// - Parameters:
    ///   - indexPath: 要滚动到的 `IndexPath`
    ///   - scrollPosition: 滚动的位置
    ///   - animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.scrollTo(IndexPath(item: 0, section: 0))
    /// ```
    @discardableResult
    func scrollTo(_ indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition = .top, animated: Bool = true) -> Self {
        if indexPath.section < 0
            || indexPath.item < 0
            || indexPath.section > self.base.numberOfSections
            || indexPath.row > self.base.numberOfItems(inSection: indexPath.section)
        {
            return self
        }
        self.base.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到指定的 `CGRect` 区域
    /// - Parameters:
    ///   - rect: 要滚动到的区域
    ///   - animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.scrollRectToVisible(CGRect(x: 0, y: 100, width: 200, height: 200))
    /// ```
    @discardableResult
    func scrollRectToVisible(_ rect: CGRect, animated: Bool = true) -> Self {
        guard rect.maxY <= self.base.dd_bottom else { return self }
        self.base.scrollRectToVisible(rect, animated: animated)
        return self
    }

    /// 滚动到顶部
    /// - Parameter animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.scrollToTop(animated: true)
    /// ```
    @discardableResult
    func scrollToTop(animated: Bool = true) -> Self {
        self.base.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 滚动到底部
    /// - Parameter animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.scrollToBottom(animated: true)
    /// ```
    @discardableResult
    func scrollToBottom(animated: Bool = true) -> Self {
        let y = self.base.contentSize.height - self.base.frame.size.height
        if y < 0 { return self }
        self.base.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    /// 设置 `UICollectionView` 的 `contentOffset`
    /// - Parameters:
    ///   - contentOffset: 新的 `contentOffset` 值
    ///   - animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd.setContentOffset(CGPoint(x: 0, y: 200))
    /// ```
    @discardableResult
    func setContentOffset(_ contentOffset: CGPoint = .zero, animated: Bool = true) -> Self {
        self.base.setContentOffset(contentOffset, animated: animated)
        return self
    }
}
