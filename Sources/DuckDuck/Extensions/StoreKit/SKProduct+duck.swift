//
//  SKProduct+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import StoreKit

// MARK: - 属性
public extension SKProduct {
    /// 本地化商品价格
    func dd_priceLocale() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
