import Foundation

public extension IndexPath {
    /// 用字符串描述 `IndexPath`
    /// - Returns: 格式化后的 `IndexPath` 字符串描述
    /// - Example: `"[section: 1, row: 3]"`
    /// ```swift
    /// let indexPath1 = IndexPath(row: 3, section: 1)
    /// let result = indexPath1.dd_toString()  // 返回 [section: 1, row: 3]
    /// ```
    func dd_toString() -> String {
        return String(format: "[section: %d, row: %d]", self.section, self.row)
    }

    /// 检查 `IndexPath` 是否与另一个 `IndexPath` 相同
    /// - Parameter other: 另一个 `IndexPath` 用于比较
    /// - Returns: 如果两个 `IndexPath` 的 `section` 和 `row` 都相同，返回 `true`，否则返回 `false`
    /// - Example:
    /// ```swift
    /// let indexPath1 = IndexPath(row: 3, section: 1)
    /// let indexPath2 = IndexPath(row: 3, section: 1)
    /// let result = indexPath1.dd_isSame(as: indexPath2)  // 返回 true
    /// ```
    func dd_isSame(as other: IndexPath) -> Bool {
        return self.section == other.section && self.row == other.row
    }

    /// 判断 `IndexPath` 是否是第一组第一个单元
    /// - Returns: 如果 `row` 等于 0，返回 `true`，否则返回 `false`
    /// - Example:
    /// ```swift
    /// let indexPath = IndexPath(row: 0, section: 1)
    /// let isFirst = indexPath.dd_isFirst()  // 返回 true
    /// ```
    func dd_isFirst() -> Bool {
        return self.section == 0 && self.row == 0
    }

    /// 判断 `IndexPath` 是否是最后一组最后一个单元
    ///
    /// - Example:
    /// ```swift
    /// let indexPath = IndexPath(row: 5, section: 1)
    /// let isLast = indexPath.dd_isLast(totalSectionCount: 2, totalRowCount: 6)  // 返回 true
    /// ```
    /// - Parameters:
    ///   - totalSectionCount: 总组数
    ///   - totalRowCount: 最后一组的总单元
    /// - Returns: 是否是最后一组最后一个单元
    func dd_isLast(totalSectionCount: Int, totalRowCount: Int) -> Bool {
        return self.section == totalSectionCount - 1 && self.row == totalRowCount - 1
    }

    /// 判断 `IndexPath` 是否为第一组
    /// - Returns: `true` 如果是第一组，`false` 否则
    /// - Example:
    ///   ```swift
    ///   let indexPath = IndexPath(row: 0, section: 0)
    ///   let isFirstSection = indexPath.dd_isFirstSection()  // true (第一组)
    ///   ```
    func dd_isFirstSection() -> Bool {
        return self.section == 0
    }

    /// 判断 `IndexPath` 是否为最后一组
    /// - Parameter totalSectionCount: 总section数
    /// - Returns: `true` 如果是最后一列，`false` 否则
    /// - Example:
    ///   ```swift
    ///   let indexPath = IndexPath(row: 2, section: 4)
    ///   let totalSections = 5
    ///   let isLastSection = indexPath.dd_isLastSection(totalSectionCount: totalSections)  // true (最后一列)
    ///   ```
    func dd_isLastSection(totalSectionCount: Int) -> Bool {
        return self.section == totalSectionCount - 1
    }

    /// 判断 `IndexPath` 是否是某个组的第一个单元
    /// - Returns: 如果 `row` 等于 0，返回 `true`，否则返回 `false`
    /// - Example:
    /// ```swift
    /// let indexPath = IndexPath(row: 0, section: 1)
    /// let isFirstColumn = indexPath.dd_isFirstRowInSection()  // 返回 true
    /// ```
    func dd_isFirstRowInSection() -> Bool {
        return self.row == 0
    }

    /// 判断 `IndexPath` 是否是某个组的最后一个单元
    /// - Returns: 如果 `row` 等于最大单元，返回 `true`，否则返回 `false`
    /// - Parameter totalRowCount: 最大单元数
    /// - Example:
    /// ```swift
    /// let indexPath = IndexPath(row: 3, section: 1)
    /// let isLastColumn = indexPath.dd_isLastRowInSection(maxColumn: 4)  // 返回 true
    /// ```
    func dd_isLastRowInSection(totalRowCount: Int) -> Bool {
        return self.row == totalRowCount - 1
    }

    /// 获取 `IndexPath` 对应的二维数组位置（根据行和列的索引）
    /// - Returns: 返回一个 `(section, row)` 元组
    /// - Example:
    /// ```swift
    /// let indexPath = IndexPath(row: 2, section: 1)
    /// let position = indexPath.dd_position()  // 返回 (section: 1, row: 2)
    /// ```
    func dd_position() -> (section: Int, row: Int) {
        return (self.section, self.row)
    }
}
