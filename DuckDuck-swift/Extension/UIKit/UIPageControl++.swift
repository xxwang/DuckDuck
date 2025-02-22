import UIKit

// MARK: - 链式语法
public extension UIPageControl {
    /// 设置当前选中指示器的颜色
    /// - Parameter color: 选中指示器的颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// pageControl.dd_currentPageIndicatorTintColor(.red)
    /// ```
    @discardableResult
    func dd_currentPageIndicatorTintColor(_ color: UIColor) -> Self {
        self.currentPageIndicatorTintColor = color
        return self
    }

    /// 设置没有选中时的指示器颜色
    /// - Parameter color: 未选中指示器的颜色
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// pageControl.dd_pageIndicatorTintColor(.lightGray)
    /// ```
    @discardableResult
    func dd_pageIndicatorTintColor(_ color: UIColor) -> Self {
        self.pageIndicatorTintColor = color
        return self
    }

    /// 设置只有一页时是否隐藏分页指示器
    /// - Parameter isHidden: 是否隐藏分页指示器
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// pageControl.dd_hidesForSinglePage(true)
    /// ```
    @discardableResult
    func dd_hidesForSinglePage(_ isHidden: Bool) -> Self {
        self.hidesForSinglePage = isHidden
        return self
    }

    /// 设置当前页码
    /// - Parameter current: 当前页码
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// pageControl.dd_currentPage(2)
    /// ```
    @discardableResult
    func dd_currentPage(_ current: Int) -> Self {
        self.currentPage = current
        return self
    }

    /// 设置总页数
    /// - Parameter count: 总页数
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// pageControl.dd_numberOfPages(5)
    /// ```
    @discardableResult
    func dd_numberOfPages(_ count: Int) -> Self {
        self.numberOfPages = count
        return self
    }

    /// 设置分页控制的背景样式
    /// - Parameter style: 背景样式，指定背景样式来定制分页控件的外观
    /// - Returns: `Self`，以便继续链式调用
    ///
    /// 示例:
    /// ```swift
    /// pageControl.dd_backgroundStyle(.prominent)
    /// ```
    @discardableResult
    @available(iOS 14.0, *)
    func dd_backgroundStyle(_ style: UIPageControl.BackgroundStyle) -> Self {
        self.backgroundStyle = style
        return self
    }

    /// 设置分页控制的方向
    /// - Parameter direction: 分页控件的布局方向，可以是自然方向或反向方向
    /// - Returns: `Self`，以便继续链式调用
    ///
    /// 示例:
    /// ```swift
    /// pageControl.dd_direction(.rightToLeft)
    /// ```
    @discardableResult
    @available(iOS 16.0, *)
    func dd_direction(_ direction: UIPageControl.Direction) -> Self {
        self.direction = direction
        return self
    }

    /// 设置是否允许连续交互
    /// - Parameter allows: 是否允许连续交互，决定分页控件是否支持用户在页面之间的平滑滑动
    /// - Returns: `Self`，以便继续链式调用
    ///
    /// 示例:
    /// ```swift
    /// pageControl.dd_allowsContinuousInteraction(true)
    /// ```
    @discardableResult
    @available(iOS 14.0, *)
    func dd_allowsContinuousInteraction(_ allows: Bool) -> Self {
        self.allowsContinuousInteraction = allows
        return self
    }

    /// 设置指示器的首选图像
    /// - Parameter image: 图像，指定分页指示器的首选图像
    /// - Returns: `Self`，以便继续链式调用
    ///
    /// 示例:
    /// ```swift
    /// pageControl.dd_preferredIndicatorImage(UIImage(named: "indicator"))
    /// ```
    @discardableResult
    @available(iOS 14.0, *)
    func dd_preferredIndicatorImage(_ image: UIImage?) -> Self {
        self.preferredIndicatorImage = image
        return self
    }

    /// 设置当前页指示器的首选图像
    /// - Parameter image: 图像，指定当前页指示器的首选图像
    /// - Returns: `Self`，以便继续链式调用
    ///
    /// 示例:
    /// ```swift
    /// pageControl.dd_preferredCurrentPageIndicatorImage(UIImage(named: "currentIndicator"))
    /// ```
    @discardableResult
    @available(iOS 16.0, *)
    func dd_preferredCurrentPageIndicatorImage(_ image: UIImage?) -> Self {
        self.preferredCurrentPageIndicatorImage = image
        return self
    }

    /// 设置每一页的自定义指示器图像
    /// - Parameter image: 指示器图像，指定某一页的自定义指示器图像
    /// - Parameter page: 页码，指定要设置的页码
    /// - Returns: `Self`，以便继续链式调用
    ///
    /// 示例:
    /// ```swift
    /// pageControl.dd_indicatorImage(UIImage(named: "customIndicator"), forPage: 0)
    /// ```
    @discardableResult
    @available(iOS 14.0, *)
    func dd_indicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        self.setIndicatorImage(image, forPage: page)
        return self
    }

    /// 设置每一页的自定义当前页指示器图像
    /// - Parameter image: 当前页指示器图像，指定某一页的自定义当前页指示器图像
    /// - Parameter page: 页码，指定要设置的页码
    /// - Returns: `Self`，以便继续链式调用
    ///
    /// 示例:
    /// ```swift
    /// pageControl.dd_currentPageIndicatorImage(UIImage(named: "currentPageCustomIndicator"), forPage: 1)
    /// ```
    @discardableResult
    @available(iOS 16.0, *)
    func dd_currentPageIndicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        self.setCurrentPageIndicatorImage(image, forPage: page)
        return self
    }
}
