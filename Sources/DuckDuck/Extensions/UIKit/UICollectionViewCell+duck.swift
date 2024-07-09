//
//  UICollectionViewCell+duck.swift
//
//
//  Created by 王哥 on 2024/6/18.
//

import UIKit

// MARK: - 计算属性
public extension DDExtension where Base: UICollectionViewCell {
    /// 标识符(使用类名注册时)
    static var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Base.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }

    /// 获取`cell`所在的`UICollectionView`
    /// - Returns: `UICollectionView`
    var collectionView: UICollectionView? {
        for view in sequence(first: self.base.superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}

// MARK: - Defaultable
public extension UICollectionViewCell {

    public typealias Associatedtype = UICollectionViewCell
    open override class func `default`() -> Associatedtype {
        return UICollectionViewCell()
    }
}

// MARK: - 链式语法
public extension UICollectionViewCell {}
