//
//  UICollectionViewCell+duck.swift
//
//
//  Created by 王哥 on 2024/6/18.
//

import UIKit

// MARK: - 计算属性
public extension UICollectionViewCell {
    /// 获取`cell`所在的`UICollectionView`
    /// - Returns: `UICollectionView`
    func dd_collectionView() -> UICollectionView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}

// MARK: - 链式语法
public extension UICollectionViewCell {}
