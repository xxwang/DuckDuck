//
//  LoggerLevel.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 19/11/2024.
//

import Foundation

/// 日志级别
public enum LoggerLevel: Int {
    case info = 0 // 信息
    case debug = 1 // 调试
    case success = 2 // 成功
    case fail = 3 // 失败
    case error = 4 // 错误
}

extension LoggerLevel {
    /// 日志级别对应的图标
    var icon: String {
        switch self {
        case .info: return "🌸"
        case .debug: return "👻"
        case .success: return "✅"
        case .fail: return "❌"
        case .error: return "💣"
        }
    }

    /// 日志级别标签
    var tag: String {
        switch self {
        case .info: return "信息"
        case .debug: return "调试"
        case .success: return "成功"
        case .fail: return "失败"
        case .error: return "错误"
        }
    }
}
