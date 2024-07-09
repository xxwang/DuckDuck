//
//  UIBezierPath+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - Defaultable
extension UIBezierPath: Defaultable {
    public typealias Associatedtype = UIBezierPath

    @objc open class func `default`() -> Associatedtype {
        return UIBezierPath()
    }
}

// MARK: - 链式语法
public extension UIBezierPath {}
