import UIKit

// MARK: - Creatable
public extension UIPickerView {
    /// 纯净的创建方法
    static func create<T: UIPickerView>(_ aClass: T.Type = UIPickerView.self) -> T {
        let pickerView = UIPickerView()
        return pickerView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIPickerView>(_ aClass: T.Type = UIPickerView.self) -> T {
        let pickerView: UIPickerView = self.create()
        return pickerView as! T
    }
}

// MARK: - UIPickerView 扩展方法
public extension UIPickerView {
    /// 设置代理
    /// - Parameter delegate: 代理对象，用于处理 `UIPickerView` 的数据和事件
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// pickerView.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: UIPickerViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置数据源
    /// - Parameter dataSource: 数据源对象，用于提供 `UIPickerView` 的数据
    /// - Returns: `Self` 返回自身，支持链式调用
    ///
    /// 示例:
    /// ```swift
    /// pickerView.dd_dataSource(self)
    /// ```
    @discardableResult
    func dd_dataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
}
