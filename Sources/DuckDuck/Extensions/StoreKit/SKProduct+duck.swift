//
//  SKProduct+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import StoreKit

// MARK: - 计算属性
public extension DDExtension where Base: SKProduct {
    /// 本地化商品价格
    var priceLocale: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.base.priceLocale
        return formatter.string(from: self.base.price)
    }
}
