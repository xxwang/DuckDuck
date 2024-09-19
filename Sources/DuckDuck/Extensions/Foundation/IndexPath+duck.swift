//
//  IndexPath+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

public extension IndexPath {
    /// 用字符串描述`IndexPath`
    func dd_String() -> String {
        return String(format: "{section: %d, row: %d}", self.section, self.row)
    }
}
