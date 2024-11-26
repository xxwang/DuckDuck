//
//  Product++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import StoreKit

// MARK: - StoreKit.Product 扩展
@available(iOS 15.0, *)
public extension Product {
    /// 获取商品的本地化价格
    /// - Returns: 商品价格的本地化字符串
    /// - Example:
    /// ```swift
    /// if let price = product.dd_localizedPrice() {
    ///     print("商品价格：\(price)")
    /// }
    /// ```
    func dd_localizedPrice() -> String {
        return self.price.formatted(.currency(code: priceFormatStyle.currencyCode))
    }

    /// 获取商品的本地化标题
    /// - Returns: 商品标题的本地化字符串
    /// - Example:
    /// ```swift
    /// let title = product.dd_localizedTitle()
    /// print("商品标题：\(title)")
    /// ```
    func dd_localizedTitle() -> String {
        return self.displayName
    }

    /// 获取商品的本地化描述
    /// - Returns: 商品描述的本地化字符串
    /// - Example:
    /// ```swift
    /// let description = product.dd_localizedDescription()
    /// print("商品描述：\(description)")
    /// ```
    func dd_localizedDescription() -> String {
        return self.description
    }

    /// 检查商品是否为订阅类型
    /// - Returns: 布尔值，表示商品是否为订阅
    /// - Example:
    /// ```swift
    /// let isSubscription = product.dd_isSubscription()
    /// print("是否订阅类型：\(isSubscription)")
    /// ```
    func dd_isSubscription() -> Bool {
        return self.subscription != nil
    }

    /// 获取订阅类型的周期描述
    /// - Returns: 订阅周期的本地化描述
    /// - Example:
    /// ```swift
    /// if let subscriptionPeriod = product.dd_subscriptionPeriodDescription() {
    ///     print("订阅周期：\(subscriptionPeriod)")
    /// }
    /// ```
    func dd_subscriptionPeriodDescription() -> String? {
        guard let subscriptionPeriod = self.subscription?.subscriptionPeriod else { return nil }
        switch subscriptionPeriod.unit {
        case .day:
            return "每日订阅"
        case .week:
            return "每周订阅"
        case .month:
            return "每月订阅"
        case .year:
            return "每年订阅"
        @unknown default:
            return "未知订阅周期"
        }
    }

    /// 获取试用期的描述
    /// - Returns: 试用期的本地化描述字符串
    /// - Example:
    /// ```swift
    /// if let trialDescription = product.dd_introductoryOfferDescription() {
    ///     print("试用期说明：\(trialDescription)")
    /// }
    /// ```
    func dd_introductoryOfferDescription() -> String? {
        guard let introductoryOffer = self.subscription?.introductoryOffer else { return nil }
        let priceString = introductoryOffer.price.formatted(.currency(code: priceFormatStyle.currencyCode))
        let unitCount = introductoryOffer.period.value
        let unit = introductoryOffer.period.unit

        switch unit {
        case .day:
            return "\(priceString) - \(unitCount) 天试用"
        case .week:
            return "\(priceString) - \(unitCount) 周试用"
        case .month:
            return "\(priceString) - \(unitCount) 月试用"
        case .year:
            return "\(priceString) - \(unitCount) 年试用"
        @unknown default:
            return "未知试用期"
        }
    }
}
