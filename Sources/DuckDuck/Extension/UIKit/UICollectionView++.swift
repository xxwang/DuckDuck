//
//  UICollectionView++.swift
//  DuckDuck
//
//  Created by xxwang on 24/11/2024.
//

import UIKit

// MARK: - UICollectionView 扩展
public extension UICollectionView {
    /// 刷新 `UICollectionView` 的数据，并在刷新完成后调用回调
    /// - Parameter completion: 数据刷新完成后的回调
    ///
    /// 使用该方法可以刷新 UICollectionView 中的数据，并在数据刷新后执行 `completion` 回调。
    /// 例如，可以在数据加载完成后进行 UI 更新。
    ///
    /// ```swift
    /// collectionView.dd_reloadData {
    ///     print("数据刷新完成")
    /// }
    /// ```
    func dd_reloadData(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion?()
        })
    }
}

// MARK: - UICollectionViewCell 注册和复用
public extension UICollectionView {
    /// 使用类名注册 `UICollectionViewCell`
    /// - Parameter cellType: `UICollectionViewCell` 的类型
    ///
    /// 使用此方法注册一个 `UICollectionViewCell`，只需提供类名。该方法会自动使用 `reuseIdentifier` 作为标识符。
    ///
    /// ```swift
    /// collectionView.dd_register(cellWithClass: CustomCell.self)
    /// ```
    func dd_register(cellWithClass cellType: (some UICollectionViewCell).Type) {
        self.register(cellType, forCellWithReuseIdentifier: cellType.dd_identifier())
    }

    /// 使用 `Nib` 文件注册 `UICollectionViewCell`
    /// - Parameters:
    ///   - nib: 用于创建单元格的 `Nib` 文件
    ///   - cellType: `UICollectionViewCell` 的类型
    ///
    /// 使用此方法可以通过 `Nib` 文件注册一个 `UICollectionViewCell`，提供 `Nib` 文件和类型。
    ///
    /// ```swift
    /// let nib = UINib(nibName: "CustomCell", bundle: nil)
    /// collectionView.dd_register(nib: nib, forCellWithClass: CustomCell.self)
    /// ```
    func dd_register(nib: UINib?, forCellWithClass cellType: (some UICollectionViewCell).Type) {
        self.register(nib, forCellWithReuseIdentifier: cellType.dd_identifier())
    }

    /// 注册仅使用类名对应 `xib` 的 `UICollectionViewCell`
    /// - Parameters:
    ///   - cellType: `UICollectionViewCell` 的类型
    ///   - bundleClass: `Bundle` 的参照类
    ///
    /// 如果你的 `UICollectionViewCell` 只包含与类名相同的 `xib` 文件，可以使用此方法进行注册。
    /// 提供一个类名，系统会自动根据类名加载对应的 `xib` 文件。
    ///
    /// ```swift
    /// collectionView.dd_register(nibWithCellClass: CustomCell.self, at: MyClass.self)
    /// ```
    func dd_register(nibWithCellClass cellType: (some UICollectionViewCell).Type, at bundleClass: AnyClass? = nil) {
        let bundle = bundleClass.flatMap { Bundle(for: $0) }
        self.register(UINib(nibName: cellType.dd_identifier(), bundle: bundle), forCellWithReuseIdentifier: cellType.dd_identifier())
    }

    /// 根据类名和索引复用 `UICollectionViewCell`
    /// - Parameters:
    ///   - cellType: `UICollectionViewCell` 的类型
    ///   - indexPath: 单元格的位置
    /// - Returns: 复用的 `UICollectionViewCell` 实例
    ///
    /// 使用此方法根据类名和索引路径复用一个单元格。确保在调用此方法之前已注册相应的单元格。
    ///
    /// ```swift
    /// let cell: CustomCell = collectionView.dd_dequeueReusableCell(withClass: CustomCell.self, for: indexPath)
    /// ```
    func dd_dequeueReusableCell<T: UICollectionViewCell>(withClass cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.dd_identifier(), for: indexPath) as? T else {
            fatalError("未找到对应类型的 UICollectionViewCell: \(String(describing: cellType))，请确保已注册")
        }
        return cell
    }
}

// MARK: - UICollectionReusableView 注册和复用
public extension UICollectionView {
    /// 使用类名注册 `UICollectionReusableView`
    /// - Parameters:
    ///   - kind: 补充视图的种类
    ///   - viewType: `UICollectionReusableView` 的类型
    ///
    /// 注册补充视图（如头部或尾部视图）。`kind` 参数指定补充视图的种类（例如 `.sectionHeader`）。
    ///
    /// ```swift
    /// collectionView.dd_register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: CustomHeaderView.self)
    /// ```
    func dd_register(supplementaryViewOfKind kind: String, withClass viewType: (some UICollectionReusableView).Type) {
        self.register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.dd_identifier())
    }

    /// 使用 `Nib` 文件注册 `UICollectionReusableView`
    /// - Parameters:
    ///   - nib: 用于创建视图的 `Nib` 文件
    ///   - kind: 补充视图的种类
    ///   - viewType: `UICollectionReusableView` 的类型
    ///
    /// 使用此方法注册补充视图，提供 `Nib` 文件和类型。`kind` 参数指定补充视图的种类。
    ///
    /// ```swift
    /// let nib = UINib(nibName: "CustomHeaderView", bundle: nil)
    /// collectionView.dd_register(nib: nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: CustomHeaderView.self)
    /// ```
    func dd_register(nib: UINib?, forSupplementaryViewOfKind kind: String, withClass viewType: (some UICollectionReusableView).Type) {
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.dd_identifier())
    }

    /// 根据类名和种类复用 `UICollectionReusableView`
    /// - Parameters:
    ///   - kind: 补充视图的种类
    ///   - viewType: `UICollectionReusableView` 的类型
    ///   - indexPath: 视图在 `UICollectionView` 中的位置
    /// - Returns: 复用的 `UICollectionReusableView` 实例
    ///
    /// 使用此方法根据 `kind` 和类名复用一个补充视图。确保在调用此方法之前已注册该视图。
    ///
    /// ```swift
    /// let headerView: CustomHeaderView = collectionView.dd_dequeueReusableSupplementaryView(
    ///     ofKind: UICollectionView.elementKindSectionHeader,
    ///     withClass: CustomHeaderView.self,
    ///     for: indexPath
    /// )
    /// ```
    func dd_dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass viewType: T.Type, for indexPath: IndexPath) -> T {
        guard let reusableView = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewType.dd_identifier(), for: indexPath) as? T else {
            fatalError("未找到对应类型的 UICollectionReusableView: \(String(describing: viewType))，请确保已注册")
        }
        return reusableView
    }
}

// MARK: - 移动
public extension UICollectionView {
    /// 开启 Item 移动功能（添加长按手势）
    /// - 说明：该方法会为 `UICollectionView` 添加一个长按手势识别器，以支持长按移动功能。
    /// 当长按某个项时，会启动拖拽移动效果。
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_allowMoveItem()
    /// ```
    func dd_allowMoveItem() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(UICollectionView.dd_longPressGRHandler(_:)))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }

    /// 禁止 Item 移动功能（移除长按手势）
    /// - 说明：该方法会移除 `UICollectionView` 中的长按手势识别器，禁止长按拖拽功能。
    /// 这意味着用户不能通过长按来移动单元格。
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_disableMoveItem()
    /// ```
    func dd_disableMoveItem() {
        _ = self.gestureRecognizers?.map {
            if let gestureRecognizer = $0 as? UILongPressGestureRecognizer {
                self.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
}

// MARK: - 私有事件处理
private extension UICollectionView {
    /// 长按手势处理方法
    /// - Parameter gestureRecognizer: 触发的长按手势
    /// - 说明：这是长按手势的回调方法，处理长按开始、移动、结束以及取消的状态。
    ///
    /// - 当手势状态为 `.began` 时，开始拖拽对应的 item。
    /// - 当手势状态为 `.changed` 时，更新拖拽的位置。
    /// - 当手势状态为 `.ended` 时，结束拖拽。
    /// - 当手势状态为 `.cancelled` 或其他异常状态时，取消拖拽操作。
    ///
    /// 示例：
    /// ```swift
    /// // 触发长按手势，开始处理
    /// collectionView.dd_longPressGRHandler(gestureRecognizer)
    /// ```
    @objc func dd_longPressGRHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
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

// MARK: - Creatable
public extension Creatable where Self: UICollectionView {
    @MainActor
    static func create() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }

    @MainActor
    static func `default`() -> UICollectionView {
        let collectionView = Self.create()
        return collectionView
    }
}

// MARK: - 链式语法
public extension UICollectionView {
    /// 设置 `delegate` 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_delegate(self)
    /// ```
    @discardableResult
    func dd_delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `dataSource` 代理
    /// - Parameter dataSource: 数据源对象
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_dataSource(self)
    /// ```
    @discardableResult
    func dd_dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 注册 `UICollectionViewCell` (类名方式)
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_register(MyCustomCell.self)
    /// ```
    @discardableResult
    func dd_register<T: UICollectionViewCell>(_ cell: T.Type) -> Self {
        self.dd_register(cellWithClass: T.self)
        return self
    }

    /// 设置 `UICollectionView` 布局
    /// - Parameters:
    ///   - layout: 新的布局
    ///   - animated: 是否启用动画
    ///   - completion: 布局设置完成后的回调
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_setCollectionViewLayout(newLayout, animated: true) { success in
    ///     // 布局设置完成后的处理
    /// }
    /// ```
    @discardableResult
    func dd_setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> Self {
        self.setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 设置键盘消失模式
    /// - Parameter mode: 键盘消失模式
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_keyboardDismissMode(.onDrag)
    /// ```
    @discardableResult
    func dd_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.keyboardDismissMode = mode
        return self
    }

    /// 滚动到指定的 `IndexPath`
    /// - Parameters:
    ///   - indexPath: 要滚动到的 `IndexPath`
    ///   - scrollPosition: 滚动的位置
    ///   - animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_scrollTo(IndexPath(item: 0, section: 0))
    /// ```
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

    /// 滚动到指定的 `CGRect` 区域
    /// - Parameters:
    ///   - rect: 要滚动到的区域
    ///   - animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_scrollRectToVisible(CGRect(x: 0, y: 100, width: 200, height: 200))
    /// ```
    @discardableResult
    func dd_scrollRectToVisible(_ rect: CGRect, animated: Bool = true) -> Self {
        guard rect.maxY <= self.dd_bottom else { return self }
        self.scrollRectToVisible(rect, animated: animated)
        return self
    }

    /// 滚动到顶部
    /// - Parameter animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_scrollToTop(animated: true)
    /// ```
    @discardableResult
    func dd_scrollToTop(animated: Bool = true) -> Self {
        self.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 滚动到底部
    /// - Parameter animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_scrollToBottom(animated: true)
    /// ```
    @discardableResult
    func dd_scrollToBottom(animated: Bool = true) -> Self {
        let y = contentSize.height - frame.size.height
        if y < 0 { return self }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    /// 设置 `UICollectionView` 的 `contentOffset`
    /// - Parameters:
    ///   - contentOffset: 新的 `contentOffset` 值
    ///   - animated: 是否启用动画
    /// - Returns: 返回当前 `UICollectionView` 实例，以支持链式调用
    ///
    /// 示例：
    /// ```swift
    /// collectionView.dd_setContentOffset(CGPoint(x: 0, y: 200))
    /// ```
    @discardableResult
    func dd_setContentOffset(_ contentOffset: CGPoint = .zero, animated: Bool = true) -> Self {
        self.setContentOffset(contentOffset, animated: animated)
        return self
    }
}
