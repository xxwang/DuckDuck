import UIKit

// MARK: - Creatable
public extension UIStackView {
    /// 纯净的创建方法
    static func create<T: UIStackView>(_ aClass: T.Type = UIStackView.self) -> T {
        let stackView = UIStackView()
        return stackView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIStackView>(_ aClass: T.Type = UIStackView.self) -> T {
        let stackView: UIStackView = self.create()
        return stackView as! T
    }
}

// MARK: - UIStackView 初始化
public extension UIStackView {
    /// 使用`UIView`数组和其他参数初始化`UIStackView`
    ///
    ///     let stackView = UIStackView(views: [UIView(), UIView()], axis: .vertical)
    ///
    /// - Parameters:
    ///   - views: 要添加到堆栈中的`UIView`数组
    ///   - axis: 列表视图的排列轴。默认值是`.horizontal`
    ///   - spacing: 堆栈视图内排列视图的相邻边之间的间距（默认值：`0.0`）
    ///   - distribution: 排列视图沿堆栈视图轴的分布方式（默认值：`.fill`）
    ///   - alignment: 垂直于堆栈视图轴线的对齐方式，影响子视图的布局（默认值：`.fill`）
    convenience init(
        views: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0.0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
}

// MARK: - UIStackView 方法扩展
public extension UIStackView {
    /// 交换堆栈视图中的两个排列子视图（无动画）
    ///
    /// - Parameters:
    ///   - view1: 要交换的第一个视图
    ///   - view2: 要交换的第二个视图
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_switchViews(view1, view2)
    /// ```
    func dd_switchViews(_ view1: UIView, _ view2: UIView) {
        guard let view1Index = arrangedSubviews.firstIndex(of: view1),
              let view2Index = arrangedSubviews.firstIndex(of: view2) else { return }

        // 移除并重新插入视图以交换顺序
        removeArrangedSubview(view1)
        insertArrangedSubview(view1, at: view2Index)

        removeArrangedSubview(view2)
        insertArrangedSubview(view2, at: view1Index)
    }

    /// 交换堆栈视图中的两个排列子视图（可设置动画）
    ///
    /// - Parameters:
    ///   - view1: 要交换的第一个视图
    ///   - view2: 要交换的第二个视图
    ///   - animated: 是否启用动画，默认为 `false`
    ///   - duration: 动画持续时间（秒），默认为 `0.25`
    ///   - delay: 动画延迟时间（秒），默认为 `0`
    ///   - options: 动画选项，默认为 `.curveLinear`
    ///   - completion: 动画完成后的回调（默认为 `nil`）
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_swapViews(view1, view2, animated: true, duration: 0.5)
    /// ```
    func dd_swapViews(_ view1: UIView, _ view2: UIView,
                      animated: Bool = false,
                      duration: TimeInterval = 0.25,
                      delay: TimeInterval = 0,
                      options: UIView.AnimationOptions = .curveLinear,
                      completion: ((Bool) -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                self.dd_switchViews(view1, view2)
                self.layoutIfNeeded()
            }, completion: completion)
        } else {
            self.dd_switchViews(view1, view2)
        }
    }
}

// 扩展以支持链式调用
extension UIStackView {
    /// 创建水平布局`UIStackView`
    /// - Parameters:
    ///   - arrangedSubviews: 要添加到堆栈中的`UIView`数组
    ///   - spacing: 堆栈视图内排列视图的相邻边之间的间距（默认值：`0.0`）
    /// - Returns: `UIStackView`
    @discardableResult
    static func horizontal(arrangedSubviews: [UIView], spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView(views: arrangedSubviews, axis: .horizontal, spacing: spacing)
        return stackView
    }

    /// 创建垂直布局`UIStackView`
    /// - Parameters:
    ///   - arrangedSubviews: 要添加到堆栈中的`UIView`数组
    ///   - spacing: 堆栈视图内排列视图的相邻边之间的间距（默认值：`0.0`）
    /// - Returns: `UIStackView`
    @discardableResult
    static func vertical(arrangedSubviews: [UIView], spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView(views: arrangedSubviews, axis: .vertical, spacing: spacing)
        return stackView
    }
}

// MARK: - 链式语法
public extension UIStackView {
    /// 设置子控件的布局方向（水平方向或垂直方向，即轴方向）
    /// - Parameter axis: 轴方向，`NSLayoutConstraint.Axis.horizontal` 或 `NSLayoutConstraint.Axis.vertical`
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_axis(.vertical)
    /// ```
    @discardableResult
    func dd_axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }

    /// 设置子视图在轴向上的分布方式
    /// - Parameter distribution: 分布方式
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_distribution(.fillEqually)
    /// ```
    @discardableResult
    func dd_distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    /// 设置对齐模式
    /// - Parameter alignment: 对齐模式
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_alignment(.center)
    /// ```
    @discardableResult
    func dd_alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置子控件之间的间距
    /// - Parameter spacing: 子控件间距
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_spacing(10.0)
    /// ```
    @discardableResult
    func dd_spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
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
    /// stackView.dd_setCustomSpacing(10, after: arrangedSubview)
    /// ```
    @discardableResult
    func dd_setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
        if #available(iOS 11.0, *) {
            self.setCustomSpacing(spacing, after: arrangedSubview)
        } else {
            // 对于低版本 iOS 手动创建间距视图
            let separatorView = UIView(frame: .zero)
            separatorView.translatesAutoresizingMaskIntoConstraints = false

            // 根据堆栈的方向设置间距
            switch axis {
            case .horizontal:
                separatorView.widthAnchor.constraint(equalToConstant: spacing).isActive = true
            case .vertical:
                separatorView.heightAnchor.constraint(equalToConstant: spacing).isActive = true
            default:
                print("未知的堆栈视图方向")
            }

            // 插入间距视图
            if let index = arrangedSubviews.firstIndex(of: arrangedSubview) {
                insertArrangedSubview(separatorView, at: index + 1)
            }
        }
        return self
    }

    /// 设置布局时是否参照基准线, 默认是 `false`（决定了垂直轴如果是文本的话，是否按照 `baseline` 来参与布局）
    /// - Parameter arrangement: 是否参照基线进行布局
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_isBaselineRelativeArrangement(true)
    /// ```
    @discardableResult
    func dd_isBaselineRelativeArrangement(_ arrangement: Bool) -> Self {
        self.isBaselineRelativeArrangement = arrangement
        return self
    }

    /// 设置布局时是否以控件的 `LayoutMargins` 为标准，默认为 `false`（以控件的 `bounds` 为标准）
    /// - Parameter arrangement: 是否以控件的 `LayoutMargins` 为标准
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_isLayoutMarginsRelativeArrangement(true)
    /// ```
    @discardableResult
    func dd_isLayoutMarginsRelativeArrangement(_ arrangement: Bool) -> Self {
        self.isLayoutMarginsRelativeArrangement = arrangement
        return self
    }

    /// 设置布局边距
    /// - Parameter margins: 设置堆栈视图的布局边距
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// stackView.dd_layoutMargins(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    /// ```
    @discardableResult
    func dd_layoutMargins(_ margins: UIEdgeInsets) -> Self {
        self.layoutMargins = margins
        return self
    }

    /// 设置堆栈视图是否保留父视图的布局边距
    /// - Parameter preserves: 是否保留父视图的布局边距
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例用法：
    /// ```swift
    /// stackView.dd_preservesSuperviewLayoutMargins(true)
    /// ```
    @discardableResult
    func dd_preservesSuperviewLayoutMargins(_ preserves: Bool) -> Self {
        self.preservesSuperviewLayoutMargins = preserves
        return self
    }

    /// 添加多个排列的子视图
    /// - Parameter items: 子视图数组
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_addArrangedSubviews(view1, view2, view3)
    /// ```
    @discardableResult
    func dd_addArrangedSubviews(_ items: UIView...) -> Self {
        if items.isEmpty {
            return self
        }

        for item in items.compactMap(\.self) {
            self.addArrangedSubview(item)
        }
        return self
    }

    /// 将多个视图添加到堆栈视图的末尾
    ///
    /// - Parameter views: 要添加的视图数组
    ///
    /// - Returns: 当前实例，支持链式调用
    /// 示例:
    /// ```swift
    /// stackView.dd_addArrangedSubviews([view1, view2])
    /// ```
    @discardableResult
    func dd_addArrangedSubviews(_ views: [UIView]) -> Self {
        for view in views {
            self.addArrangedSubview(view)
        }
        return self
    }

    /// 删除堆栈视图中的所有排列子视图
    ///
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_removeAllArrangedSubviews()
    /// ```
    @discardableResult
    func dd_removeAllArrangedSubviews() -> Self {
        for view in arrangedSubviews {
            self.removeArrangedSubview(view)
        }
        return self
    }

    /// 添加子视图到堆栈中
    /// - Parameter view: 要添加的子视图
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_add(view1)
    /// ```
    @discardableResult
    func dd_add(_ view: UIView) -> Self {
        self.addArrangedSubview(view)
        return self
    }

    /// 从堆栈中移除子视图
    /// - Parameter view: 要移除的子视图
    /// - Returns: 当前实例，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_remove(view1)
    /// ```
    @discardableResult
    func dd_remove(_ view: UIView) -> Self {
        self.removeArrangedSubview(view)
        view.removeFromSuperview()
        return self
    }
}
