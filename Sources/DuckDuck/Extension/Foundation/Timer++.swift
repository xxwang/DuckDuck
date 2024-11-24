//
//  Timer++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 22/11/2024.
//

import Foundation

// MARK: - Timer 构造方法扩展
public extension Timer {
    /// 创建一个可配置运行模式的定时器（立即执行）
    ///
    /// - Note: 需要手动调用 `fire()` 启动定时器
    /// - Parameters:
    ///   - timeInterval: 定时间隔
    ///   - repeats: 是否重复执行
    ///   - mode: 定时器运行的 `RunLoop` 模式
    ///   - block: 定时器触发时的回调闭包
    ///
    /// 示例:
    /// ```swift
    /// let timer = Timer(timeInterval: 2.0, repeats: true, mode: .common) { timer in
    ///     print("Timer fired!")
    /// }
    /// timer.fire() // 启动定时器
    /// ```
    convenience init(timeInterval: TimeInterval,
                     repeats: Bool,
                     mode: RunLoop.Mode,
                     block: @escaping @Sendable (Timer) -> Void)
    {
        self.init(timeInterval: timeInterval,
                  repeats: repeats,
                  block: block)
        RunLoop.current.add(self, forMode: mode)
    }

    /// 创建一个延时执行的定时器
    ///
    /// - Note: 不需要调用 `fire()`，定时器会按指定时间自动触发
    /// - Parameters:
    ///   - date: 定时器触发的初始时间
    ///   - timeInterval: 定时间隔
    ///   - repeats: 是否重复执行
    ///   - mode: 定时器运行的 `RunLoop` 模式
    ///   - block: 定时器触发时的回调闭包
    ///
    /// 示例:
    /// ```swift
    /// let startDate = Date().addingTimeInterval(5) // 5秒后开始
    /// let timer = Timer(startDate: startDate, timeInterval: 2.0, repeats: true, mode: .common) { timer in
    ///     print("Delayed Timer fired!")
    /// }
    /// ```
    convenience init(startDate date: Date,
                     timeInterval: TimeInterval,
                     repeats: Bool,
                     mode: RunLoop.Mode,
                     block: @escaping @Sendable (Timer) -> Void)
    {
        self.init(fire: date,
                  interval: timeInterval,
                  repeats: repeats,
                  block: block)
        RunLoop.current.add(self, forMode: mode)
    }
}

// MARK: - Timer 静态方法
public extension Timer {
    /// 创建并立即启动的定时器
    ///
    /// - Note: 自动启动，无需调用 `fire()` 或手动加入 `RunLoop`
    /// - Parameters:
    ///   - timeInterval: 定时间隔
    ///   - repeats: 是否重复执行
    ///   - block: 定时器触发时的回调闭包
    /// - Returns: 返回已启动的定时器对象
    ///
    /// 示例:
    /// ```swift
    /// let timer = Timer.dd_scheduled(timeInterval: 1.0, repeats: true) { timer in
    ///     print("Timer fired!")
    /// }
    /// ```
    @discardableResult
    static func dd_scheduled(timeInterval: TimeInterval,
                             repeats: Bool,
                             block: @escaping @Sendable (Timer) -> Void) -> Timer
    {
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                         repeats: repeats,
                                         block: block)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }

    /// 创建一个只触发一次的定时器
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - block: 定时器触发时的回调
    static func dd_after(_ delay: TimeInterval, block: @Sendable @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            block()
        }
    }

    /// 创建一个不会造成循环引用的定时器
    /// - Parameters:
    ///   - timeInterval: 定时间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行的闭包
    /// - Returns: 创建的定时器对象
    static func dd_weakScheduledTimer(timeInterval: TimeInterval,
                                      repeats: Bool,
                                      block: @Sendable @escaping () -> Void) -> Timer
    {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) { _ in
            block()
        }
    }
}

// MARK: - 倒计时
public extension Timer {
    /// 创建一个倒计时定时器
    /// - Parameters:
    ///   - duration: 倒计时总秒数
    ///   - onTick: 每次倒计时触发的回调
    ///   - onFinish: 倒计时完成后的回调
    /// - Returns: 创建的定时器
    @discardableResult
    static func countdown(duration: TimeInterval,
                          onTick: @escaping @Sendable (TimeInterval) -> Void,
                          onFinish: @escaping @Sendable () -> Void) -> Timer
    {
        // 使用 actor 来保护状态，确保线程安全
        actor CountdownState {
            private var remainingTime: TimeInterval

            init(seconds: TimeInterval) {
                self.remainingTime = seconds
            }

            func decrement() -> TimeInterval {
                if remainingTime > 0 {
                    remainingTime -= 1
                }
                return remainingTime
            }

            func getRemainingTime() -> TimeInterval {
                return remainingTime
            }
        }

        // 创建倒计时状态的实例
        let state = CountdownState(seconds: duration)

        // 创建定时器
        let timer = Timer(timeInterval: 1.0, repeats: true) { _ in
            // 异步获取剩余时间，并更新倒计时
            Task {
                let remaining = await state.decrement()

                // 倒计时结束，停止定时器并调用完成回调
                if remaining <= 0 {
                    await MainActor.run {
                        onFinish()
                    }
                } else {
                    // 每秒触发 onTick 回调
                    await MainActor.run {
                        onTick(remaining)
                    }
                }
            }
        }

        // 将定时器添加到 RunLoop
        RunLoop.current.add(timer, forMode: .common)

        return timer
    }
}

// MARK: - 基础功能
public extension Timer {
    /// 暂停定时器
    func dd_pause() {
        guard self.isValid else { return }
        self.fireDate = .distantFuture
    }

    /// 恢复定时器
    func dd_resume() {
        guard self.isValid else { return }
        self.fireDate = Date()
    }

    /// 恢复定时器，并延迟指定时间
    /// - Parameter interval: 延迟时间
    func dd_resumeAfterDelay(_ interval: TimeInterval) {
        guard self.isValid else { return }
        self.fireDate = Date().addingTimeInterval(interval)
    }
}

// MARK: - 链式调用
public extension Timer {
    /// 设置定时器的运行模式
    /// - Parameter mode: `RunLoop`模式
    /// - Returns: 当前定时器，支持链式调用
    @discardableResult
    func dd_mode(_ mode: RunLoop.Mode) -> Timer {
        RunLoop.current.add(self, forMode: mode)
        return self
    }

    /// 启动定时器
    /// - Returns: 当前定时器，支持链式调用
    @discardableResult
    func dd_start() -> Timer {
        self.fire()
        return self
    }
}
