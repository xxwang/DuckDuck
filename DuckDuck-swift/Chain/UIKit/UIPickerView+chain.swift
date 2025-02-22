import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UIPickerView {
    /// 设置代理
    /// - Parameter delegate: 代理对象，用于处理 `UIPickerView` 的数据和事件
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// pickerView.dd.delegate(self)
    /// ```
    @discardableResult
    func delegate(_ delegate: UIPickerViewDelegate) -> Self {
        self.base.delegate = delegate
        return self
    }

    /// 设置数据源
    /// - Parameter dataSource: 数据源对象，用于提供 `UIPickerView` 的数据
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// pickerView.dd.dataSource(self)
    /// ```
    @discardableResult
    func dataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        self.base.dataSource = dataSource
        return self
    }
}
