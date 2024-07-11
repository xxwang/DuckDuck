//
//  IndexPath+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

extension IndexPath: DDExtensionable {}

public extension DDExtension where Base == IndexPath {
    /// 用字符串描述`IndexPath`
    var as2String: String {
        return String(format: "{section: %d, row: %d}", self.base.section, self.base.row)
    }
}
