//
//  UICollectionView+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - Defaultable
public extension UICollectionView: Defaultable {
    public typealias Associatedtype = UICollectionView
    @objc open class func `default`() -> Associatedtype {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}

// MARK: - 链式语法
public extension UICollectionView {
    /// 设置 `delegate` 代理
    /// - Parameter delegate:`delegate`
    /// - Returns:`Self`
    @discardableResult
    func dd_delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 dataSource 代理
    /// - Parameter dataSource:`dataSource`
    /// - Returns:`Self`
    @discardableResult
    func dd_dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 注册`UICollectionViewCell`(类名方式)
    /// - Returns:`Self`
    @discardableResult
    func dd_register<T: UICollectionViewCell>(_ cell: T.Type) -> Self {
        self.dd.register(cellWithClass: T.self)
        return self
    }

    /// 设置`Layout`
    /// - Parameters:
    ///   - layout:布局
    ///   - animated:是否动画
    ///   - completion:完成回调
    /// - Returns:`Self`
    @discardableResult
    func dd_setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> Self {
        self.setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 键盘消息模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func dd_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.keyboardDismissMode = mode
        return self
    }

    /// 滚动到指定`IndexPath`
    /// - Parameters:
    ///   - indexPath:第几个IndexPath
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollTo(_ indexPath: IndexPath, at scrollPosition: ScrollPosition = .top, animated: Bool = true) -> Self {
        if indexPath.section < 0
            || indexPath.item < 0
            || indexPath.section > numberOfSections
            || indexPath.row > numberOfItems(inSection: indexPath.section)
        {
            return self
        }
        self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到指定`CGRect`(让指定区域可见)
    /// - Parameters:
    ///   - rect: 要显示的区域
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollRectToVisible(_ rect: CGRect, animated: Bool = true) -> Self {
        guard rect.maxY <= self.dd.bottom else { return self }
        self.scrollRectToVisible(rect, animated: animated)
        return self
    }

    /// 是否滚动到顶部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToTop(animated: Bool = true) -> Self {
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 是否滚动到底部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_scrollToBottom(animated: Bool = true) -> Self {
        let y = contentSize.height - frame.size.height
        if y < 0 { return self }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    /// 滚动到什么位置(`CGPoint`)
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func dd_setContentOffset(_ contentOffset: CGPoint = .zero, animated: Bool = true) -> Self {
        self.setContentOffset(contentOffset, animated: animated)
        return self
    }
}
