//
//  UISwitch+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - Defaultable
public extension UISwitch {
    public typealias Associatedtype = UISwitch
    open override class func `default`() -> Associatedtype {
        return UISwitch()
    }
}

// MARK: - 链式语法
public extension UISwitch {
    /// 切换开关状态
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dd_toggle(animated: Bool = true) -> Self {
        self.setOn(!self.isOn, animated: animated)
        return self
    }
}
