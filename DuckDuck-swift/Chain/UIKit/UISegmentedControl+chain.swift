import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UISegmentedControl {
    /// 设置选中的分段
    /// - Parameter selectedSegmentIndex: 选中的分段索引
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd.selectSegment(at: 1)
    /// ```
    @discardableResult
    func selectSegment(at selectedSegmentIndex: Int) -> Self {
        self.base.selectedSegmentIndex = selectedSegmentIndex
        return self
    }

    /// 设置控件的背景图片
    /// - Parameters:
    ///   - image: 背景图片
    ///   - state: 控件状态（例如 `normal`, `highlighted`）
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd.setBackgroundImage(image, for: .normal)
    /// ```
    @discardableResult
    func setBackgroundImage(_ image: UIImage, for state: UIControl.State) -> Self {
        self.base.setBackgroundImage(image, for: state, barMetrics: .default)
        return self
    }

    /// 设置控件是否为瞬时的
    /// - Parameter isMomentary: 是否为瞬时的
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd.isMomentary(true)
    /// ```
    @discardableResult
    func isMomentary(_ isMomentary: Bool) -> Self {
        self.base.isMomentary = isMomentary
        return self
    }

    /// 设置控件是否自动根据内容调整分段宽度
    /// - Parameter isAdjusted: 是否调整
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd.apportionsSegmentWidthsByContent(true)
    /// ```
    @discardableResult
    func apportionsSegmentWidthsByContent(_ isAdjusted: Bool) -> Self {
        self.base.apportionsSegmentWidthsByContent = isAdjusted
        return self
    }

    /// 设置某个分段的宽度
    /// - Parameters:
    ///   - width: 宽度
    ///   - index: 分段索引
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// segmentedControl.dd.setWidth(100, forSegmentAt: 0)
    /// ```
    @discardableResult
    func setWidth(_ width: CGFloat, forSegmentAt index: Int) -> Self {
        self.base.setWidth(width, forSegmentAt: index)
        return self
    }
}
