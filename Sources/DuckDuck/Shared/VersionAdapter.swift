//
//  VersionAdapter.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import UIKit

public class VersionAdapter {
    /// 适配项目中所有`UIView`
    @available(iOS 12.0, *)
    static func viewAppearance(userInterfaceStyle: UIUserInterfaceStyle = .light) {
        if #available(iOS 13.0, *) {
            UIView.appearance().overrideUserInterfaceStyle = userInterfaceStyle
        }
    }

    /// 适配项目中所有`UIScrollView`
    static func scrollViewAppearance() {
        if #available(iOS 11.0, *) {
            // 取消滚动视图自动缩进
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }

    /// 适配项目中所有`UITableView`
    static func tableViewAppearance() {
        if #available(iOS 11.0, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }

        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }

    /// 适配项目中所有`UINavigationBar`
    static func navigationBarAppearance() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = UIColor.clear
            navigationBarAppearance.backgroundEffect = nil
            navigationBarAppearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            ]
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        }
    }
}

// MARK: - UIView
public extension UIView {
    /// 适配当前`UIView`
    @available(iOS 12.0, *)
    func viewAppearance(userInterfaceStyle: UIUserInterfaceStyle) {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
}

// MARK: - UIScrollView
public extension UIScrollView {
    /// 适配当前`UIScrollView`
    func scrollViewAppearance() {
        if #available(iOS 11.0, *) {
            // 取消滚动视图自动缩进
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

// MARK: - UITableView
public extension UITableView {
    /// 适配当前`UITableView`
    func tableViewAppearance() {
        if #available(iOS 11, *) {
            self.estimatedRowHeight = 0
            self.estimatedSectionFooterHeight = 0
            self.estimatedSectionHeaderHeight = 0
            self.contentInsetAdjustmentBehavior = .never
        }

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}

