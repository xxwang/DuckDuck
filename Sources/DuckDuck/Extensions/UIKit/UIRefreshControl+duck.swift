//
//  UIRefreshControl+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - Defaultable
public extension UIRefreshControl {
    public typealias Associatedtype = UIRefreshControl
    open override class func `default`() -> Associatedtype {
        return UIRefreshControl()
    }
}
