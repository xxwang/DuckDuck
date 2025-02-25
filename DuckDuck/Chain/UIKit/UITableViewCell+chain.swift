import UIKit

// MARK: - 链式语法
public extension DDExtension where Base: UITableViewCell {
    /// 设置 `UITableViewCell` 的选中样式
    /// - Parameter style: 样式，选择一种选中样式
    /// - Returns: `Self`，支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// cell.dd.selectionStyle(.none)
    /// ```
    @discardableResult
    func selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.base.selectionStyle = style
        return self
    }
}
