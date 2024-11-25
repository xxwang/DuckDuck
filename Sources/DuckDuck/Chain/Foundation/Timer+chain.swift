//
//  Timer+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import Foundation

extension Timer: DDExtensionable {}

// MARK: - 链式语法
public extension DDExtension where Base: Timer {
    /// 设置定时器的运行模式
    /// - Parameter mode: `RunLoop`模式
    /// - Returns: 当前定时器，支持链式调用
    @discardableResult
    func mode(_ mode: RunLoop.Mode) -> Self {
        RunLoop.current.add(self.base, forMode: mode)
        return self
    }

    /// 启动定时器
    /// - Returns: 当前定时器，支持链式调用
    @discardableResult
    func start() -> Self {
        self.base.fire()
        return self
    }
}
