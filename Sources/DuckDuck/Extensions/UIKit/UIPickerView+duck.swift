//
//  UIPickerView+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 链式语法
public extension UIPickerView {
    /// 设置代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func dd_delegate(_ delegate: UIPickerViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置数据源
    /// - Parameter dataSource: 数据源
    /// - Returns: `Self`
    @discardableResult
    func dd_dataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
}
