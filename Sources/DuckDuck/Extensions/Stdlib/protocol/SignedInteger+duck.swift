//
//  SignedInteger+duck.swift
//
//
//  Created by 王哥 on 2024/6/14.
//

import Foundation

public extension SignedInteger {
    var dd: DDExtension<Self> {
        return DDExtension(self)
    }
}

// MARK: - 计算属性
public extension DDExtension where Base: SignedInteger {
    /// 绝对值
    var abs: Self {
        return Swift.abs(self.base) as! Self
    }
}
