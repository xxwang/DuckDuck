//
//  Timer+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 构造方法
public extension Timer {
    /// 构建一个立即执行的定时器
    ///
    /// - Note: 需要调用`fire()`
    /// - Parameters:
    ///   - timeInterval: 执行间距
    ///   - repeats: 是否重复执行
    ///   - mode: `RunLoop`模式
    ///   - block: 执行代码的`block`
    convenience init(timeInterval: TimeInterval,
                     repeats: Bool,
                     forMode mode: RunLoop.Mode,
                     block: @escaping ((Timer) -> Void))
    {
        if #available(iOS 10.0, *) {
            self.init(timeInterval: timeInterval,
                      repeats: repeats,
                      block: block)
        } else {
            self.init(timeInterval: timeInterval,
                      target: Timer.self,
                      selector: #selector(Timer.dd_timerCB(timer:)),
                      userInfo: block,
                      repeats: repeats)
        }
        RunLoop.current.add(self, forMode: mode)
    }

    /// 构建一个延时执行的定时器
    ///
    /// - Note: 不需要调用`fire()`
    /// - Parameters:
    ///   - date: 开始时间
    ///   - timeInterval: 执行间距
    ///   - repeats: 是否重复执行
    ///   - mode: `RunLoop`模式
    ///   - block: 执行代码的`block`
    convenience init(startDate date: Date,
                     timeInterval: TimeInterval,
                     repeats: Bool,
                     forMode mode: RunLoop.Mode,
                     block: @escaping ((Timer) -> Void))
    {
        if #available(iOS 10.0, *) {
            self.init(fire: date,
                      interval: timeInterval,
                      repeats: repeats,
                      block: block)
        } else {
            self.init(fireAt: date,
                      interval: timeInterval,
                      target: Timer.self,
                      selector: #selector(Timer.dd_timerCB(timer:)),
                      userInfo: block,
                      repeats: repeats)
        }
        RunLoop.current.add(self, forMode: mode)
    }
}

// MARK: - 静态方法
public extension Timer {
    /// 创建一个立即执行的定时器
    ///
    /// - Note: 不需要调用`fire()`,不需要加入`RunLoop`
    /// - Parameters:
    ///   - timeInterval: 执行间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的`block`
    /// - Returns: `Timer`对象
    @discardableResult
    static func dd_safeScheduledTimer(timeInterval: TimeInterval,
                                      repeats: Bool,
                                      block: @escaping ((Timer) -> Void)) -> Timer
    {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval,
                                        repeats: repeats,
                                        block: block)
        }
        return Timer.scheduledTimer(timeInterval: timeInterval,
                                    target: self,
                                    selector: #selector(Timer.dd_timerCB(timer:)),
                                    userInfo: block,
                                    repeats: repeats)
    }

    /// 创建C语言形式的定时器
    ///
    /// - Note: 不需要调用`fire()`,不需要加入`RunLoop`
    /// - Parameters:
    ///   - timeInterval: 执行间隔
    ///   - block: 执行代码的`block`
    /// - Returns: `Timer`对象
    @discardableResult
    static func dd_runThisEvery(timeInterval: TimeInterval,
                                block: @escaping (Timer?) -> Void) -> Timer?
    {
        let fireDate = CFAbsoluteTimeGetCurrent()
        guard let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault,
                                                          fireDate,
                                                          timeInterval,
                                                          0,
                                                          0,
                                                          block)
        else {
            return nil
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(),
                          timer,
                          CFRunLoopMode.commonModes)
        return timer
    }
}

// MARK: - 私有方法
private extension Timer {
    /// 执行`timer.userInfo`中传递的闭包的方法
    /// - Parameter timer: 定时器
    @objc class func dd_timerCB(timer: Timer) {
        if let cb = timer.userInfo as? ((Timer) -> Void) {
            cb(timer)
        } else {
            timer.invalidate()
        }
    }
}
