import Foundation

// MARK: - 构造方法扩展
public extension RangeReplaceableCollection {
    /// 使用表达式结果创建一个指定大小的集合
    ///
    /// - Example:
    /// ```swift
    /// let values = Array(expression: "Value", count: 3)
    /// print(values) // 输出: ["Value", "Value", "Value"]
    /// ```
    /// - Parameters:
    ///   - expression: 返回集合元素的自动闭包
    ///   - count: 集合元素的个数
    init(expression: @autoclosure () throws -> Element, count: Int) rethrows {
        self.init()
        guard count > 0 else { return }
        self.reserveCapacity(count)
        while self.count < count {
            try self.append(expression())
        }
    }
}

// MARK: - 下标扩展
public extension RangeReplaceableCollection {
    /// 访问集合指定位置的元素
    ///
    /// - Example:
    /// ```swift
    /// var array = [10, 20, 30]
    /// array[1] = 25
    /// print(array) // 输出: [10, 25, 30]
    /// ```
    /// - Parameter offset: 元素的位置偏移
    /// - Returns: 指定位置的元素
    subscript(offset: Int) -> Element {
        get {
            precondition(offset >= 0 && offset < count, "Index out of bounds")
            return self[index(startIndex, offsetBy: offset)]
        }
        set {
            precondition(offset >= 0 && offset < count, "Index out of bounds")
            let offsetIndex = index(startIndex, offsetBy: offset)
            self.replaceSubrange(offsetIndex ..< index(after: offsetIndex), with: [newValue])
        }
    }

    /// 访问集合指定范围的元素
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2, 3, 4]
    /// array[1..<3] = [9, 9]
    /// print(array) // 输出: [1, 9, 9, 4]
    /// ```
    /// - Parameter range: 元素的范围
    /// - Returns: 结果序列
    subscript<R>(range: R) -> SubSequence where R: RangeExpression, R.Bound == Int {
        get {
            let indexRange = range.relative(to: 0 ..< count)
            return self[index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound)]
        }
        set {
            let indexRange = range.relative(to: 0 ..< count)
            self.replaceSubrange(
                index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound),
                with: newValue
            )
        }
    }
}

// MARK: - 方法扩展
public extension RangeReplaceableCollection {
    /// 返回一个按照指定位置旋转的集合
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4]
    /// let rotated = array.dd_rotated(by: 1)
    /// print(rotated) // 输出: [4, 1, 2, 3]
    /// ```
    /// - Parameter places: 旋转的位置数，负值表示逆向旋转
    func dd_rotated(by places: Int) -> Self {
        var copy = self
        copy.dd_rotate(by: places)
        return copy
    }

    /// 按照指定位置旋转集合
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2, 3, 4]
    /// array.dd_rotate(by: -1)
    /// print(array) // 输出: [2, 3, 4, 1]
    /// ```
    /// - Parameter places: 旋转的位置数，负值表示逆向旋转
    @discardableResult
    mutating func dd_rotate(by places: Int) -> Self {
        guard count > 0, places != 0 else { return self }
        let shift = (places % count + count) % count
        self = Self(self[shift...] + self[..<shift])
        return self
    }

    /// 删除第一个满足条件的元素
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2, 3, 4]
    /// array.dd_removeFirst { $0 % 2 == 0 }
    /// print(array) // 输出: [1, 3, 4]
    /// ```
    /// - Parameter condition: 删除条件
    /// - Returns: 被删除的元素
    @discardableResult
    mutating func dd_removeFirst(where condition: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: condition) else { return nil }
        return remove(at: index)
    }

    /// 删除集合中的重复元素
    ///
    /// - Example:
    /// ```swift
    /// var array = ["a", "b", "a", "c"]
    /// array.dd_removeDuplicates { $0 }
    /// print(array) // 输出: ["a", "b", "c"]
    /// ```
    /// - Parameter keyPath: 用于比较的键路径
    mutating func dd_removeDuplicates<T: Hashable>(keyPath: KeyPath<Element, T>) {
        var seen = Set<T>()
        removeAll { !seen.insert($0[keyPath: keyPath]).inserted }
    }

    /// 从集合中随机删除一个元素
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2, 3, 4]
    /// let removed = array.dd_removeRandomElement()
    /// print(array) // 输出: [1, 2, 4] 或其他结果
    /// print(removed) // 输出: 3 或其他被删除的元素
    /// ```
    /// - Returns: 被删除的元素（如果集合为空，则返回 `nil`）
    @discardableResult
    mutating func dd_removeRandomElement() -> Element? {
        guard let randomIndex = indices.randomElement() else { return nil }
        return remove(at: randomIndex)
    }

    /// 保留集合中从头开始符合条件的连续元素
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2, 3, 4, 5]
    /// array.dd_keep(while: { $0 < 3 })
    /// print(array) // 输出: [1, 2]
    /// ```
    /// - Parameter condition: 判断条件
    /// - Returns: 结果集合（保留的元素组成）
    @discardableResult
    mutating func dd_keep(while condition: (Element) throws -> Bool) rethrows -> Self {
        if let firstNonMatchingIndex = try firstIndex(where: { try !condition($0) }) {
            removeSubrange(firstNonMatchingIndex...)
        }
        return self
    }

    /// 获取从头开始符合条件的连续元素
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// let taken = array.dd_take(while: { $0 < 3 })
    /// print(taken) // 输出: [1, 2]
    /// ```
    /// - Parameter condition: 判断条件
    /// - Returns: 符合条件的结果集合
    func dd_take(while condition: (Element) throws -> Bool) rethrows -> Self {
        return try Self(prefix(while: condition))
    }

    /// 获取集合中从第一个不符合条件的元素开始的剩余元素
    ///
    /// - Example:
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// let skipped = array.dd_skip(while: { $0 < 3 })
    /// print(skipped) // 输出: [3, 4, 5]
    /// ```
    /// - Parameter condition: 判断条件
    /// - Returns: 结果集合（剩余的元素组成）
    func dd_skip(while condition: (Element) throws -> Bool) rethrows -> Self {
        guard let firstNonMatchingIndex = try firstIndex(where: { try !condition($0) }) else {
            return Self()
        }
        return Self(self[firstNonMatchingIndex...])
    }

    /// 在集合末尾添加非 `nil` 的元素
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2]
    /// array.dd_appendIfNonNil(3)
    /// array.dd_appendIfNonNil(nil)
    /// print(array) // 输出: [1, 2, 3]
    /// ```
    /// - Parameter newElement: 要添加的可选元素
    mutating func dd_appendIfNonNil(_ newElement: Element?) {
        guard let newElement else { return }
        self.append(newElement)
    }

    /// 在集合末尾添加非 `nil` 的序列
    ///
    /// - Example:
    /// ```swift
    /// var array = [1, 2]
    /// array.dd_appendIfNonNil(contentsOf: [3, 4])
    /// array.dd_appendIfNonNil(contentsOf: nil)
    /// print(array) // 输出: [1, 2, 3, 4]
    /// ```
    /// - Parameter newElements: 要添加的可选序列
    mutating func dd_appendIfNonNil(contentsOf newElements: (some Sequence<Element>)?) {
        guard let newElements else { return }
        self.append(contentsOf: newElements)
    }
}
