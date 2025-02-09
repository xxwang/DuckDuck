import Foundation

// MARK: - 内部功能
extension Logger {
    /// 日志输出方法
    /// - Parameters:
    ///   - level: 日志级别
    ///   - message: 日志内容
    ///   - file: 文件名
    ///   - line: 行号
    ///   - function: 方法名
    class func output(level: LoggerLevel, message: Any..., file: String, line: Int, function: String) {
        // 检查日志级别是否允许输出，若允许则打印日志
        guard level.rawValue >= self.level.rawValue else { return }

        // 组装日志消息
        let log = self.outputFormat(level: level, message: message, file: file, line: line, function: function)

        // 输出日志到控制台
        self.outputToConsole(with: log)

        // 输出日志到文件
        self.outputToFile(with: log)
    }
}

// MARK: - 输出日志
private extension Logger {
    /// 输出日志到控制台
    /// - Parameter message: 完整日志内容
    class func outputToConsole(with message: String) {
        print(message)
    }

    /// 输出日志到文件
    /// - Parameter message: 完整日志内容
    class func outputToFile(with message: String) {
        guard self.fileEnabled else { return }

        // 日志文件位置
        let fileURL = URL(fileURLWithPath: self.filePath)

        // 为日志消息添加换行符
        let lineMessage = message + "\n"
        // 字符串转Data
        guard let lineMessageData = lineMessage.dd_toData() else {
            print("行日志消息转Data失败!")
            return
        }

        // 如果存在日志文件则追加日志；如果不存在日志文件则创建并写入
        do {
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                fileHandle.seekToEndOfFile()
                try fileHandle.write(contentsOf: lineMessageData)
                fileHandle.closeFile()
            } else {
                try lineMessage.write(to: fileURL, atomically: true, encoding: .utf8)
            }
        } catch {
            print("写入日志失败: \(error.localizedDescription)")
        }
    }
}

// MARK: - 格式化日志
private extension Logger {
    /// 格式化日志内容
    /// - Parameters:
    ///   - level: 日志级别
    ///   - message: 日志内容
    ///   - file: 文件名
    ///   - line: 行号
    ///   - function: 方法名
    /// - Returns: 完整日志内容字符串
    class func outputFormat(level: LoggerLevel, message: Any..., file: String, line: Int, function: String) -> String {
        // 日志级别图标
        let icon = level.icon
        // 日志级别标签
        let tag = level.tag
        // 时间戳
        let timestamp = self.showTimestamp ? " [\(self.timestamp)] " : ""
        // 文件名称
        let fileName = (file as NSString).lastPathComponent
        // 拼接日志内容
        let content = message.map { "\($0)" }.joined(separator: " ")

        // 返回完整日志内容
        return "\(icon)[\(tag)]\(timestamp)[\(fileName)(\(line))] \(function): \(content)"
    }

    /// 获取当前时间戳
    class var timestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter.string(from: Date())
    }
}
