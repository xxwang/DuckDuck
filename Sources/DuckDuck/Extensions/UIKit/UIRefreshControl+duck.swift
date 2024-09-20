//
//  UIRefreshControl+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: -  方法
public extension UIRefreshControl {
    /// 在`UITableView`开始刷新控件
    ///
    /// - Parameters:
    ///   - tableView:`UITableView`实例,其中包含刷新控件
    ///   - animated:布尔值,表示内容偏移是否应设置动画
    ///   - sendAction:表示应该为`valueChanged`事件触发`UIControl`的`sendActions`方法
    func dd_beginRefreshing(in tableView: UITableView, animated: Bool, sendAction: Bool = false) {
        assert(superview == tableView, "Refresh control does not belong to the receiving table view")

        self.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -frame.height)
        tableView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            self.sendActions(for: .valueChanged)
        }
    }

    /// 在`UIScrollView`中开始刷新控件
    ///
    /// - Parameters:
    ///   - animated:布尔值,表示内容偏移是否应设置动画
    ///   - sendAction:表示应该为`valueChanged`事件触发`UIControl`的`sendActions`方法
    func dd_beginRefreshing(animated: Bool, sendAction: Bool = false) {
        guard let scrollView = superview as? UIScrollView else {
            assertionFailure("Refresh control does not belong to a scroll view")
            return
        }

        beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -frame.height)
        scrollView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            self.sendActions(for: .valueChanged)
        }
    }
}
