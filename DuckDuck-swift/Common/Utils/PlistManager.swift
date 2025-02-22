import Foundation

/// `PlistManager` 提供 `.plist` 文件的解析、保存和验证功能。
///
/// 该类包括解析 `.plist` 文件为字典或数组、将数据保存到 `.plist` 文件、以及验证 `.plist` 数据是否符合预期格式等方法。
public class PlistManager {
    /// 单例实例
    ///
    /// 使用单例模式来确保在整个应用中只有一个 `PlistManager` 实例，并且提供统一的入口访问。
    public static let shared = PlistManager()

    /// 私有初始化方法，防止外部直接初始化
    private init() {}
}

// MARK: - `.plist` 解析
public extension PlistManager {
    /// 根据 `.plist` 文件名称解析数据
    /// - Parameter plistFileName: `.plist` 文件名称
    /// - Returns: 解析后的数据，可能是字典、数组等
    ///
    /// 通过文件名获取 `.plist` 文件路径，并将文件内容解析为字典或数组。
    /// 如果解析成功，返回解析后的数据，否则返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// if let parsedData = PlistManager.shared.parse(fromPlistFileNamed: "Config.plist") {
    ///     print(parsedData)  // 输出解析后的数据
    /// }
    /// ```
    func parse(fromPlistFileNamed plistFileName: String?) -> Any? {
        guard let plistFileName else { return nil }
        guard let plistPath = Bundle.dd_filePath(for: plistFileName) else { return nil }

        return parse(fromPlistAtPath: plistPath)
    }

    /// 根据 `.plist` 文件路径解析数据
    /// - Parameter plistFilePath: `.plist` 文件路径
    /// - Returns: 解析后的数据，可能是字典、数组等
    ///
    /// 根据文件路径加载 `.plist` 数据并解析成字典或数组。若解析失败，则记录错误并返回 `nil`。
    ///
    /// - Example:
    /// ```swift
    /// if let parsedData = PlistManager.shared.parse(fromPlistAtPath: "/path/to/file.plist") {
    ///     print(parsedData)  // 输出解析后的数据
    /// }
    /// ```
    func parse(fromPlistAtPath plistFilePath: String?) -> Any? {
        guard let plistFilePath else { return nil }
        guard let plistData = FileManager.default.contents(atPath: plistFilePath) else { return nil }

        var format = PropertyListSerialization.PropertyListFormat.xml
        do {
            return try PropertyListSerialization.propertyList(
                from: plistData,
                options: .mutableContainersAndLeaves,
                format: &format
            )
        } catch {
            Logger.fail("解析 `.plist` 文件失败: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - `.plist` 文件保存
public extension PlistManager {
    /// 将数据保存到指定的 `.plist` 文件（通过文件名）
    /// - Parameters:
    ///   - data: 需要保存的数据（通常是字典或数组）
    ///   - plistFileName: `.plist` 文件名称
    /// - Returns: 是否保存成功
    ///
    /// 根据文件名将数据保存到 `.plist` 文件中。如果文件路径有效且数据保存成功，返回 `true`，否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let dataToSave: [String: Any] = ["key": "value"]
    /// let success = PlistManager.shared.save(data: dataToSave, toPlistFileNamed: "Settings.plist")
    /// print(success ? "保存成功" : "保存失败")
    /// ```
    func save(data: Any, toPlistFileNamed plistFileName: String?) -> Bool {
        guard let plistFileName else { return false }
        guard let plistFilePath = Bundle.dd_filePath(for: plistFileName) else { return false }
        return self.save(data: data, toPlistAtPath: plistFilePath)
    }

    /// 将数据保存到指定的 `.plist` 文件（通过文件路径）
    /// - Parameters:
    ///   - data: 需要保存的数据（通常是字典或数组）
    ///   - plistFilePath: `.plist` 文件路径
    /// - Returns: 是否保存成功
    ///
    /// 根据文件路径将数据保存到 `.plist` 文件中。如果文件路径有效且数据保存成功，返回 `true`，否则返回 `false`。
    ///
    /// - Example:
    /// ```swift
    /// let dataToSave: [String: Any] = ["username": "JohnDoe"]
    /// let success = PlistManager.shared.save(data: dataToSave, toPlistAtPath: "/path/to/settings.plist")
    /// print(success ? "保存成功" : "保存失败")
    /// ```
    func save(data: Any, toPlistAtPath plistFilePath: String?) -> Bool {
        guard let plistFilePath else { return false }
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
            try plistData.write(to: URL(fileURLWithPath: plistFilePath))
            return true
        } catch {
            Logger.fail("保存 `.plist` 文件失败: \(error.localizedDescription)")
            return false
        }
    }
}

// MARK: - `.plist` 数据验证
public extension PlistManager {
    /// 验证 `.plist` 数据是否符合预期的格式
    /// - Parameter data: 需要验证的数据
    /// - Returns: 数据是否符合预期格式
    ///
    /// 检查 `.plist` 数据是否是有效的字典或数组，并且不为空。返回 `true` 表示数据符合预期格式，返回 `false` 表示数据无效。
    ///
    /// - Example:
    /// ```swift
    /// let data: [String: Any] = ["key": "value"]
    /// let isValid = PlistManager.shared.isValid(data)
    /// print(isValid ? "数据有效" : "数据无效")
    /// ```
    func isValid(_ data: Any) -> Bool {
        if let dictionary = data as? [String: Any] {
            // 验证字典数据是否符合预期
            return !dictionary.isEmpty
        } else if let array = data as? [Any] {
            // 验证数组数据是否符合预期
            return !array.isEmpty
        }
        return false
    }
}
