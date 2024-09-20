//
//  UIStackView+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import UIKit

// MARK: - 构造方法
public extension UIStackView {
    /// 使用`UIView`数组和参数初始化`UIStackView`
    ///
    ///     let stackView = UIStackView(arrangedSubviews:[UIView(), UIView()], axis:.vertical)
    ///
    /// - Parameters:
    ///   - arrangedSubviews:要添加到堆栈中的`UIView`
    ///   - axis:排列视图的轴线
    ///   - spacing:堆栈视图的排列视图的相邻边之间的距离(默认:`0.0`)
    ///   - alignment:垂直于堆栈视图的轴排列的子视图的对齐方式(默认:`.fill`)
    ///   - distribution:排列视图沿堆栈视图轴的分布(默认值:`.fill`)
    convenience init(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

// MARK: - 方法
public extension UIStackView {
    /// 添加自定义间距
    /// - Parameters:
    ///   - spacing:间距
    ///   - arrangedSubview:要添加到谁的后面
    func dd_addSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        if #available(iOS 11.0, *) {
            self.setCustomSpacing(spacing, after: arrangedSubview)
        } else {
            let separatorView = UIView(frame: .zero)
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            switch axis {
            case .horizontal:
                separatorView.widthAnchor.constraint(equalToConstant: spacing).isActive = true
            case .vertical:
                separatorView.heightAnchor.constraint(equalToConstant: spacing).isActive = true
            default:
                print("为未知")
            }
            if let index = arrangedSubviews.firstIndex(of: arrangedSubview) {
                insertArrangedSubview(separatorView, at: index + 1)
            }
        }
    }

    /// 将视图数组添加到`addArrangedSubviews`数组的末尾
    /// - Parameter views:`UIView`数组
    func dd_addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    /// 删除堆栈排列子视图数组中的所有视图
    func dd_removeArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }

    /// 交换排列子视图中的两个视图(无动画)
    /// - Parameters:
    ///   - view1: 要交换的第一个视图
    ///   - view2: 要交换的第二个视图
    func dd_switch(_ view1: UIView, _ view2: UIView) {
        guard let view1Index = arrangedSubviews.firstIndex(of: view1),
              let view2Index = arrangedSubviews.firstIndex(of: view2) else { return }
        removeArrangedSubview(view1)
        insertArrangedSubview(view1, at: view2Index)

        removeArrangedSubview(view2)
        insertArrangedSubview(view2, at: view1Index)
    }

    /// 交换排列子视图中的两个视图(可设置动画)
    /// - Parameters:
    ///   - view1:要交换的第一个视图
    ///   - view2:要交换的第二个视图
    ///   - animated:设置为`true`以设置交换动画(默认值为`true`)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - delay:以秒为单位的动画延迟(默认值为1秒)
    ///   - options:动画选项(默认为`AnimationOptions.curveLinear`)
    ///   - completion:可选的完成回调,用于在动画完成时运行(默认为`nil`)
    func dd_swap(_ view1: UIView, _ view2: UIView,
                 animated: Bool = false,
                 duration: TimeInterval = 0.25,
                 delay: TimeInterval = 0,
                 options: UIView.AnimationOptions = .curveLinear,
                 completion: ((Bool) -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                self.dd_switch(view1, view2)
                self.layoutIfNeeded()
            }, completion: completion)
        } else {
            self.dd_switch(view1, view2)
        }
    }
}

// MARK: - 链式语法
public extension UIStackView {
    /// 布局时是否参照基准线,默认是 `false`(决定了垂直轴如果是文本的话,是否按照 `baseline` 来参与布局)
    /// - Parameter arrangement:是否参照基线
    /// - Returns:`Self`
    @discardableResult
    func dd_isBaselineRelativeArrangement(_ arrangement: Bool) -> Self {
        isBaselineRelativeArrangement = arrangement
        return self
    }

    /// 设置布局时是否以控件的`LayoutMargins`为标准,默认为 `false`,是以控件的`bounds`为标准
    /// - Parameter arrangement:是否以控件的`LayoutMargins`为标准
    /// - Returns:`Self`
    @discardableResult
    func dd_isLayoutMarginsRelativeArrangement(_ arrangement: Bool) -> Self {
        isLayoutMarginsRelativeArrangement = arrangement
        return self
    }

    /// 子控件布局方向(水平或者垂直),也就是轴方向
    /// - Parameter axis:轴方向
    /// - Returns:`Self`
    @discardableResult
    func dd_axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }

    /// 子视图在轴向上的分布方式
    /// - Parameter distribution:分布方式
    /// - Returns:`Self`
    @discardableResult
    func dd_distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    /// 对齐模式
    /// - Parameter alignment:对齐模式
    /// - Returns:`Self`
    @discardableResult
    func dd_alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置子控件间距
    /// - Parameter spacing:子控件间距
    /// - Returns:`Self`
    @discardableResult
    func dd_spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    /// 添加排列子视图
    /// - Parameter items:子视图
    /// - Returns:`Self`
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
}
