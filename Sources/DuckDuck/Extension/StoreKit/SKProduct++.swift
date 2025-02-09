import StoreKit

// MARK: - SKProduct 扩展
public extension SKProduct {
    /// 获取商品的本地化价格
    /// - Returns: 商品价格的本地化字符串
    /// - Example:
    /// ```swift
    /// if let price = product.dd_localizedPrice() {
    ///     print("商品价格：\(price)")
    /// }
    /// ```
    func dd_localizedPrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }

    /// 获取商品的本地化标题
    /// - Returns: 商品标题的本地化字符串
    /// - Example:
    /// ```swift
    /// let title = product.dd_localizedTitle()
    /// print("商品标题：\(title)")
    /// ```
    func dd_localizedTitle() -> String {
        return self.localizedTitle
    }

    /// 获取商品的本地化描述
    /// - Returns: 商品描述的本地化字符串
    /// - Example:
    /// ```swift
    /// let description = product.dd_localizedDescription()
    /// print("商品描述：\(description)")
    /// ```
    func dd_localizedDescription() -> String {
        return self.localizedDescription
    }

    /// 检查商品是否为订阅类型
    /// - Returns: 布尔值，表示商品是否为订阅
    /// - Example:
    /// ```swift
    /// let isSubscription = product.dd_isSubscription()
    /// print("是否订阅类型：\(isSubscription)")
    /// ```
    func dd_isSubscription() -> Bool {
        if #available(iOS 11.2, *) {
            return self.subscriptionPeriod != nil
        }
        return false
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
        guard #available(iOS 11.2, *), let period = self.subscriptionPeriod else {
            return nil
        }
        switch period.unit {
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
        guard #available(iOS 11.2, *), let introductoryOffer = self.introductoryPrice else {
            return nil
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale

        let priceString = formatter.string(from: introductoryOffer.price) ?? ""
        let unitCount = introductoryOffer.subscriptionPeriod.numberOfUnits
        let unit = introductoryOffer.subscriptionPeriod.unit

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
