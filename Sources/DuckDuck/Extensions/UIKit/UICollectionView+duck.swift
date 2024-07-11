//
//  UICollectionView+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 方法
public extension DDExtension where Base: UICollectionView {
    /// 刷新`UICollectionView`的数据,刷新后调用回调
    /// - Parameter completion:完成回调
    func reloadData(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0, animations: {
            self.base.reloadData()
        }, completion: { _ in
            completion?()
        })
    }
}

// MARK: - UICollectionViewCell
public extension DDExtension where Base: UICollectionView {
    /// 使用类名注册`UICollectionViewCell`
    /// - Parameter name:`UICollectionViewCell`类型
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        self.base.register(T.self, forCellWithReuseIdentifier: name.dd.identifier)
    }

    /// 使用类名注册`UICollectionView`
    /// - Parameters:
    ///   - nib:用于创建`collectionView`单元格的`nib`文件
    ///   - name:`UICollectionViewCell`类型
    func register(nib: UINib?, forCellWithClass name: (some UICollectionViewCell).Type) {
        self.base.register(nib, forCellWithReuseIdentifier: name.dd.identifier)
    }

    /// 向注册`UICollectionViewCell`.仅使用其对应类的`xib`文件
    /// 假设xib文件名称和`cell`类具有相同的名称
    /// - Parameters:
    ///   - name:`UICollectionViewCell`类型
    ///   - bundleClass:`Bundle`实例将基于的类
    func register(nibWithCellClass name: (some UICollectionViewCell).Type, at bundleClass: AnyClass? = nil) {
        var bundle: Bundle?
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        self.base.register(UINib(nibName: name.dd.identifier, bundle: bundle), forCellWithReuseIdentifier: name.dd.identifier)
    }

    /// 使用类名和索引获取可重用`UICollectionViewCell`
    /// - Parameters:
    ///   - name:`UICollectionViewCell`类型
    ///   - indexPath:`UICollectionView`中单元格的位置
    /// - Returns:类名关联的`UICollectionViewCell`对象
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.base.dequeueReusableCell(withReuseIdentifier: name.dd.identifier, for: indexPath) as? T else {
            fatalError(
                "Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }
}

// MARK: - UICollectionReusableView
public extension DDExtension where Base: UICollectionView {
    /// 使用类名注册`UICollectionReusableView`
    /// - Parameters:
    ///   - kind:要检索的补充视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        self.base.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: name.dd.identifier)
    }

    /// 使用类名注册`UICollectionReusableView`
    /// - Parameters:
    ///   - nib:用于创建可重用视图的`nib`文件
    ///   - kind:要检索的视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    func register(nib: UINib?, forSupplementaryViewOfKind kind: String, withClass name: (some UICollectionReusableView).Type) {
        self.base.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// 使用类名和类型获取可重用`UICollectionReusableView`
    /// - Parameters:
    ///   - kind:要检索的视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    ///   - indexPath:单元格在`UICollectionView`中的位置
    /// - Returns:类名关联的`UICollectionReusableView`对象
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let reusableView = self.base.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return reusableView
    }
}

// MARK: - 移动
public extension DDExtension where Base: UICollectionView {
    /// 开启Item移动(添加长按手势)
    func allowMoveItem() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self.base, action: #selector(UICollectionView.longPressGRHandler(_:)))
        self.base.addGestureRecognizer(longPressGestureRecognizer)
    }

    /// 禁止Item移动(移除长按手势)
    func disableMoveItem() {
        _ = self.base.gestureRecognizers?.map {
            if let gestureRecognizer = $0 as? UILongPressGestureRecognizer {
                self.base.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
}

// MARK: - 私有事件处理
private extension UICollectionView {
    /// 长按手势处理
    @objc func longPressGRHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: gestureRecognizer.view!)
        switch gestureRecognizer.state {
        case .began: // 开始移动
            if let selectedIndexPath = self.indexPathForItem(at: point) {
                self.beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case .changed: // 移动中
            self.updateInteractiveMovementTargetPosition(point)
        case .ended: // 结束移动
            self.endInteractiveMovement()
        default: // 取消移动
            self.cancelInteractiveMovement()
        }
    }
}

// MARK: - Defaultable
public extension UICollectionView {
    typealias Associatedtype = UICollectionView

    override open class func `default`() -> Associatedtype {
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
