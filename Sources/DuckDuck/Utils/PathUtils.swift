//
//  PathUtils.swift
//
//
//  Created by xxwang on 2023/5/27.
//

import UIKit

public class PathUtils {
    public static let shared = PathUtils()
    private init() {}
}

// MARK: - Path
public extension PathUtils {
    /// `iCloud`目录的完整路径
    /// - Returns: `String`
    static func supportPath() -> String {
        NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    }

    /// `iCloud`目录URL
    /// - Returns: `URL`
    static func supportURL() -> URL {
        URL(fileURLWithPath: supportPath(), isDirectory: true)
    }

    /// `Home`目录的完整路径
    /// - Returns: `String`
    static func homePath() -> String {
        NSHomeDirectory()
    }

    /// `Home`目录的完整URL
    /// - Returns: `URL`
    static func homeURL() -> URL {
        URL(fileURLWithPath: homePath(), isDirectory: true)
    }

    /// `Documnets`目录的完整路径
    /// - Returns: `String`
    static func documnetsPath() -> String {
        NSHomeDirectory() + "/Documents"
    }

    /// `Documnets`目录的完整URL
    /// - Returns: `URL`
    static func documnetsURL() -> URL {
        URL(fileURLWithPath: documnetsPath(), isDirectory: true)
    }

    /// `Library`目录的完整路径名
    /// - Returns: `String`
    static func libraryPath() -> String {
        NSHomeDirectory() + "/Library"
    }

    /// `Library`目录的完整URL
    /// - Returns: `URL`
    static func libraryURL() -> URL {
        URL(fileURLWithPath: libraryPath(), isDirectory: true)
    }

    /// `Caches`目录的完整路径
    /// - Returns: `String`
    static func cachesPath() -> String {
        NSHomeDirectory() + "/Library/Caches"
    }

    /// `Caches`目录的完整URL
    /// - Returns: `URL`
    static func cachesURL() -> URL {
        URL(fileURLWithPath: cachesPath(), isDirectory: true)
    }

    /// `Preferences`目录的完整路径
    /// - Returns: `String`
    static func preferencesPath() -> String {
        NSHomeDirectory() + "/Library/Preferences"
    }

    /// `Preferences`目录的完整URL
    /// - Returns: `URL`
    static func preferencesURL() -> URL {
        URL(fileURLWithPath: preferencesPath(), isDirectory: true)
    }

    /// `tmp`目录的完整路径
    /// - Returns: `String`
    static func tmpPath() -> String {
        NSHomeDirectory() + "/tmp"
    }

    /// `tmp`目录的完整URL
    /// - Returns: `URL`
    static func tmpURL() -> URL {
        URL(fileURLWithPath: tmpPath(), isDirectory: true)
    }
}

// MARK: - 路径操作
public extension PathUtils {
    /// 在`Support`后面追回路径(目录/文件地址),备份在 iCloud`
    /// - Parameter path: 要追回的路径
    /// - Returns: 完整路径
    static func supportAppend(_ path: String) -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(path)"
    }

    /// `Support` 追加后的`目录／文件地址` `备份在 iCloud`
    static func supportAppend(_ path: String) -> URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        createDirs(url.absoluteString)
        return url.dd_appendingPathComponent(path)
    }

    /// 在`Documents`后面追加`目录／文件地址`
    /// - Parameter path: 要追回的路径
    /// - Returns: 完整路径
    static func documentAppend(_ path: String) -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(path)"
    }

    /// `Documents` 追加后的`目录／文件地址`
    static func documentAppend(_ path: String) -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        createDirs(url.absoluteString)
        return url.dd_appendingPathComponent(path)
    }

    /// `Cachees` 追加后的`目录／文件地址`
    /// - Parameter path: 要追回的路径
    /// - Returns: 完整路径
    static func cacheAppend(_ path: String) -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(path)"
    }

    /// `Cachees` 追加后的`目录／文件地址`
    static func cacheAppend(_ path: String) -> URL {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        createDirs(url.absoluteString)
        return url.dd_appendingPathComponent(path)
    }

    /// `tmp` 追加后的`目录／文件地址`
    static func tempAppend(_ path: String) -> String {
        let directory = NSTemporaryDirectory()
        createDirs(directory)
        return directory + "/\(path)"
    }
}

public extension PathUtils {
    /// 创建目录
    /// 如 `cache/`；以`/`结束代表是`目录`
    static func createDirs(_ path: String) {
        let path = path.contains(NSHomeDirectory()) ? path : "\(NSHomeDirectory())/\(self)"
        let dirs = path.components(separatedBy: "/")
        let dir = dirs[0 ..< dirs.count - 1].joined(separator: "/")
        if !FileManager.default.fileExists(atPath: dir) {
            do {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
}
