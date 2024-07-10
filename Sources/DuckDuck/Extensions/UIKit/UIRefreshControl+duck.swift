//
//  UIRefreshControl+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - Defaultable
public extension UIRefreshControl {
    typealias Associatedtype = UIRefreshControl
    override open class func `default`() -> Associatedtype {
        return UIRefreshControl()
    }
}
