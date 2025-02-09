import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIStackView {
    /// 设置子控件的布局方向（水平方向或垂直方向，即轴方向）
    /// - Parameter axis: 轴方向，`NSLayoutConstraint.Axis.horizontal` 或 `NSLayoutConstraint.Axis.vertical`
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.axis(.vertical)
    /// ```
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.base.axis = axis
        return self
    }

    /// 设置子视图在轴向上的分布方式
    /// - Parameter distribution: 分布方式
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.distribution(.fillEqually)
    /// ```
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.base.distribution = distribution
        return self
    }

    /// 设置对齐模式
    /// - Parameter alignment: 对齐模式
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.alignment(.center)
    /// ```
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.base.alignment = alignment
        return self
    }

    /// 设置子控件之间的间距
    /// - Parameter spacing: 子控件间距
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.spacing(10.0)
    /// ```
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        self.base.spacing = spacing
        return self
    }

    /// 设置自定义间距（iOS 11 及以上）
    /// - Parameters:
    ///   - spacing: 自定义间距
    ///   - arrangedSubview: 要设置间距的视图后面
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// stackView.dd.setCustomSpacing(10, after: arrangedSubview)
    /// ```
    @discardableResult
    func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
        self.base.setCustomSpacing(spacing, after: arrangedSubview)
        return self
    }

    /// 设置布局时是否参照基准线, 默认是 `false`（决定了垂直轴如果是文本的话，是否按照 `baseline` 来参与布局）
    /// - Parameter arrangement: 是否参照基线进行布局
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.isBaselineRelativeArrangement(true)
    /// ```
    @discardableResult
    func isBaselineRelativeArrangement(_ arrangement: Bool) -> Self {
        self.base.isBaselineRelativeArrangement = arrangement
        return self
    }

    /// 设置布局时是否以控件的 `LayoutMargins` 为标准，默认为 `false`（以控件的 `bounds` 为标准）
    /// - Parameter arrangement: 是否以控件的 `LayoutMargins` 为标准
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.isLayoutMarginsRelativeArrangement(true)
    /// ```
    @discardableResult
    func isLayoutMarginsRelativeArrangement(_ arrangement: Bool) -> Self {
        self.base.isLayoutMarginsRelativeArrangement = arrangement
        return self
    }

    /// 设置布局边距
    /// - Parameter margins: 设置堆栈视图的布局边距
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// stackView.dd.layoutMargins(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    /// ```
    @discardableResult
    func layoutMargins(_ margins: UIEdgeInsets) -> Self {
        self.base.layoutMargins = margins
        return self
    }

    /// 设置堆栈视图是否保留父视图的布局边距
    /// - Parameter preserves: 是否保留父视图的布局边距
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// stackView.dd.preservesSuperviewLayoutMargins(true)
    /// ```
    @discardableResult
    func preservesSuperviewLayoutMargins(_ preserves: Bool) -> Self {
        self.base.preservesSuperviewLayoutMargins = preserves
        return self
    }

    /// 添加多个排列的子视图
    /// - Parameter items: 子视图数组
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.addArrangedSubviews(view1, view2, view3)
    /// ```
    @discardableResult
    func addArrangedSubviews(_ items: UIView...) -> Self {
        self.base.dd_addArrangedSubviews(items)
        return self
    }

    /// 将多个视图添加到堆栈视图的末尾
    ///
    /// - Parameter views: 要添加的视图数组
    ///
    /// - Returns: 当前实例，支持链式调用
    /// 示例:
    /// ```swift
    /// stackView.dd.addArrangedSubviews([view1, view2])
    /// ```
    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> Self {
        self.base.dd_addArrangedSubviews(views)
        return self
    }

    /// 删除堆栈视图中的所有排列子视图
    ///
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.removeAllArrangedSubviews()
    /// ```
    @discardableResult
    func removeAllArrangedSubviews() -> Self {
        self.base.dd_removeAllArrangedSubviews()
        return self
    }

    /// 添加子视图到堆栈中
    /// - Parameter view: 要添加的子视图
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.add(view1)
    /// ```
    @discardableResult
    func add(_ view: UIView) -> Self {
        self.base.dd_add(view)
        return self
    }

    /// 从堆栈中移除子视图
    /// - Parameter view: 要移除的子视图
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd.remove(view1)
    /// ```
    @discardableResult
    func remove(_ view: UIView) -> Self {
        self.base.dd_remove(view)
        return self
    }
}
