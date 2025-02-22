import Foundation

// MARK: - 集合扩展
public extension Collection {
    /// 获取集合的索引范围
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4]
    /// print(array.dd_range()) // 输出: 0..<4
    /// ```
    /// - Returns: 索引范围
    func dd_range() -> Range<Self.Index> {
        startIndex ..< endIndex
    }

    /// 从集合中安全地读取元素
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.dd_safe(at: 1))  // 输出: Optional(2)
    /// print(array.dd_safe(at: 10)) // 输出: nil
    /// ```
    /// - Parameter index: 索引
    /// - Returns: 对应的元素；若索引越界，则返回 `nil`
    func dd_safe(at index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// 按指定大小分组集合
    ///
    /// - Example:
    /// ```swift
    /// let array = [0, 2, 4, 7, 6]
    /// print(array.dd_grouped(by: 2)) // 输出: [[0, 2], [4, 7], [6]]
    /// ```
    /// - Parameter size: 每组的大小
    /// - Returns: 二维数组；若大小无效或集合为空，返回 `nil`
    func dd_grouped(by size: Int) -> [[Element]]? {
        guard size > 0, !isEmpty else { return nil }
        var result: [[Element]] = []
        var start = startIndex
        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            result.append(Array(self[start ..< end]))
            start = end
        }
        return result
    }

    /// 查找满足条件的所有索引
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 7, 1, 2, 4, 1, 8]
    /// print(array.dd_indices(where: { $0 == 1 })) // 输出: [0, 2, 5]
    /// ```
    /// - Parameter condition: 判断条件的闭包
    /// - Returns: 符合条件的索引数组；若无匹配项，返回 `nil`
    func dd_indices(where condition: (Element) throws -> Bool) rethrows -> [Index]? {
        let result = try indices.filter { try condition(self[$0]) }
        return result.isEmpty ? nil : result
    }

    /// 异步并行遍历集合的所有元素
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// await array.dd_parallelForEach { item in
    ///     print(item)
    /// }
    /// ```
    /// - Parameter operation: 作用于每个元素的异步闭包
    func dd_parallelForEach(_ operation: @escaping @Sendable (Element) async -> Void) async {
        for element in self {
            await operation(element)
        }
    }

    /// 按指定大小对集合切片并执行异步操作
    ///
    /// - Example:
    /// ```swift
    /// let array = [0, 2, 4, 7, 6]
    /// await array.dd_parallelSlice(by: 2) { slice in
    ///     print(slice)
    /// }
    /// ```
    /// - Parameters:
    ///   - size: 切片大小
    ///   - operation: 作用于切片的异步闭包
    func dd_parallelSlice(by size: Int, operation: @escaping @Sendable ([Element]) async -> Void) async {
        var start = startIndex
        while let end = index(start, offsetBy: size, limitedBy: endIndex) {
            await operation(Array(self[start ..< end]))
            start = end
        }
    }
}

// MARK: - Equatable 元素相关
public extension Collection where Element: Equatable {
    /// 查找所有与指定元素相同的索引
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 2, 3, 4, 2, 5]
    /// print(array.dd_indices(of: 2)) // 输出: [1, 2, 5]
    /// ```
    /// - Parameter item: 指定元素
    /// - Returns: 符合条件的索引数组
    func dd_indices(of item: Element) -> [Index] {
        self.dd_indices { $0 == item } ?? []
    }
}

// MARK: - 数值相关
public extension Collection where Element: BinaryInteger {
    /// 计算整数数组的平均值
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 4, 3, 4]
    /// print(array.dd_average()) // 输出: 2.8
    /// ```
    /// - Returns: 平均值
    func dd_average() -> Double {
        guard !isEmpty else { return 0.0 }
        return Double(reduce(0, +)) / Double(count)
    }
}

public extension Collection where Element: FloatingPoint {
    /// 计算浮点数数组的平均值
    ///
    /// - Example:
    /// ```swift
    /// let array = [1.2, 2.3, 4.5, 3.4, 4.5]
    /// print(array.dd_average()) // 输出: 3.18
    /// ```
    /// - Returns: 平均值
    func dd_average() -> Element {
        guard !isEmpty else { return .zero }
        return reduce(.zero, +) / Element(count)
    }
}

// MARK: - JSON
public extension Collection where Element: Encodable {
    /// 将集合类型转换为 JSON 字符串
    ///
    /// - Example:
    /// ```swift
    /// let array = ["a", "b", "c"]
    /// print(array.dd_toJSONString(prettify: true)!)
    /// // 输出:
    /// // [
    /// //   "a",
    /// //   "b",
    /// //   "c"
    /// // ]
    /// ```
    /// - Parameter prettify: 是否美化 JSON 输出（默认 `false`）
    /// - Returns: 转换后的 JSON 字符串，若失败返回 `nil`
    func dd_toJSONString(prettify: Bool = false) -> String? {
        guard let data = try? dd_toJSONData(prettify: prettify) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// 将集合类型转换为 JSON 数据
    ///
    /// - Example:
    /// ```swift
    /// let array = ["a", "b", "c"]
    /// let jsonData = array.dd_toJSONData(prettify: true)!
    /// print(String(data: jsonData, encoding: .utf8)!)
    /// ```
    /// - Parameter prettify: 是否美化 JSON 输出（默认 `false`）
    /// - Returns: 转换后的 JSON 数据，若失败返回 `nil`
    func dd_toJSONData(prettify: Bool = false) throws -> Data {
        let encoder = JSONEncoder()
        if prettify {
            encoder.outputFormatting = .prettyPrinted
        }
        // 将集合转换为数组来进行编码
        return try encoder.encode(Array(self))
    }
}
