import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UIScrollView {
    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置偏移量
    /// - Parameter offset: 偏移量
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.contentOffset(CGPoint(x: 0, y: 100))
    /// ```
    @discardableResult
    func contentOffset(_ offset: CGPoint) -> Self {
        self.base.contentOffset = offset
        return self
    }

    /// 设置滑动区域大小 `CGSize`
    /// - Parameter size: 滑动区域大小
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.contentSize(CGSize(width: 1000, height: 2000))
    /// ```
    @discardableResult
    func contentSize(_ size: CGSize) -> Self {
        self.base.contentSize = size
        return self
    }

    /// 设置边缘插入内容以外的可滑动区域 (`UIEdgeInsets`), 默认是 `UIEdgeInsets.zero`
    /// - Parameter inset: `UIEdgeInsets`
    /// - Returns: `Self`
    /// - Note: 必须设置 `contentSize` 后才有效
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.contentInset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    /// ```
    @discardableResult
    func contentInset(_ inset: UIEdgeInsets) -> Self {
        self.base.contentInset = inset
        return self
    }

    /// 设置弹性效果, 默认是 `true`, 如果设置成 `false`, 则当你滑动到边缘时将不具有弹性效果
    /// - Parameter bounces: 是否有弹性
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.bounces(false)
    /// ```
    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        self.base.bounces = bounces
        return self
    }

    /// 水平方向总是可以弹性滑动, 默认是 `false`
    /// - Parameter bounces: 是否有弹性
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.alwaysBounceHorizontal(true)
    /// ```
    @discardableResult
    func alwaysBounceHorizontal(_ bounces: Bool) -> Self {
        self.base.alwaysBounceHorizontal = bounces
        return self
    }

    /// 竖直方向总是可以弹性滑动, 默认是 `false`
    /// - Parameter bounces: 是否有弹性
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.alwaysBounceVertical(true)
    /// ```
    @discardableResult
    func alwaysBounceVertical(_ bounces: Bool) -> Self {
        self.base.alwaysBounceVertical = bounces
        return self
    }

    /// 设置是否可分页, 默认是 `false`, 如果设置成 `true`, 则可分页
    /// - Parameter enabled: 是否可分页
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.isPagingEnabled(true)
    /// ```
    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        self.base.isPagingEnabled = enabled
        return self
    }

    /// 是否显示水平方向滑动条, 默认是 `true`, 如果设置为 `false`, 当滑动的时候则不会显示水平滑动条
    /// - Parameter enabled: 是否显示水平方向滑动条
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.showsHorizontalScrollIndicator(false)
    /// ```
    @discardableResult
    func showsHorizontalScrollIndicator(_ enabled: Bool) -> Self {
        self.base.showsHorizontalScrollIndicator = enabled
        return self
    }

    /// 是否显示垂直方向滑动条, 默认是 `true`, 如果设置为 `false`, 当滑动的时候则不会显示垂直滑动条
    /// - Parameter enabled: 是否显示垂直方向滑动条
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.showsVerticalScrollIndicator(false)
    /// ```
    @discardableResult
    func showsVerticalScrollIndicator(_ enabled: Bool) -> Self {
        self.base.showsVerticalScrollIndicator = enabled
        return self
    }

    /// 设置滑动条的边缘插入, 即是距离上、左、下、右的距离
    /// - Parameter inset: `UIEdgeInsets`
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollIndicatorInsets(UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    /// ```
    @discardableResult
    func scrollIndicatorInsets(_ inset: UIEdgeInsets) -> Self {
        self.base.scrollIndicatorInsets = inset
        return self
    }

    /// 是否可滑动, 默认是 `true`, 如果设置为 `false`, 则无法滑动
    /// - Parameter enabled: 是否可滑动
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.isScrollEnabled(false)
    /// ```
    @discardableResult
    func isScrollEnabled(_ enabled: Bool) -> Self {
        self.base.isScrollEnabled = enabled
        return self
    }

    /// 设置滑动条颜色, 默认是灰白色
    /// - Parameter indicatorStyle: 滑动条颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.indicatorStyle(.black)
    /// ```
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        self.base.indicatorStyle = style
        return self
    }

    /// 设置减速率, `CGFloat` 类型, 当你滑动松开手指后的减速速率, 目前系统只支持以下两种速率设置选择: `fast` 和 `normal`
    /// - Parameter rate: 减速率
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.decelerationRate(.fast)
    /// ```
    @discardableResult
    func decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        self.base.decelerationRate = rate
        return self
    }

    /// 锁住水平或竖直方向的滑动, 默认为 `false`, 如果设置为 `true`, 在拖拽时会锁住水平或竖直方向的滑动
    /// - Parameter enabled: 是否锁住
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.isDirectionalLockEnabled(true)
    /// ```
    @discardableResult
    func isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        self.base.isDirectionalLockEnabled = enabled
        return self
    }

    /// 设置是否滚动到顶部
    /// - Parameter scrollsToTop: 是否可以滚动到顶部
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollsToTop(true)
    /// ```
    @discardableResult
    func scrollsToTop(_ scrollsToTop: Bool) -> Self {
        self.base.scrollsToTop = scrollsToTop
        return self
    }

    /// 滚动至最顶部
    /// - Parameter animated: `true` 以恒定速度过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollToEndTop(animated: true)
    /// ```
    @discardableResult
    func scrollToEndTop(_ animated: Bool = true) -> Self {
        self.base.setContentOffset(CGPoint(x: self.base.contentOffset.x, y: -self.base.contentInset.top), animated: animated)
        return self
    }

    /// 滚动至最底部
    /// - Parameter animated: `true` 以恒定速度设置过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollToEndBottom(animated: true)
    /// ```
    @discardableResult
    func scrollToEndBottom(_ animated: Bool = true) -> Self {
        self.base.setContentOffset(CGPoint(
            x: self.base.contentOffset.x,
            y: Swift.max(0, self.base.contentSize.height - self.base.bounds.height) + self.base.contentInset.bottom
        ), animated: animated)
        return self
    }

    /// 滚动至最左侧
    /// - Parameter animated: `true` 以恒定速度设置过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollToEndLeft(animated: true)
    /// ```
    @discardableResult
    func scrollToEndLeft(_ animated: Bool = true) -> Self {
        self.base.setContentOffset(CGPoint(x: -self.base.contentInset.left, y: self.base.contentOffset.y), animated: animated)
        return self
    }

    /// 滚动至最右侧
    /// - Parameter animated: `true` 以恒定速度设置过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollToEndRight(animated: true)
    /// ```
    @discardableResult
    func scrollToEndRight(_ animated: Bool = true) -> Self {
        self.base.setContentOffset(
            CGPoint(
                x: Swift.max(0, self.base.contentSize.width - self.base.bounds.width) + self.base.contentInset.right,
                y: self.base.contentOffset.y
            ),
            animated: animated
        )
        return self
    }

    /// 在滚动视图中向上滚动一页
    /// 如果 `isPaginEnabled` 为 `true`, 则使用上一页位置
    /// - Parameter animated: `true` 以恒定速度设置过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollUp(animated: true)
    /// ```
    @discardableResult
    func scrollUp(_ animated: Bool = true) -> Self {
        let minY = -self.base.contentInset.top
        var y = Swift.max(minY, self.base.contentOffset.y - self.base.bounds.height)
        #if !os(tvOS)
            if self.base.isPagingEnabled, self.base.bounds.height != 0 {
                let page = Swift.max(0, ((y + self.base.contentInset.top) / self.base.bounds.height).rounded(.down))
                y = Swift.max(minY, page * self.base.bounds.height - self.base.contentInset.top)
            }
        #endif
        self.base.setContentOffset(CGPoint(x: self.base.contentOffset.x, y: y), animated: animated)
        return self
    }

    /// 在滚动视图中向下滚动一页
    /// 如果 `isPaginEnabled` 为 `true`, 则使用下一页位置
    /// - Parameter animated: `true` 以恒定速度设置过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollDown(animated: true)
    /// ```
    @discardableResult
    func scrollDown(_ animated: Bool = true) -> Self {
        let maxY = Swift.max(0, self.base.contentSize.height - self.base.bounds.height) + self.base.contentInset.bottom
        var y = Swift.min(maxY, self.base.contentOffset.y + self.base.bounds.height)
        #if !os(tvOS)
            if self.base.isPagingEnabled, self.base.bounds.height != 0 {
                let page = ((y + self.base.contentInset.top) / self.base.bounds.height).rounded(.down)
                y = Swift.min(maxY, page * self.base.bounds.height - self.base.contentInset.top)
            }
        #endif
        self.base.setContentOffset(CGPoint(x: self.base.contentOffset.x, y: y), animated: animated)
        return self
    }

    /// 在滚动视图中向左滚动一页
    /// 如果 `isPaginEnabled` 为 `true`, 则使用上一页位置
    /// - Parameter animated: `true` 以恒定速度设置过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollLeft(animated: true)
    /// ```
    @discardableResult
    func scrollLeft(_ animated: Bool = true) -> Self {
        let minX = -self.base.contentInset.left
        var x = Swift.max(minX, self.base.contentOffset.x - self.base.bounds.width)
        #if !os(tvOS)
            if self.base.isPagingEnabled, self.base.bounds.width != 0 {
                let page = ((x + self.base.contentInset.left) / self.base.bounds.width).rounded(.down)
                x = Swift.max(minX, page * self.base.bounds.width - self.base.contentInset.left)
            }
        #endif
        self.base.setContentOffset(CGPoint(x: x, y: self.base.contentOffset.y), animated: animated)
        return self
    }

    /// 在滚动视图中向右滚动一页
    /// 如果 `isPaginEnabled` 为 `true`, 则使用下一页位置
    /// - Parameter animated: `true` 以恒定速度设置过渡到新偏移的动画, `false` 立即进行过渡
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// scrollView.dd.scrollRight(animated: true)
    /// ```
    @discardableResult
    func scrollRight(_ animated: Bool = true) -> Self {
        let maxX = Swift.max(0, self.base.contentSize.width - self.base.bounds.width) + self.base.contentInset.right
        var x = Swift.min(maxX, self.base.contentOffset.x + self.base.bounds.width)
        #if !os(tvOS)
            if self.base.isPagingEnabled, self.base.bounds.width != 0 {
                let page = ((x + self.base.contentInset.left) / self.base.bounds.width).rounded(.down)
                x = Swift.min(maxX, page * self.base.bounds.width - self.base.contentInset.left)
            }
        #endif
        self.base.setContentOffset(CGPoint(x: x, y: self.base.contentOffset.y), animated: animated)
        return self
    }
}
