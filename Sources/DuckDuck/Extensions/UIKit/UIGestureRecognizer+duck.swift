//
//  UIGestureRecognizer+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 关联键
private class AssociateKeys {
    static var kBlockKey = UnsafeRawPointer(bitPattern: ("UIGestureRecognizer" + "kBlockKey").hashValue)
}

// MARK: - 方法
public extension DDExtension where Base: UIGestureRecognizer {
    /// 移除手势识别器
    func removeGesture() {
        self.base.view?.removeGestureRecognizer(self.base)
    }
}

// MARK: - 私有方法
private extension UIGestureRecognizer {
    /// 手势响应方法
    @objc private func dd_invoke() {
        if let block = AssociatedObject.get(self, &AssociateKeys.kBlockKey) as? (_ recognizer: UIGestureRecognizer) -> Void {
            block(self)
        }
    }
}

// MARK: - UIGestureRecognizer
extension UIGestureRecognizer: Defaultable {
    public typealias Associatedtype = UIGestureRecognizer

    @objc open class func `default`() -> Associatedtype {
        return UIGestureRecognizer()
    }
}

// MARK: - 链式语法
public extension UIGestureRecognizer {
    /// 添加手势响应回调
    /// - Parameter callback:响应回调
    /// - Returns: `Self`
    @discardableResult
    func dd_block(_ block: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> Self {
        self.addTarget(self, action: #selector(dd_invoke))
        AssociatedObject.set(self, &AssociateKeys.kBlockKey, block, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }

    /// 添加响应方法
    /// - Parameters:
    ///   - target: 目标
    ///   - action: 方法选择器
    /// - Returns: `Self`
    @discardableResult
    func dd_addTarget(_ target: Any, action: Selector) -> Self {
        self.addTarget(target, action: action)
        return self
    }
}
