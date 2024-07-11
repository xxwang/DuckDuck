//
//  UICollectionReusableView+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import UIKit

// MARK: - 计算属性
public extension DDExtension where Base: UICollectionReusableView {
    /// 标识符(使用类名注册时)
    static var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Base.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }
}
