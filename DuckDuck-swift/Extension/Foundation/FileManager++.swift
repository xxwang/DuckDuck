import Foundation

// MARK: - 静态方法
public extension FileManager {
    /// 判断路径是否存在
    /// - Parameter path: 路径
    /// - Returns: 是否存在
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file"
    ///   if FileManager.dd_fileExists(at: path) {
    ///       print("文件存在")
    ///   } else {
    ///       print("文件不存在")
    ///   }
    ///   ```
    @discardableResult
    static func dd_fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    /// 获取当前路径的上一级路径
    /// - Parameter fullPath: 完整路径
    /// - Returns: 上一级路径
    /// - Example:
    ///   ```swift
    ///   let fullPath = "/path/to/file.txt"
    ///   let previousPath = FileManager.dd_previousPath(for: fullPath)
    ///   print(previousPath)  // 输出 "/path/to"
    ///   ```
    @discardableResult
    static func dd_previousPath(for fullPath: String) -> String {
        return fullPath.dd_deletingLastPathComponent()
    }

    /// 判断路径是否可读
    /// - Parameter path: 路径
    /// - Returns: 是否可读
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file"
    ///   if FileManager.dd_isReadableFile(at: path) {
    ///       print("文件可读")
    ///   }
    ///   ```
    @discardableResult
    static func dd_isReadableFile(at path: String) -> Bool {
        return FileManager.default.isReadableFile(atPath: path)
    }

    /// 判断路径是否可写
    /// - Parameter path: 路径
    /// - Returns: 是否可写
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file"
    ///   if FileManager.dd_isWritableFile(at: path) {
    ///       print("文件可写")
    ///   }
    ///   ```
    @discardableResult
    static func dd_isWritableFile(at path: String) -> Bool {
        return FileManager.default.isWritableFile(atPath: path)
    }

    /// 判断路径是否可执行
    /// - Parameter path: 路径
    /// - Returns: 是否可执行
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file"
    ///   if FileManager.dd_isExecutableFile(at: path) {
    ///       print("文件可执行")
    ///   }
    ///   ```
    @discardableResult
    static func dd_isExecutableFile(at path: String) -> Bool {
        return FileManager.default.isExecutableFile(atPath: path)
    }

    /// 判断路径是否可删除
    /// - Parameter path: 路径
    /// - Returns: 是否可删除
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file"
    ///   if FileManager.dd_isDeletableFile(at: path) {
    ///       print("文件可删除")
    ///   }
    ///   ```
    @discardableResult
    static func dd_isDeletableFile(at path: String) -> Bool {
        return FileManager.default.isDeletableFile(atPath: path)
    }

    /// 获取路径的扩展名
    /// - Parameter path: 路径
    /// - Returns: 扩展名
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file.txt"
    ///   let ext = FileManager.dd_pathExtension(of: path)
    ///   print(ext)  // 输出 "txt"
    ///   ```
    @discardableResult
    static func dd_pathExtension(of path: String) -> String {
        return path.dd_pathExtension()
    }

    /// 获取文件名称
    /// - Parameters:
    ///   - path: 路径
    ///   - pathExtension: 是否获取扩展名
    /// - Returns: 文件名称
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file.txt"
    ///   let fileName = FileManager.dd_fileName(from: path, withExtension: true)
    ///   print(fileName)  // 输出 "file.txt"
    ///   ```
    @discardableResult
    static func dd_fileName(from path: String, withExtension pathExtension: Bool = true) -> String {
        let fileName = (path as NSString).lastPathComponent
        guard pathExtension else { return fileName.dd_deletingPathExtension() }
        return fileName
    }

    /// 获取指定路径下的所有子内容(不递归)
    /// - Parameter path: 路径
    /// - Returns: 内容数组
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/folder"
    ///   let files = FileManager.dd_shallowSearchAllFiles(at: path)
    ///   print(files)
    ///   ```
    @discardableResult
    static func dd_shallowSearchAllFiles(at path: String) -> [String] {
        guard let result = try? FileManager.default.contentsOfDirectory(atPath: path) else {
            return []
        }
        return result
    }

    /// 获取路径下的所有内容(递归)
    /// - Parameter path: 路径
    /// - Returns: 内容数组
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/folder"
    ///   let files = FileManager.dd_allFiles(at: path)
    ///   print(files)
    ///   ```
    @discardableResult
    static func dd_allFiles(at path: String) -> [String] {
        guard dd_fileExists(at: path),
              let subPaths = FileManager.default.subpaths(atPath: path)
        else {
            return []
        }
        return subPaths
    }

    /// 遍历路径下的所有内容(递归)
    /// - Parameter path: 路径
    /// - Returns: 结果数组
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/folder"
    ///   if let items = FileManager.dd_deepSearchAllFiles(at: path) {
    ///       print(items)
    ///   }
    ///   ```
    @discardableResult
    static func dd_deepSearchAllFiles(at path: String) -> [Any]? {
        guard dd_fileExists(at: path),
              let contents = FileManager.default.enumerator(atPath: path)
        else {
            return nil
        }
        return contents.allObjects
    }

    /// 获取`path`所指`文件`或`文件夹`的属性列表
    /// - Parameter path: 路径
    /// - Returns: 属性列表
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file"
    ///   if let attributes = FileManager.dd_attributeList(for: path) {
    ///       print(attributes)
    ///   }
    ///   ```
    @discardableResult
    static func dd_attributeList(for path: String) -> [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch {
            return nil
        }
    }

    /// 计算路径下的存储大小(单位`字节`)
    /// - Parameter path: 路径
    /// - Returns: 存储大小
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/file"
    ///   let size = FileManager.dd_fileSize(at: path)
    ///   print(size)
    ///   ```
    @discardableResult
    static func dd_fileSize(at path: String) -> UInt64 {
        guard dd_fileExists(at: path) else { return 0 }
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path),
              let sizeValue = attributes[FileAttributeKey.size] as? UInt64
        else {
            return 0
        }
        return sizeValue
    }

    /// 计算路径下的存储大小(格式化表示)
    /// - Parameter path: 路径
    /// - Returns: 格式化表示字符串
    /// - Example:
    ///   ```swift
    ///   let path = "/path/to/folder"
    ///   let size = FileManager.dd_folderSize(at: path)
    ///   print(size)
    ///   ```
    @discardableResult
    static func dd_folderSize(at path: String) -> String {
        if path.isEmpty || !FileManager.default.fileExists(atPath: path) {
            return "0KB"
        }

        var fileSize: UInt64 = 0
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            for file in files {
                let filePath = path + "/\(file)"
                fileSize += dd_fileSize(at: filePath)
            }
        } catch {
            fileSize += dd_fileSize(at: path)
        }
        return fileSize.dd_toStorageUnit()
    }

    /// 判断两个路径所指向(文件/文件夹)是否一致
    /// - Parameters:
    ///   - path1: 路径1
    ///   - path2: 路径2
    /// - Returns: 是否一致
    /// - Example:
    ///   ```swift
    ///   let path1 = "/path/to/file1"
    ///   let path2 = "/path/to/file2"
    ///   if FileManager.dd_contentsEqual(at: path1, and: path2) {
    ///       print("两个文件相同")
    ///   }
    ///   ```
    @discardableResult
    static func dd_contentsEqual(at path1: String, and path2: String) -> Bool {
        return ((path1 == path2) || (self.dd_pathExtension(of: path1) == self.dd_pathExtension(of: path2)))
            && FileManager.default.contentsEqual(atPath: path1, andPath: path2)
    }

    /// 将字符串追加到文件
    /// - Parameters:
    ///   - string: 要追加的内容
    ///   - file: 文件路径
    /// - Returns: 是否成功
    /// - Example:
    ///   ```swift
    ///   let content = "New text to append"
    ///   let path = "/path/to/file"
    ///   if FileManager.dd_appendString(content, to: path) {
    ///       print("追加成功")
    ///   }
    ///   ```
    @discardableResult
    static func dd_appendString(_ string: String, to file: Any) -> Bool {
        do {
            var fileURL: URL?
            if let url = file as? URL {
                fileURL = url
            } else if let path = file as? String {
                fileURL = URL(fileURLWithPath: path)
            }
            guard let url = fileURL else {
                return false
            }

            let fileHandle = try FileHandle(forWritingTo: url)
            fileHandle.seekToEndOfFile()
            fileHandle.write(string.data(using: .utf8) ?? Data())
            return true
        } catch {
            return false
        }
    }

    /// 将字符串写入文件（覆盖内容）
    /// - Parameters:
    ///   - string: 要写入的内容
    ///   - address: 文件路径
    /// - Returns: 是否写入成功
    /// - Example:
    ///   ```swift
    ///   let content = "Overwritten text"
    ///   let path = "/path/to/file"
    ///   if FileManager.dd_writeString(content, to: path) {
    ///       print("写入成功")
    ///   }
    ///   ```
    @discardableResult
    static func dd_writeString(_ string: String, to file: Any) -> Bool {
        do {
            var fileURL: URL?
            if let url = file as? URL {
                fileURL = url
            } else if let path = file as? String {
                fileURL = URL(fileURLWithPath: path)
            }
            guard let url = fileURL else {
                return false
            }

            try string.write(to: url, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }

    /// 在文件中追加`Data`数据
    /// - Parameters:
    ///   - data: 要写入的数据
    ///   - path: 文件路径
    /// - Returns: 写入结果
    /// - Example:
    ///   ```swift
    ///   let dataToWrite = Data("Hello, World!".utf8)
    ///   let filePath = "/path/to/file.txt"
    ///   let result = FileManager.dd_writeData(dataToWrite, to: filePath)
    ///   print(result.message) // 输出 "写入数据成功!" 或其他错误信息
    ///   ```
    @discardableResult
    static func dd_writeData(_ data: Data?, to path: String) -> (isOk: Bool, message: String) {
        guard self.dd_fileExists(at: self.dd_previousPath(for: path)) else { return (false, "文件路径不存在!") }
        guard let data else { return (false, "写入数据不能为空!") }
        guard let url = path.dd_toURL(), path.dd_isValidURL() else { return (false, "写入路径错误!") }

        do {
            try data.write(to: url, options: .atomic)
            return (true, "写入数据成功!")
        } catch {
            return (false, "写入数据失败!")
        }
    }

    /// 读取文件内容
    /// - Parameter path: 文件路径
    /// - Returns: 内容字符串
    /// - Example:
    ///   ```swift
    ///   let filePath = "/path/to/file.txt"
    ///   if let content = FileManager.dd_readFile(filePath) {
    ///       print(content) // 输出文件内容
    ///   } else {
    ///       print("读取文件失败")
    ///   }
    ///   ```
    @discardableResult
    static func dd_readFile(_ path: String) -> String? {
        guard self.dd_fileExists(at: path) else { return nil }
        let data = FileManager.default.contents(atPath: path)
        return String(data: data!, encoding: String.Encoding.utf8)
    }

    /// 以`Data`方式读取文件内容
    /// - Parameter path: 文件路径
    /// - Returns: 读取结果
    /// - Example:
    ///   ```swift
    ///   let filePath = "/path/to/file.txt"
    ///   let result = FileManager.dd_readData(from: filePath)
    ///   if result.isOk {
    ///       print("读取成功，数据：\(result.data!)")
    ///   } else {
    ///       print("读取失败：\(result.error)")
    ///   }
    ///   ```
    @discardableResult
    static func dd_readData(from path: String) -> (isOk: Bool, data: Data?, error: String) {
        guard self.dd_fileExists(at: path),
              let readHandler = FileHandle(forReadingAtPath: path)
        else {
            return (false, nil, "文件路径不存在!")
        }

        let data = readHandler.readDataToEndOfFile()
        if data.count == 0 { return (false, nil, "读取文件失败!") }
        return (true, data, "")
    }

    /// 复制文件
    /// - Parameters:
    ///   - sourcePath: 原路径
    ///   - destinationPath: 目标路径
    /// - Returns: 是否复制成功
    /// - Example:
    ///   ```swift
    ///   let sourcePath = "/path/to/sourceFile"
    ///   let destPath = "/path/to/destinationFile"
    ///   if FileManager.dd_copyFile(from: sourcePath, to: destPath) {
    ///       print("文件复制成功")
    ///   }
    ///   ```
    @discardableResult
    static func dd_copyFile(from sourcePath: String, to destinationPath: String) -> Bool {
        guard dd_fileExists(at: sourcePath) else { return false }
        do {
            try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
            return true
        } catch {
            return false
        }
    }

    /// 移动文件
    /// - Parameters:
    ///   - sourcePath: 原路径
    ///   - destinationPath: 目标路径
    /// - Returns: 是否移动成功
    /// - Example:
    ///   ```swift
    ///   let sourcePath = "/path/to/sourceFile"
    ///   let destPath = "/path/to/destinationFile"
    ///   if FileManager.dd_moveFile(from: sourcePath, to: destPath) {
    ///       print("文件移动成功")
    ///   }
    ///   ```
    @discardableResult
    static func dd_moveFile(from sourcePath: String, to destinationPath: String) -> Bool {
        guard dd_fileExists(at: sourcePath) else { return false }
        do {
            try FileManager.default.moveItem(atPath: sourcePath, toPath: destinationPath)
            return true
        } catch {
            return false
        }
    }

    /// 创建文件夹
    /// - Parameter path: 完整路径
    /// - Returns: 创建结果
    /// - Example:
    ///   ```swift
    ///   let folderPath = "/path/to/folder"
    ///   let result = FileManager.dd_createFolder(folderPath)
    ///   print(result.message) // 输出 "创建成功!" 或 "文件已存在!"
    ///   ```
    @discardableResult
    static func dd_createFolder(_ path: String) -> (isOk: Bool, message: String) {
        if self.dd_fileExists(at: path) { return (true, "文件已存在!") }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return (true, "创建成功!")
        } catch {
            return (false, "创建失败")
        }
    }

    /// 删除文件夹
    /// - Parameter path: 路径
    /// - Returns: 删除结果
    /// - Example:
    ///   ```swift
    ///   let folderPath = "/path/to/folder"
    ///   let result = FileManager.dd_removeFolder(folderPath)
    ///   print(result.message) // 输出 "删除成功!" 或 "文件夹不存在!"
    ///   ```
    @discardableResult
    static func dd_removeFolder(_ path: String) -> (isOk: Bool, message: String) {
        guard self.dd_fileExists(at: path) else { return (true, "文件夹不存在!") }
        do {
            try FileManager.default.removeItem(atPath: path)
            return (true, "删除成功!")
        } catch _ {
            return (false, "删除失败!")
        }
    }

    /// 创建文件
    /// - Parameter path: 路径
    /// - Returns: 创建结果
    /// - Example:
    ///   ```swift
    ///   let filePath = "/path/to/file.txt"
    ///   let result = FileManager.dd_createFile(filePath)
    ///   print(result.message) // 输出 "创建成功!" 或 "文件已存在!"
    ///   ```
    @discardableResult
    static func dd_createFile(_ path: String) -> (isOk: Bool, message: String) {
        guard self.dd_fileExists(at: path) else {
            let ok = FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            return (ok, ok ? "创建成功!" : "创建失败!")
        }
        return (true, "文件已存在!")
    }

    /// 删除文件
    /// - Parameter path: 路径
    /// - Returns: 删除结果
    /// - Example:
    ///   ```swift
    ///   let filePath = "/path/to/file.txt"
    ///   let result = FileManager.dd_removeFile(filePath)
    ///   print(result.message) // 输出 "删除文件成功!" 或 "文件不存在!"
    ///   ```
    @discardableResult
    static func dd_removeFile(_ path: String) -> (isOk: Bool, message: String) {
        guard self.dd_fileExists(at: path) else { return (true, "文件不存在!") }

        do {
            try FileManager.default.removeItem(atPath: path)
            return (true, "删除文件成功!")
        } catch {
            return (false, "删除文件失败!")
        }
    }
}
