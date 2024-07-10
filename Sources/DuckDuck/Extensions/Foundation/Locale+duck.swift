//
//  Locale+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import Foundation

extension Locale: DDExtensionable {}

// MARK: - 方法
public extension DDExtension where Base == Locale {
    /// 是否是12小时制
    var is12Hour: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self.base

        let dateString = dateFormatter.string(from: Date())

        // 判断是否包含"am/pm"
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}
