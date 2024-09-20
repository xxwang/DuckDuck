////
////  StoreUtils.swift
////
////
////  Created by xxwang on 2023/5/29.
////
//
// import StoreKit
//
// class StoreUtils: NSObject {
//    /// 结果回调
//    private var goodsListResult: ((_ result: SKProductsResponse?) -> Void)?
//
//    /// 单例属性
//    public static let shared = StoreUtils()
//    override private init() {}
//
//    deinit {
//        SKPaymentQueue.default().remove(self)
//    }
// }
//
// extension StoreUtils {
//    /// 根据`商品ID`从`App store`获取`商品信息`
//    /// - Parameters:
//    ///   - ids: `商品ID`
//    ///   - result: 商品列表回调
//    func fetchGoodsList(ids: [String], result: ((_ result: SKProductsResponse?) -> Void)?) {
//        goodsListResult = result
//
//        let request = SKProductsRequest(productIdentifiers: Set<String>(ids))
//        request.delegate = self
//        request.start()
//    }
//
//    /// 购买商品
//    /// - Parameter product: 要购买的商品
//    func buy(product: SKProduct) {
//        // 检测是否可以使用支付功能
//        if !SKPaymentQueue.canMakePayments() {
//            return
//        }
//
//        let payment = SKMutablePayment(product: product)
//        payment.applicationUsername = nil // 透传参数
//        payment.quantity = 1 // 数量
//
//        // 添加到支付队列,开始进行购买操作
//        SKPaymentQueue.default().add(payment)
//        // 添加队列代理
//        SKPaymentQueue.default().delegate = self
//        // 添加队列监听者
//        SKPaymentQueue.default().add(self)
//    }
//
//    /// 恢复购买
//    func restore() {
//        SKPaymentQueue.default().restoreCompletedTransactions()
//        SKPaymentQueue.default().add(self)
//    }
// }
//
//// MARK: - SKProductsRequestDelegate
// extension StoreUtils: SKProductsRequestDelegate {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        goodsListResult?(response)
//    }
//
//    func requestDidFinish(_ request: SKRequest) {
//        print("商品请求成功!")
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("商品请求失败:\(error.localizedDescription)")
//        goodsListResult?(nil)
//    }
// }
//
//// MARK: - SKPaymentQueueDelegate
// extension StoreUtils: SKPaymentQueueDelegate {
//    /// `SKStorefront` 发生变化的时候被调用`true`:继续交易 `false`:停止交易
//    func paymentQueue(_ paymentQueue: SKPaymentQueue, shouldContinue transaction: SKPaymentTransaction, in newStorefront: SKStorefront) -> Bool {
//        true
//    }
//
//    /// 当前用户的`App Store`有待定价格同意时调用, `true`: 立即显示价格同意UI `false`: 延迟显示
//    func paymentQueueShouldShowPriceConsent(_ paymentQueue: SKPaymentQueue) -> Bool {
//        true
//    }
// }
//
//// MARK: - SKPaymentTransactionObserver
// extension StoreUtils: SKPaymentTransactionObserver {
//    /// 当交易队列中添加的每一笔交易状态发生变化时调用
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .deferred: // 延时处理
//                break
//            case .failed: // 支付失败
//                queue.finishTransaction(transaction)
//            case .purchased: // 支付成功
//                queue.finishTransaction(transaction)
//            case .purchasing: // 正在支付
//                break
//            case .restored: // 恢复购买
//                queue.finishTransaction(transaction)
//            default:
//                break
//            }
//        }
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {}
//
//    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {}
//
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {}
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {}
//
//    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
//        true
//    }
//
//    func paymentQueueDidChangeStorefront(_ queue: SKPaymentQueue) {}
//
//    func paymentQueue(_ queue: SKPaymentQueue, didRevokeEntitlementsForProductIdentifiers productIdentifiers: [String]) {}
// }
