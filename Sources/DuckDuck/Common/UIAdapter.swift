//
//  UIAdapter.swift
//  DuckDuck
//
//  Created by xxwang on 19/11/2024.
//

import UIKit

// MARK: - 全局外观设置
@MainActor
public class UIAdapter {
    public static let shared = UIAdapter()

    private init() {}

    /// 设置状态栏样式
    /// - Parameter statusBarStyle: 状态栏风格，默认为 `.lightContent`
    /// - Example:
    /// ```swift
    /// UIAdapter.shared.setupStatusBarStyle(statusBarStyle: .lightContent)
    /// ```
    public func setupStatusBarStyle(_ statusBarStyle: UIStatusBarStyle = .lightContent) {
        if #available(iOS 13, *) {
            UIApplication.shared.statusBarStyle = statusBarStyle
        }
    }

    /// 设置全局用户界面风格（适配项目中所有`UIView`的UI风格）
    /// - Parameter userInterfaceStyle: 用户界面风格，默认为 `.light`
    /// - Example:
    /// ```swift
    /// UIAdapter.shared.setupGlobalViewAppearance(userInterfaceStyle: .dark)
    /// ```
    @available(iOS 12.0, *)
    public func setupGlobalViewAppearance(userInterfaceStyle: UIUserInterfaceStyle = .light) {
        if #available(iOS 13.0, *) {
            UIView.appearance().overrideUserInterfaceStyle = userInterfaceStyle
        }
    }

    /// 设置全局 `UIScrollView` 外观（适配滚动视图的缩进行为）
    /// - Example:
    /// ```swift
    /// UIAdapter.shared.setScrollViewAppearance()
    /// ```
    public func setupGlobalScrollViewAppearance() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }

    /// 设置全局 `UITableView` 外观（适配表格视图的高度预估和间距）
    /// - Example:
    /// ```swift
    /// UIAdapter.shared.setupGlobalTableViewAppearance()
    /// ```
    public func setupGlobalTableViewAppearance() {
        if #available(iOS 11.0, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }

        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }

    /// 设置全局 `UINavigationBar` 外观（适配导航栏的背景样式和标题样式）
    /// - Example:
    /// ```swift
    /// UIAdapter.shared.setupGlobalNavigationBarAppearance()
    /// ```
    public func setupGlobalNavigationBarAppearance() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = UIColor.clear
            navigationBarAppearance.backgroundEffect = nil
            navigationBarAppearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            ]
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        }
    }
}

// MARK: - `UIView` 外观适配
@MainActor
public extension UIView {
    /// 设置当前 `UIView` 的外观（适配界面风格）
    /// - Parameter userInterfaceStyle: 用户界面风格，默认为 `.light`
    /// - Example:
    /// ```swift
    /// view.setupAppearance(userInterfaceStyle: .dark)
    /// ```
    @available(iOS 12.0, *)
    func setupAppearance(userInterfaceStyle: UIUserInterfaceStyle = .light) {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = userInterfaceStyle
        }
    }
}

// MARK: - `UIScrollView` 外观适配
@MainActor
public extension UIScrollView {
    /// 设置当前 `UIScrollView` 外观
    /// - Example:
    /// ```swift
    /// scrollView.setupAppearance()
    /// ```
    @objc func setupAppearance() {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

// MARK: - `UITableView` 外观适配
@MainActor
public extension UITableView {
    /// 设置当前 `UITableView` 外观
    /// - Example:
    /// ```swift
    /// tableView.setupAppearance()
    /// ```
    override func setupAppearance() {
        if #available(iOS 11.0, *) {
            self.estimatedRowHeight = 0
            self.estimatedSectionHeaderHeight = 0
            self.estimatedSectionFooterHeight = 0
            self.contentInsetAdjustmentBehavior = .never
        }

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
