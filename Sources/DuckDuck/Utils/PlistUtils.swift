//
//  PlistUtils.swift
//
//
//  Created by xxwang on 2023/5/24.
//

import Foundation

public class PlistUtils {
    public static let shared = PlistUtils()
    private init() {}
}

public extension PlistUtils {
    /// 解析`.plist`文件`文件名称`
    /// - Parameter plistName: `.plist`文件名称
    /// - Returns: 解析结果
    func parse(plistName: String?) -> Any? {
        guard let plistName else { return nil }
        guard let plistPath = Bundle.dd_path(for: plistName) else { return nil }
        return parse(plistPath: plistPath)
    }

    /// 解析`.plist`文件`文件路径`
    /// - Parameter plistPath: 文件路径
    /// - Returns: 解析结果
    func parse(plistPath: String?) -> Any? {
        guard let plistPath else { return nil }
        guard let plistData = FileManager.default.contents(atPath: plistPath) else { return nil }

        var format = PropertyListSerialization.PropertyListFormat.xml
        return try? PropertyListSerialization.propertyList(
            from: plistData,
            options: .mutableContainersAndLeaves,
            format: &format
        )
    }
}
