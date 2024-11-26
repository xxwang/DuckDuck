//
//  Dispatch++.swift
//  DuckDuck
//
//  Created by xxwang on 20/11/2024.
//

import Dispatch
import Foundation

// MARK: - 检查方法
public extension DispatchQueue {
    /// 判断`当前队列`是否是主队列
    /// - Returns: 如果当前队列是主队列，返回`true`，否则返回`false`
    ///
    /// - Example:
    /// ```swift
    /// if DispatchQueue.dd_isMainQueue() {
    ///     print("当前是主队列")
    /// } else {
    ///     print("当前不是主队列")
    /// }
    /// ```
    static func dd_isMainQueue() -> Bool {
        let key = DispatchSpecificKey<Void>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        defer { DispatchQueue.main.setSpecific(key: key, value: nil) }
        return DispatchQueue.getSpecific(key: key) != nil
    }
}

// MARK: - 队列任务执行
public extension DispatchQueue {
    /// 在主线程异步执行任务
    /// - Parameter block: 要执行的任务
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_asyncMain {
    ///     print("主线程任务执行")
    /// }
    /// ```
    static func dd_asyncMain(_ block: @Sendable @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }

    /// 在默认的全局队列异步执行任务
    /// - Parameter block: 要执行的任务
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_asyncGlobal {
    ///     print("全局队列任务执行")
    /// }
    /// ```
    static func dd_asyncGlobal(_ block: @Sendable @escaping () -> Void) {
        DispatchQueue.global().async(execute: block)
    }

    /// 异步执行任务并设置优先级
    /// - Parameters:
    ///   - task: 要执行的任务
    ///   - qos: 设置任务的质量服务等级
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_asyncWithPriority(task: {
    ///     print("This task runs with high priority")
    /// }, qos: .userInitiated)
    /// ```
    static func dd_asyncWithPriority(task: @Sendable @escaping () -> Void, qos: DispatchQoS.QoSClass = .default) {
        DispatchQueue.global(qos: qos).async {
            task()
        }
    }

    /// 串行异步执行多个任务，并确保任务按顺序执行，且可以执行完成回调
    /// - Parameters:
    ///   - tasks: 要执行的任务数组
    ///   - completion: 所有任务执行完成后的回调
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_executeSerially(tasks: [
    ///     { print("Task 1") },
    ///     { print("Task 2") },
    ///     { print("Task 3") }
    /// ], completion: {
    ///     print("All tasks completed")
    /// })
    /// ```
    static func dd_executeSerially(tasks: [() -> Void], completion: @escaping () -> Void) {
        var currentTaskIndex = 0
        let taskCount = tasks.count

        func executeNextTask() {
            if currentTaskIndex < taskCount {
                tasks[currentTaskIndex]()
                currentTaskIndex += 1
                executeNextTask() // 递归调用，保证任务按顺序执行
            } else {
                completion() // 所有任务执行完成后回调
            }
        }

        executeNextTask()
    }

    /// 并行执行多个任务，并在所有任务完成后执行回调
    /// - Parameters:
    ///   - tasks: 要执行的任务数组
    ///   - completion: 所有任务完成后的回调
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_executeParallel(tasks: [
    ///     { print("Task 1") },
    ///     { print("Task 2") },
    ///     { print("Task 3") }
    /// ]) {
    ///     print("All tasks completed")
    /// }
    /// ```
    static func dd_executeParallel(tasks: [@Sendable () -> Void], completion: @escaping () -> Void) {
        let group = DispatchGroup()

        for task in tasks {
            group.enter()
            DispatchQueue.global().async {
                task()
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
}

// MARK: - 定时器
public extension DispatchQueue {
    /// 创建并启动一个`GCD定时器`，按指定时间间隔连续执行(定时任务)
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - handler: 每次执行的任务
    /// - Returns: 定时器对象
    ///
    /// - Example:
    /// ```swift
    /// let timer = DispatchQueue.dd_interval(1.0) { timer in
    ///     print("定时器触发")
    /// }
    /// ```
    @discardableResult
    static func dd_scheduleTimer(_ interval: TimeInterval, handler: @escaping (DispatchSourceTimer?) -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler {
            handler(timer)
        }
        timer.resume()
        return timer
    }

    /// 创建一个`倒计时定时器`
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - repeatCount: 重复次数
    ///   - handler: 每次倒计时触发的任务，返回剩余次数
    /// - Returns: 定时器对象
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_countdown(1.0, repeatCount: 5) { timer, remaining in
    ///     print("倒计时剩余次数: \(remaining)")
    ///     if remaining == 0 {
    ///         print("倒计时结束")
    ///     }
    /// }
    /// ```
    @discardableResult
    static func dd_countdown(_ interval: TimeInterval, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) -> DispatchSourceTimer? {
        guard repeatCount > 0 else { return nil }
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        var remainingCount = repeatCount
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler {
            remainingCount -= 1
            handler(timer, remainingCount)
            if remainingCount <= 0 {
                timer.cancel()
            }
        }
        timer.resume()
        return timer
    }
}

// MARK: - 延迟执行
public extension DispatchQueue {
    /// 延迟异步执行任务
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - queue: 执行任务的队列，默认为主队列
    ///   - qos: 优化级别，默认为未指定
    ///   - flags: 标识选项，默认为空
    ///   - task: 要执行的任务
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_delayExecute(delay: 2.0) {
    ///     print("延迟任务执行")
    /// }
    /// ```
    static func dd_delayExecute(
        delay: TimeInterval,
        on queue: DispatchQueue = .main,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute task: @Sendable @escaping () -> Void
    ) {
        queue.asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: task)
    }

    /// 延迟异步执行任务并可指定回调
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - task: 异步任务（可选）
    ///   - callback: 异步任务完成后的主线程回调（可选）
    /// - Returns: `DispatchWorkItem` 对象，用于手动管理任务
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_delayExecute(delay: 3.0, task: {
    ///     print("异步任务执行")
    /// }, callback: {
    ///     print("回调执行")
    /// })
    /// ```
    @discardableResult
    static func dd_delayExecute(
        delay: TimeInterval,
        task: (() -> Void)? = nil,
        callback: (() -> Void)? = nil
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: task ?? {})
        DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: workItem)
        if let callback {
            workItem.notify(queue: .main, execute: callback)
        }
        return workItem
    }
}

// MARK: - 防抖处理
public extension DispatchQueue {
    /// 防抖延时执行任务
    /// - Parameters:
    ///   - queue: 执行任务的队列，默认为主队列
    ///   - delay: 延迟时间（秒）
    ///   - task: 要执行的任务
    /// - Returns: 防抖闭包，用于触发防抖任务
    ///
    /// - Example:
    /// ```swift
    /// let debounceTask = DispatchQueue.dd_debounce(delay: 1.0) {
    ///     print("执行防抖任务")
    /// }
    /// debounceTask() // 触发任务
    /// ```
    static func dd_debounce(
        on queue: DispatchQueue = .main,
        delay: TimeInterval,
        execute task: @Sendable @escaping () -> Void
    ) -> () -> Void {
        // 使用 actor 来确保对 lastFireTime 的访问是线程安全的
        actor DebounceActor {
            var lastFireTime: DispatchTime = .now()

            // 更新 lastFireTime，并执行任务
            func updateTimeAndExecuteTask(delay: TimeInterval, queue: DispatchQueue, task: @Sendable @escaping () -> Void) {
                let currentTime = DispatchTime.now()
                let deadline = lastFireTime + delay
                if currentTime >= deadline {
                    lastFireTime = currentTime
                    queue.async {
                        task()
                    }
                }
            }
        }

        let debounceActor = DebounceActor()
        return {
            // 使用异步任务调用 actor 中的方法来处理防抖逻辑
            Task {
                await debounceActor.updateTimeAndExecuteTask(delay: delay, queue: queue, task: task)
            }
        }
    }
}

// MARK: - 私有变量
/// 用于记录唯一任务标识的数组
private nonisolated(unsafe) var onceTracker = [String]()

// MARK: - 执行一次任务
public extension DispatchQueue {
    /// 保证代码块只执行一次
    /// - Parameters:
    ///   - token: 唯一标识符
    ///   - task: 要执行的任务
    ///
    /// - Example:
    /// ```swift
    /// DispatchQueue.dd_once(token: "com.example.task") {
    ///     print("任务仅执行一次")
    /// }
    /// ```
    static func dd_once(token: String, execute task: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if onceTracker.contains(token) { return }
        onceTracker.append(token)
        task()
    }
}
