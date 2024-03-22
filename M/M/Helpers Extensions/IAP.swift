//
//  IAP.swift
//  Smart Wallpaper Art
//
//  Created by Sean Kelly on 30/05/2023.
//

import UIKit
import StoreKit
import ConfettiSwiftUI

typealias ProductCallback = (SKProduct?) -> Void
typealias ProductsCallback = ([SKProduct]?) -> Void
typealias ProductIDsCallback = ([String]?) -> Void
typealias PurchaseCallback = (String) -> Void
typealias BoolClosure = (Bool) -> Void


extension Notification.Name {
    static let IAPManagerDidPurchaseProduct = Notification.Name("IAPManagerDidPurchaseProduct")
}

class IAP: NSObject {
    static let shared = IAP()
    static let purchaseID_UnlockPremium = "MUnlockPremium"
    static let purchaseID_silver = "MSilver"
    static let purchaseID_gold = "MGold"
    static let purchaseID_bronze = "MBronze"
    static let purchaseID_M099 = "M099"
    static let purchaseID_M199 = "M199"
    static let purchaseID_M299 = "M299"
    static let purchaseID_M399 = "M399"
    static let purchaseID_M499 = "M499"
    public var cachedProducts = [String: SKProduct]()
    private var productsRequest: SKProductsRequest?
    private var productsCallback: ProductsCallback?
    private var productsFailedCallback: ProductsCallback?
    private var purchaseCallback: PurchaseCallback?
    private var restoreCallback: ProductIDsCallback?
    private var restoreFailedCallback: ProductIDsCallback?
    private var failedCallback: PurchaseCallback?
    private let defaults = UserDefaults.standard
    
    private func showPopup(title: String?, subtitle: String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Popup Button"), style: .cancel, handler: nil))
            UIApplication.shared.rootController()?.present(alertController, animated: true)
        }
    }
    
    
    func enablePurchase(_ productKey: String) {
        DispatchQueue.main.async { [weak self] in
            self?.defaults.set(true, forKey: productKey)
            self?.defaults.synchronize()
        }
    }
    
    
    public func purchase(_ productID: String, completion: BoolClosure?) {
        if SKPaymentQueue.canMakePayments() {
            purchaseProduct(productID) { [weak self] _ in
                completion?(true)
                self?.showPopup(title: NSLocalizedString("Purchased", comment: "In-App Purchase Messages"), subtitle: nil)
                
            } failed: { [weak self] _ in
                completion?(false)
                self?.showPopup(title: NSLocalizedString("Purchase failed", comment: "In-App Purchase Messages"), subtitle: nil)
            }
        } else {
            completion?(false)
            showPopup(title: NSLocalizedString("Purchases Disabled", comment: "In-App Purchase Messages"), subtitle: nil)
        }
    }
    
    public func restorePurchases(completion: ProductIDsCallback?, failed: ProductIDsCallback?) {
        restore { [weak self] products in
            var unlockedStuff = 0
            if let products {
                unlockedStuff = products.count
            }
            completion?(products)
            
            if unlockedStuff == 0 {
                self?.showPopup(title: NSLocalizedString("No Purchases Have Been Restored", comment: "In-App Purchase Messages"), subtitle: nil)
            } else {
                self?.showPopup(title: NSLocalizedString("Purchases Restored", comment: "In-App Purchase Messages"), subtitle: nil)
            }
        } failed: { [weak self] products in
            self?.showPopup(title: NSLocalizedString("Restore Cancelled", comment: "In-App Purchase Messages"), subtitle: nil)
            failed?(products)
        }
    }
    
    public func requestProductData(_ key: String, callback: ProductCallback?, failed: ProductCallback?) {
        requestProductsData([key]) { products in
            callback?(products?.first)
        } failed: { products in
            failed?(products?.first)
        }
    }
    
    public func requestProductsData(_ keys: Set<String>, callback: ProductsCallback?, failed: ProductsCallback?) {
        var haveAllCached = true
        var products = [SKProduct]()
        
        for key in keys {
            if let product = cachedProducts[key] {
                products.append(product)
            } else {
                haveAllCached = false
                break
            }
        }
        
        if haveAllCached {
            callback?(products)
            return
        }
        
        productsCallback = callback
        productsFailedCallback = failed
        productsRequest = SKProductsRequest.init(productIdentifiers: keys)
        if let productsRequest {
            productsRequest.delegate = self
            DispatchQueue.main.async {
                productsRequest.start()
            }
        }
    }
    
    private func purchaseProduct(_ productId: String, success: PurchaseCallback?, failed: PurchaseCallback?) {
        purchaseCallback = success
        failedCallback = failed
        
        if let product = cachedProducts[productId] {
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            failedCallback?(productId)
        }
    }
    
    private func restore(success: ProductIDsCallback?, failed: ProductIDsCallback?) {
        restoreCallback = success
        restoreFailedCallback = failed
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
        
        requestProductsData([IAP.purchaseID_silver, IAP.purchaseID_gold, IAP.purchaseID_bronze], callback: nil, failed: nil)
    }
}

extension IAP: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.invalidProductIdentifiers.count > 0 {
            print("invalid product keys: \(response.invalidProductIdentifiers)")
            
            DispatchQueue.main.async { [weak self] in
                self?.productsCallback?(nil)
            }
            return
        }
        
        if response.products.count == 0 {
            print("no products in response")
            
            DispatchQueue.main.async { [weak self] in
                self?.productsCallback?(nil)
            }
            return
        }
        
        for product in response.products {
            cachedProducts[product.productIdentifier] = product
        }
        DispatchQueue.main.async { [weak self] in
            self?.productsCallback?(response.products)
        }
    }
}

extension IAP: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                enablePurchase(transaction.payment.productIdentifier)
                purchaseCallback?(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                
                //MARK: Shows Confettit
                NotificationCenter.default.post(name: .IAPManagerDidPurchaseProduct, object: nil)
            case .restored:
                if let productIdentifier = transaction.original?.payment.productIdentifier {
                    enablePurchase(productIdentifier)
                    purchaseCallback?(productIdentifier)
                    
                    //MARK: Shows Confettit
                    NotificationCenter.default.post(name: .IAPManagerDidPurchaseProduct, object: nil)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print(transaction.error?.localizedDescription ?? "")
                failedCallback?(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error)
        var restored = [String]()
        
        for transaction in queue.transactions {
            if let productIdentifier = transaction.original?.payment.productIdentifier {
                restored.append(productIdentifier)
            }
        }
        
        restoreFailedCallback?(restored)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        var restored = [String]()
        
        for transaction in queue.transactions {
            if transaction.transactionState == .restored, let productIdentifier = transaction.original?.payment.productIdentifier {
                restored.append(productIdentifier)
            }
        }
        
        restoreCallback?(restored)
    }
}

extension IAP: SKRequestDelegate {
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
        productsFailedCallback?(nil)
    }
}

extension SKProduct {
    var localizedPrice: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = priceLocale
        
        return numberFormatter.string(from: price)
    }
}


extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    func rootController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        
        return rootViewController
    }
}

