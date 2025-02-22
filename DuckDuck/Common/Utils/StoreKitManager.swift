import StoreKit

public final class StoreKitManager {
    // 单例实例，确保应用中只有一个 `StoreKitManager` 实例
    public static let shared = StoreKitManager()
    private init() {}
}

// MARK: - 商品信息相关
public extension StoreKitManager {
    /// 请求商品信息
    /// - Parameter productIDs: 商品的标识符数组
    /// - Returns: 获取的商品集合
    ///
    /// 根据提供的商品标识符数组请求商品信息，返回一个包含商品详情的集合。如果请求成功，则返回包含所有商品的数组。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     do {
    ///         let products = try await StoreKitManager.shared.fetchProducts(by: ["com.example.product1", "com.example.product2"])
    ///         print(products)  // 输出获取到的商品信息
    ///     } catch {
    ///         print("获取商品信息失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func fetchProducts(by productIDs: [String]) async throws -> [Product] {
        let products = try await Product.products(for: productIDs)
        return products
    }
}

// MARK: - 购买相关
public extension StoreKitManager {
    /// 执行商品购买
    /// - Parameter product: 商品实例
    /// - Returns: 购买结果
    ///
    /// 使用指定的商品实例执行购买操作，返回购买结果。如果购买成功，将返回一个购买结果，表示交易完成的状态。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     do {
    ///         let product = products[0]  // 假设已获得商品列表
    ///         let result = try await StoreKitManager.shared.purchase(product: product)
    ///         print("购买结果: \(result)")
    ///     } catch {
    ///         print("购买失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    @discardableResult
    func purchase(product: Product) async throws -> Product.PurchaseResult {
        let result = try await product.purchase()
        return result
    }
}

// MARK: - 权益管理
public extension StoreKitManager {
    /// 检查已购买商品
    /// - Returns: 已购商品的事务集合
    ///
    /// 检查并返回当前所有已购买的商品事务，过滤出有效的购买事务。
    /// 该方法会返回所有已购买的商品交易记录，包括已完成的和未完成的交易。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     do {
    ///         let purchasedTransactions = try await StoreKitManager.shared.checkPurchasedProducts()
    ///         for transaction in purchasedTransactions {
    ///             print("已购买商品: \(transaction.productID)")
    ///         }
    ///     } catch {
    ///         print("获取已购商品失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func checkPurchasedProducts() async throws -> [Transaction] {
        var purchasedTransactions: [Transaction] = []
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                purchasedTransactions.append(transaction)
            }
        }
        return purchasedTransactions
    }

    /// 验证并更新交易
    /// - Parameter transaction: 待验证的事务
    ///
    /// 验证指定的交易是否有效，并在交易有效时完成它。该方法会确保交易没有被撤销并处理完成状态。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     let transaction = transactions[0]  // 假设已获得一个交易
    ///     await StoreKitManager.shared.verifyTransaction(transaction)
    ///     print("交易已完成")
    /// }
    /// ```
    func verifyTransaction(_ transaction: Transaction) async {
        guard transaction.revocationDate == nil else { return }
        await transaction.finish()
    }
}

// MARK: - 订阅管理
public extension StoreKitManager {
    /// 检查活跃订阅
    /// - Returns: 当前活跃的订阅交易
    ///
    /// 获取当前有效的自动续订订阅交易。此方法将检查所有已购买的商品，并返回类型为 `.autoRenewable` 的订阅交易。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     do {
    ///         let activeSubscriptions = try await StoreKitManager.shared.fetchActiveSubscriptions()
    ///         for subscription in activeSubscriptions {
    ///             print("活跃订阅: \(subscription.productID)")
    ///         }
    ///     } catch {
    ///         print("获取活跃订阅失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func fetchActiveSubscriptions() async throws -> [Transaction] {
        let transactions = try await checkPurchasedProducts()
        return transactions.filter { $0.productType == .autoRenewable }
    }

    /// 恢复购买
    /// - Returns: 恢复的交易集合
    ///
    /// 获取所有未完成的交易并恢复购买。此方法将恢复用户之前的未完成交易，并验证这些交易。
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     do {
    ///         let restoredTransactions = try await StoreKitManager.shared.restorePurchases()
    ///         for transaction in restoredTransactions {
    ///             print("恢复的购买: \(transaction.productID)")
    ///         }
    ///     } catch {
    ///         print("恢复购买失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func restorePurchases() async throws -> [Transaction] {
        var restoredTransactions: [Transaction] = []
        for await result in Transaction.unfinished {
            if case let .verified(transaction) = result {
                restoredTransactions.append(transaction)
                await verifyTransaction(transaction)
            }
        }
        return restoredTransactions
    }
}
