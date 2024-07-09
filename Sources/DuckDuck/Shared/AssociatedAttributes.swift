//
//  AssociatedAttributes.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import Foundation

// MARK: - 关联事件回调属性
public protocol AssociatedEventBlock {
    associatedtype T
    typealias EventBlock = (T?) -> Void
    var eventBlock: EventBlock? { get set }
}
