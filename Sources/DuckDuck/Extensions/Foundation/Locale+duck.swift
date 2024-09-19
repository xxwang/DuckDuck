//
//  Locale+duck.swift
//
//
//  Created by 王哥 on 2024/7/4.
//

import Foundation

// MARK: - 方法
public extension Locale {
    /// 是否是12小时制
    func dd_is12Hour() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self

        let dateString = dateFormatter.string(from: Date())

        // 判断是否包含"am/pm"
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}
