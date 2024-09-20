//
//  UIScrollView+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import UIKit

// MARK: - 方法
public extension UIScrollView {
    /// 滚动视图的当前可见区域
    func dd_visibleRect() -> CGRect {
        let contentWidth = contentSize.width - contentOffset.x
        let contentHeight = contentSize.height - contentOffset.y
        return CGRect(
            origin: contentOffset,
            size: CGSize(width: Swift.min(Swift.min(bounds.size.width, contentSize.width), contentWidth),
                         height: Swift.min(Swift.min(bounds.size.height, contentSize.height), contentHeight))
        )
    }
}

// MARK: - 截图
public extension UIScrollView {
    /// 获取`ScrollView`当前可见的部分的快照`截图`
    override func dd_captureScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = frame
        frame = CGRect(origin: frame.origin, size: contentSize)
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        frame = previousFrame

        return image
    }

    /// 截取整个`ScrollView``contentSize`的快照(截图)
    /// - Parameter completion:完成回调
    func dd_captureLongScreenshot(_ completion: @escaping (_ image: UIImage?) -> Void) {
        // 放一个假的封面
        let snapshotView = snapshotView(afterScreenUpdates: true)
        snapshotView?.frame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: (snapshotView?.frame.width)!,
            height: (snapshotView?.frame.height)!
        )
        superview?.addSubview(snapshotView!)

        // 基的原点偏移
        let originOffset = contentOffset
        // 计算页数
        let page = floorf(Float(contentSize.height / bounds.height))
        // 打开位图上下文大小为截图的大小
        UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.main.scale)

        // 这个方法是一个绘图,里面可能有递归调用
        dd_screenshot(index: 0, maxIndex: page.dd_Int()) {
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // 设置原点偏移
            self.setContentOffset(originOffset, animated: false)
            // 移除封面
            snapshotView?.removeFromSuperview()
            // 获取 snapShotContentScroll 时的回调图像
            completion(screenShotImage)
        }
    }

    /// 根据偏移量和页数绘制
    /// - Parameters:
    ///   - index:当前要绘制的页码索引
    ///   - maxIndex:最大页码索引
    ///   - callback:完成回调
    func dd_screenshot(index: Int, maxIndex: Int, callback: @escaping () -> Void) {
        setContentOffset(
            CGPoint(
                x: 0,
                y: index.dd_CGFloat() * frame.size.height
            ),
            animated: false
        )
        let splitFrame = CGRect(
            x: 0,
            y: index.dd_CGFloat() * frame.size.height,
            width: bounds.width,
            height: bounds.height
        )

        DispatchQueue.dd_delay_execute(delay: 0.3) {
            self.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            if index < maxIndex {
                self.dd_screenshot(index: index + 1, maxIndex: maxIndex, callback: callback)
            } else {
                callback()
            }
        }
    }
}

// MARK: - 链式语法
public extension UIScrollView {
    /// 设置代理
    /// - Parameter delegate:代理
    /// - Returns:`Self`
    @discardableResult
    func dd_delegate(_ delegate: UIScrollViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置偏移量
    /// - Parameter offset:偏移量
    /// - Returns:`Self`
    @discardableResult
    func dd_contentOffset(_ offset: CGPoint) -> Self {
        contentOffset = offset
        return self
    }

    /// 设置滑动区域大小`CGSize`
    /// - Parameter size:滑动区域大小
    /// - Returns:`Self`
    @discardableResult
    func dd_contentSize(_ size: CGSize) -> Self {
        contentSize = size
        return self
    }

    /// 设置边缘插入内容以外的可滑动区域(`UIEdgeInsets`),默认是`UIEdgeInsetsZero`(提示:必须设置`contentSize`后才有效)
    /// - Parameter inset:`UIEdgeInsets`
    /// - Returns:`Self`
    @discardableResult
    func dd_contentInset(_ inset: UIEdgeInsets) -> Self {
        contentInset = inset
        return self
    }

    ///  设置弹性效果,默认是`true`, 如果设置成`false`,则当你滑动到边缘时将不具有弹性效果
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func dd_bounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }

    /// 水平方向 总是可以弹性滑动,默认是 `false`
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func dd_alwaysBounceHorizontal(_ bounces: Bool) -> Self {
        alwaysBounceHorizontal = bounces
        return self
    }

    /// 竖直方向总是可以弹性滑动,默认是 `false`
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func dd_alwaysBounceVertical(_ bounces: Bool) -> Self {
        alwaysBounceVertical = bounces
        return self
    }

    /// 设置是否可分页,默认是`false`, 如果设置成`true`, 则可分页
    /// - Parameter enabled:是否可分页
    /// - Returns:`Self`
    @discardableResult
    func dd_isPagingEnabled(_ enabled: Bool) -> Self {
        isPagingEnabled = enabled
        return self
    }

    /// 是否显示 水平 方向滑动条,默认是`true`, 如果设置为`false`,当滑动的时候则不会显示水平滑动条
    /// - Parameter enabled:是否显示水平方向滑动条
    /// - Returns:`Self`
    @discardableResult
    func dd_showsHorizontalScrollIndicator(_ enabled: Bool) -> Self {
        showsHorizontalScrollIndicator = enabled
        return self
    }

    /// 是否显示 垂直 方向滑动条,默认是`true`, 如果设置为`false`,当滑动的时候则不会显示水平滑动条
    /// - Parameter enabled:是否显示垂直方向滑动条
    /// - Returns:`Self`
    @discardableResult
    func dd_showsVerticalScrollIndicator(_ enabled: Bool) -> Self {
        showsVerticalScrollIndicator = enabled
        return self
    }

    /// 设置滑动条的边缘插入,即是距离上、左、下、右的距离,比如:top(20) 当向下滑动时,滑动条距离顶部的距离总是 20
    /// - Parameter inset:`UIEdgeInset`
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollIndicatorInsets(_ inset: UIEdgeInsets) -> Self {
        scrollIndicatorInsets = inset
        return self
    }

    /// 是否可滑动,默认是true, 如果默认为`false`, 则无法滑动
    /// - Parameter enabled:是否可滑动
    /// - Returns:`Self`
    @discardableResult
    func dd_isScrollEnabled(_ enabled: Bool) -> Self {
        isScrollEnabled = enabled
        return self
    }

    /// 设置滑动条颜色,默认是灰白色
    /// - Parameter indicatorStyle:滑动条颜色
    /// - Returns:`Self`
    @discardableResult
    func dd_indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        indicatorStyle = style
        return self
    }

    /// 设置减速率,`CGFloat`类型,当你滑动松开手指后的减速速率, 但是尽管`decelerationRate`是一个`CGFloat`类型,但是目前系统只支持以下两种速率设置选择:`fast` 和 `normal`
    /// - Parameter rate:减速率
    /// - Returns:`Self`
    @discardableResult
    func dd_decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        decelerationRate = rate
        return self
    }

    /// 锁住水平或竖直方向的滑动, 默认为`false`,如果设置为TRUE,那么在推拖拽`UIScrollView`的时候,会锁住水平或竖直方向的滑动
    /// - Parameter enabled:是否锁住
    /// - Returns:`Self`
    @discardableResult
    func dd_isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        isDirectionalLockEnabled = enabled
        return self
    }

    /// 设置是否滚动到顶部
    /// - Parameter scrollsToTop: 是否可以滚动到顶部
    /// - Returns: `Self`
    @discardableResult
    func dd_scrollsToTop(_ scrollsToTop: Bool) -> Self {
        self.scrollsToTop = scrollsToTop
        return self
    }

    /// 滚动至最顶部
    /// - Parameter animated:`true`以恒定速度过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToEndTop(_ animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: contentOffset.x, y: -contentInset.top), animated: animated)
        return self
    }

    /// 滚动至最底部
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToEndBottom(_ animated: Bool = true) -> Self {
        setContentOffset(CGPoint(
            x: contentOffset.x,
            y: Swift.max(0, contentSize.height - bounds.height) + contentInset.bottom
        ),
        animated: animated)
        return self
    }

    /// 滚动至最左侧
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToEndLeft(_ animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: -contentInset.left, y: contentOffset.y), animated: animated)
        return self
    }

    /// 滚动至最右侧
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToEndRight(_ animated: Bool = true) -> Self {
        setContentOffset(
            CGPoint(
                x: Swift.max(0, contentSize.width - bounds.width) + contentInset.right,
                y: contentOffset.y
            ),
            animated: animated
        )
        return self
    }

    /// 在滚动视图中向上滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用上一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollUp(_ animated: Bool = true) -> Self {
        let minY = -contentInset.top
        var y = Swift.max(minY, contentOffset.y - bounds.height)
        #if !os(tvOS)
            if isPagingEnabled, bounds.height != 0 {
                let page = Swift.max(0, ((y + contentInset.top) / bounds.height).rounded(.down))
                y = Swift.max(minY, page * bounds.height - contentInset.top)
            }
        #endif
        setContentOffset(CGPoint(x: contentOffset.x, y: y), animated: animated)
        return self
    }

    /// 在滚动视图中向下滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用下一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollDown(_ animated: Bool = true) -> Self {
        let maxY = Swift.max(0, contentSize.height - bounds.height) + contentInset.bottom
        var y = Swift.min(maxY, contentOffset.y + bounds.height)
        #if !os(tvOS)
            if isPagingEnabled, bounds.height != 0 {
                let page = ((y + contentInset.top) / bounds.height).rounded(.down)
                y = Swift.min(maxY, page * bounds.height - contentInset.top)
            }
        #endif
        setContentOffset(CGPoint(x: contentOffset.x, y: y), animated: animated)
        return self
    }

    /// 在滚动视图中向左滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用上一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollLeft(_ animated: Bool = true) -> Self {
        let minX = -contentInset.left
        var x = Swift.max(minX, contentOffset.x - bounds.width)
        #if !os(tvOS)
            if isPagingEnabled, bounds.width != 0 {
                let page = ((x + contentInset.left) / bounds.width).rounded(.down)
                x = Swift.max(minX, page * bounds.width - contentInset.left)
            }
        #endif
        setContentOffset(CGPoint(x: x, y: contentOffset.y), animated: animated)
        return self
    }

    /// 在滚动视图中向右滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用下一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollRight(_ animated: Bool = true) -> Self {
        let maxX = Swift.max(0, contentSize.width - bounds.width) + contentInset.right
        var x = Swift.min(maxX, contentOffset.x + bounds.width)
        #if !os(tvOS)
            if isPagingEnabled, bounds.width != 0 {
                let page = ((x + contentInset.left) / bounds.width).rounded(.down)
                x = Swift.min(maxX, page * bounds.width - contentInset.left)
            }
        #endif
        setContentOffset(CGPoint(x: x, y: contentOffset.y), animated: animated)
        return self
    }
}
