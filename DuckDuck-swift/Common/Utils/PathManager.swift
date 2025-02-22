import Foundation

/// `PathManager` 提供路径和目录管理功能
///
/// 该类提供了一些常用的路径获取方法以及路径操作方法，包括获取常用系统目录（如 iCloud、Documents、Library 等），
/// 以及为指定目录生成完整路径，并确保目录存在。
public class PathManager {
    /// 单例实例
    ///
    /// 使用单例模式来确保应用程序中路径管理的唯一性，并且提供统一的入口访问。
    public static let shared = PathManager()

    /// 私有初始化方法，防止外部直接初始化
    private init() {}
}

// MARK: - 常用路径获取
public extension PathManager {
    /// 获取 `iCloud` 支持路径
    /// - Returns: 支持路径字符串
    ///
    /// 返回应用程序的 `iCloud` 支持目录路径，通常用于存储应用数据或文件。
    ///
    /// - Example:
    /// ```swift
    /// let supportPath = PathManager.shared.supportPath()
    /// print(supportPath)  // 输出 iCloud 支持路径
    /// ```
    static func supportPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    }

    /// 获取 `Home` 目录路径
    /// - Returns: `Home` 目录字符串
    ///
    /// 返回当前用户的主目录路径。
    ///
    /// - Example:
    /// ```swift
    /// let homePath = PathManager.shared.homePath()
    /// print(homePath)  // 输出 Home 目录路径
    /// ```
    static func homePath() -> String {
        return NSHomeDirectory()
    }

    /// 获取 `Documents` 目录路径
    /// - Returns: `Documents` 目录字符串
    ///
    /// 返回当前用户的 `Documents` 目录路径，通常用于存储用户文件。
    ///
    /// - Example:
    /// ```swift
    /// let documentsPath = PathManager.shared.documentsPath()
    /// print(documentsPath)  // 输出 Documents 目录路径
    /// ```
    static func documentsPath() -> String {
        return self.homePath() + "/Documents"
    }

    /// 获取 `Library` 目录路径
    /// - Returns: `Library` 目录字符串
    ///
    /// 返回当前用户的 `Library` 目录路径，通常用于存储应用程序相关的设置和数据。
    ///
    /// - Example:
    /// ```swift
    /// let libraryPath = PathManager.shared.libraryPath()
    /// print(libraryPath)  // 输出 Library 目录路径
    /// ```
    static func libraryPath() -> String {
        return self.homePath() + "/Library"
    }

    /// 获取 `Caches` 目录路径
    /// - Returns: `Caches` 目录字符串
    ///
    /// 返回当前用户的 `Caches` 目录路径，通常用于存储缓存文件。
    ///
    /// - Example:
    /// ```swift
    /// let cachesPath = PathManager.shared.cachesPath()
    /// print(cachesPath)  // 输出 Caches 目录路径
    /// ```
    static func cachesPath() -> String {
        return self.libraryPath() + "/Caches"
    }

    /// 获取 `tmp` 临时目录路径
    /// - Returns: `tmp` 目录字符串
    ///
    /// 返回当前用户的临时目录路径，通常用于存储临时文件。
    ///
    /// - Example:
    /// ```swift
    /// let tempPath = PathManager.shared.tempPath()
    /// print(tempPath)  // 输出临时目录路径
    /// ```
    static func tempPath() -> String {
        return NSTemporaryDirectory()
    }
}

// MARK: - 常用路径URL获取
public extension PathManager {
    /// 获取 `iCloud` 支持路径的 URL
    /// - Returns: 支持路径 URL
    ///
    /// 返回应用程序 `iCloud` 支持目录路径的 `URL`，可用于与文件操作 API 一起使用。
    ///
    /// - Example:
    /// ```swift
    /// let supportURL = PathManager.shared.supportURL()
    /// print(supportURL)  // 输出支持路径 URL
    /// ```
    static func supportURL() -> URL {
        return URL(fileURLWithPath: self.supportPath(), isDirectory: true)
    }

    /// 获取 `Home` 目录 URL
    /// - Returns: `Home` 目录 URL
    ///
    /// 返回当前用户主目录路径的 `URL`，可用于与文件操作 API 一起使用。
    ///
    /// - Example:
    /// ```swift
    /// let homeURL = PathManager.shared.homeURL()
    /// print(homeURL)  // 输出 Home 目录 URL
    /// ```
    static func homeURL() -> URL {
        return URL(fileURLWithPath: self.homePath(), isDirectory: true)
    }

    /// 获取 `Documents` 目录 URL
    /// - Returns: `Documents` 目录 URL
    ///
    /// 返回当前用户的 `Documents` 目录路径的 `URL`，可用于与文件操作 API 一起使用。
    ///
    /// - Example:
    /// ```swift
    /// let documentsURL = PathManager.shared.documentsURL()
    /// print(documentsURL)  // 输出 Documents 目录 URL
    /// ```
    static func documentsURL() -> URL {
        return URL(fileURLWithPath: self.documentsPath(), isDirectory: true)
    }

    /// 获取 `Library` 目录 URL
    /// - Returns: `Library` 目录 URL
    ///
    /// 返回当前用户的 `Library` 目录路径的 `URL`，可用于与文件操作 API 一起使用。
    ///
    /// - Example:
    /// ```swift
    /// let libraryURL = PathManager.shared.libraryURL()
    /// print(libraryURL)  // 输出 Library 目录 URL
    /// ```
    static func libraryURL() -> URL {
        return URL(fileURLWithPath: self.libraryPath(), isDirectory: true)
    }

    /// 获取 `Caches` 目录 URL
    /// - Returns: `Caches` 目录 URL
    ///
    /// 返回当前用户的 `Caches` 目录路径的 `URL`，可用于与文件操作 API 一起使用。
    ///
    /// - Example:
    /// ```swift
    /// let cachesURL = PathManager.shared.cachesURL()
    /// print(cachesURL)  // 输出 Caches 目录 URL
    /// ```
    static func cachesURL() -> URL {
        return URL(fileURLWithPath: self.cachesPath(), isDirectory: true)
    }

    /// 获取 `tmp` 临时目录 URL
    /// - Returns: `tmp` 目录 URL
    ///
    /// 返回当前用户的临时目录路径的 `URL`，可用于与文件操作 API 一起使用。
    ///
    /// - Example:
    /// ```swift
    /// let tempURL = PathManager.shared.tempURL()
    /// print(tempURL)  // 输出临时目录 URL
    /// ```
    static func tempURL() -> URL {
        return URL(fileURLWithPath: self.tempPath(), isDirectory: true)
    }
}

// MARK: - 路径操作
public extension PathManager {
    /// 生成 `iCloud` 支持目录的完整路径
    /// - Parameter path: 子路径
    /// - Returns: 生成的完整路径字符串
    ///
    /// 根据给定的子路径生成完整的 `iCloud` 支持目录路径，并确保目录已创建。
    ///
    /// - Example:
    /// ```swift
    /// let fullPath = PathManager.shared.makeSupportPath(byAppending: "myfile.txt")
    /// print(fullPath)  // 输出完整路径
    /// ```
    static func makeSupportPath(byAppending path: String) -> String {
        let directory = self.supportPath()
        self.createDirectories(at: directory)
        return directory + "/\(path)"
    }

    /// 生成 `Documents` 目录的完整路径
    /// - Parameter path: 子路径
    /// - Returns: 生成的完整路径字符串
    ///
    /// 根据给定的子路径生成完整的 `Documents` 目录路径，并确保目录已创建。
    ///
    /// - Example:
    /// ```swift
    /// let fullPath = PathManager.shared.makeDocumentsPath(byAppending: "myfile.txt")
    /// print(fullPath)  // 输出完整路径
    /// ```
    static func makeDocumentsPath(byAppending path: String) -> String {
        let directory = self.documentsPath()
        self.createDirectories(at: directory)
        return directory + "/\(path)"
    }

    /// 生成 `Caches` 目录的完整路径
    /// - Parameter path: 子路径
    /// - Returns: 生成的完整路径字符串
    ///
    /// 根据给定的子路径生成完整的 `Caches` 目录路径，并确保目录已创建。
    ///
    /// - Example:
    /// ```swift
    /// let fullPath = PathManager.shared.makeCachesPath(byAppending: "cachefile.txt")
    /// print(fullPath)  // 输出完整路径
    /// ```
    static func makeCachesPath(byAppending path: String) -> String {
        let directory = self.cachesPath()
        self.createDirectories(at: directory)
        return directory + "/\(path)"
    }

    /// 生成临时目录的完整路径
    /// - Parameter path: 子路径
    /// - Returns: 生成的完整路径字符串
    ///
    /// 根据给定的子路径生成完整的临时目录路径，并确保目录已创建。
    ///
    /// - Example:
    /// ```swift
    /// let fullPath = PathManager.shared.makeTempPath(byAppending: "tempfile.txt")
    /// print(fullPath)  // 输出完整路径
    /// ```
    static func makeTempPath(byAppending path: String) -> String {
        let directory = self.tempPath()
        self.createDirectories(at: directory)
        return directory + "/\(path)"
    }
}

// MARK: - 文件和目录操作
private extension PathManager {
    /// 创建目录
    /// - Parameter path: 目录路径
    ///
    /// 在指定路径创建目录，并确保父目录存在。
    /// 如果目录已存在，将不会进行任何操作。
    ///
    /// - Example:
    /// ```swift
    /// PathManager.shared.createDirectories(at: "path/to/directory")
    /// // 确保目录已创建
    /// ```
    static func createDirectories(at path: String) {
        let url = URL(fileURLWithPath: path)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("创建目录失败: \(error.localizedDescription)")
        }
    }
}
