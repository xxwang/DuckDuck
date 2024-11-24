//
//  UIStackView++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 24/11/2024.
//

import UIKit

// MARK: - UIStackView 初始化
public extension UIStackView {
    /// 使用`UIView`数组和其他参数初始化`UIStackView`
    ///
    ///     let stackView = UIStackView(views: [UIView(), UIView()], axis: .vertical)
    ///
    /// - 参数:
    ///   - views: 要添加到堆栈中的`UIView`数组
    ///   - axis: 列表视图的排列轴。默认值是`.horizontal`
    ///   - spacing: 堆栈视图内排列视图的相邻边之间的间距（默认值：`0.0`）
    ///   - alignment: 垂直于堆栈视图轴线的对齐方式，影响子视图的布局（默认值：`.fill`）
    ///   - distribution: 排列视图沿堆栈视图轴的分布方式（默认值：`.fill`）
    convenience init(
        views: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0.0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

// MARK: - UIStackView 方法扩展
public extension UIStackView {
    /// 在指定视图后添加自定义间距
    ///
    /// - Parameters:
    ///   - spacing: 间距的大小
    ///   - afterSubview: 要在其后添加间距的视图
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_addSpacing(10.0, afterSubview: someView)
    /// ```
    func dd_addSpacing(_ spacing: CGFloat, afterSubview: UIView) {
        if #available(iOS 11.0, *) {
            // iOS 11 及以上使用 setCustomSpacing 方法
            self.setCustomSpacing(spacing, after: afterSubview)
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
            if let index = arrangedSubviews.firstIndex(of: afterSubview) {
                insertArrangedSubview(separatorView, at: index + 1)
            }
        }
    }

    /// 将多个视图添加到堆栈视图的末尾
    ///
    /// - Parameter views: 要添加的视图数组
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_addArrangedSubviews([view1, view2])
    /// ```
    func dd_addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    /// 删除堆栈视图中的所有排列子视图
    ///
    /// 示例:
    /// ```swift
    /// stackView.dd_removeAllArrangedSubviews()
    /// ```
    func dd_removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }

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

// MARK: - 链式语法
public extension UIStackView {
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
        isBaselineRelativeArrangement = arrangement
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
        isLayoutMarginsRelativeArrangement = arrangement
        return self
    }

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

        items.compactMap { $0 }.forEach {
            addArrangedSubview($0)
        }
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
        }
        return self
    }
}
