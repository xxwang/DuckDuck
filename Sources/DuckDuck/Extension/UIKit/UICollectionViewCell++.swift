//
//  UICollectionViewCell++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - Creatable
public extension UICollectionViewCell {
    /// 纯净的创建方法
    static func create<T: UICollectionViewCell>(_ aClass: T.Type = UICollectionViewCell.self) -> T {
        let cell = UICollectionViewCell()
        return cell as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UICollectionViewCell>(_ aClass: T.Type = UICollectionViewCell.self) -> T {
        let cell: UICollectionViewCell = self.create()
        return cell as! T
    }
}

// MARK: - 计算属性
public extension UICollectionViewCell {
    /// 获取 `UICollectionViewCell` 所在的 `UICollectionView`
    /// - Returns: 当前 `UICollectionViewCell` 所在的 `UICollectionView`，若未找到则返回 `nil`
    ///
    /// 示例：
    /// ```swift
    /// if let collectionView = cell.dd_collectionView() {
    ///     print("当前所在的 UICollectionView 是：\(collectionView)")
    /// }
    /// ```
    func dd_collectionView() -> UICollectionView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }

    /// 获取当前 `UICollectionViewCell` 的 `IndexPath`
    /// - Returns: 当前 `UICollectionViewCell` 的 `IndexPath`，若未找到则返回 `nil`
    ///
    /// 示例：
    /// ```swift
    /// if let indexPath = cell.dd_indexPath() {
    ///     print("当前 cell 的 IndexPath 是：\(indexPath)")
    /// }
    /// ```
    func dd_indexPath() -> IndexPath? {
        return self.dd_collectionView()?.indexPath(for: self)
    }

    /// 获取当前 `UICollectionViewCell` 所在的 `UICollectionViewFlowLayout`
    /// - Returns: 当前 `UICollectionView` 的 `UICollectionViewFlowLayout`，若未找到则返回 `nil`
    ///
    /// 示例：
    /// ```swift
    /// if let flowLayout = cell.dd_flowLayout() {
    ///     print("当前的布局是：\(flowLayout)")
    /// }
    /// ```
    func dd_flowLayout() -> UICollectionViewFlowLayout? {
        return self.dd_collectionView()?.collectionViewLayout as? UICollectionViewFlowLayout
    }
}
