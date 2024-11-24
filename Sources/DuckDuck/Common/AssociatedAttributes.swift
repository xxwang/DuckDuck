//
//  AssociatedAttributes.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 23/11/2024.
//

import Foundation

// MARK: - 事件处理协议
public protocol EventHandler {
    /// 关联回调闭包参数类型
    associatedtype EventHandlerParams

    /// 回调闭包别名
    typealias EventHandlerCallback = (EventHandlerParams?) -> Void

    /// 事件处理闭包
    var onEvent: EventHandlerCallback? { get set }
}
