//
//  UIDatePicker+chain.swift
//  DuckDuck
//
//  Created by 王哥 on 25/11/2024.
//

import UIKit

// MARK: - 链式语法
@MainActor
public extension DDExtension where Base: UIDatePicker {
    /// 设置时区
    /// - Parameter timeZone:时区
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.timeZone(TimeZone(abbreviation: "PST")!)
    /// ```
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> Self {
        self.base.timeZone = timeZone
        return self
    }

    /// 设置模式
    /// - Parameter datePickerMode:模式
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.datePickerMode(.date)
    /// ```
    @discardableResult
    func datePickerMode(_ datePickerMode: UIDatePicker.Mode) -> Self {
        self.base.datePickerMode = datePickerMode
        return self
    }

    /// 设置样式
    /// - Parameter preferredDatePickerStyle:样式
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// if #available(iOS 13.4, *) {
    ///     let datePicker = UIDatePicker()
    ///     datePicker.dd.preferredDatePickerStyle(.inline)
    /// }
    /// ```
    @discardableResult
    @available(iOS 13.4, *)
    func preferredDatePickerStyle(_ preferredDatePickerStyle: UIDatePickerStyle) -> Self {
        self.base.preferredDatePickerStyle = preferredDatePickerStyle
        return self
    }

    /// 是否高亮今天
    /// - Parameter highlightsToday:是否高亮今天
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.highlightsToday(true)
    /// ```
    @discardableResult
    func highlightsToday(_ highlightsToday: Bool) -> Self {
        self.base.setValue(highlightsToday, forKey: "highlightsToday")
        return self
    }

    /// 设置文字颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.textColor(.red)
    /// ```
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        self.base.setValue(textColor, forKeyPath: "textColor")
        return self
    }

    /// 设置日期
    /// - Parameter date:日期
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.date(Date())
    /// ```
    @discardableResult
    func date(_ date: Date) -> Self {
        self.base.date = date
        return self
    }

    /// 设置最小日期
    /// - Parameter minimumDate:最小日期
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.minimumDate(Date())
    /// ```
    @discardableResult
    func minimumDate(_ minimumDate: Date?) -> Self {
        self.base.minimumDate = minimumDate
        return self
    }

    /// 设置最大日期
    /// - Parameter maximumDate:最大日期
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.maximumDate(Date().addingTimeInterval(60*60*24*365)) // 一年后的日期
    /// ```
    @discardableResult
    func maximumDate(_ maximumDate: Date?) -> Self {
        self.base.maximumDate = maximumDate
        return self
    }

    /// 设置日期选择器的行数
    /// - Parameter minuteInterval:分钟间隔
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.minuteInterval(5)
    /// ```
    @discardableResult
    func minuteInterval(_ minuteInterval: Int) -> Self {
        self.base.minuteInterval = minuteInterval
        return self
    }

    /// 设置是否启用自动显示日历
    /// - Parameter showsCalendar:是否显示日历
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.showsCalendar(false)
    /// ```
    @discardableResult
    func showsCalendar(_ showsCalendar: Bool) -> Self {
        self.base.setValue(showsCalendar, forKey: "showsCalendar")
        return self
    }

    /// 设置区域（Locale）
    /// - Parameter locale: 区域设置
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.locale(Locale(identifier: "en_US"))
    /// ```
    @discardableResult
    func locale(_ locale: Locale) -> Self {
        self.base.locale = locale
        return self
    }

    /// 设置日历（Calendar）
    /// - Parameter calendar: 日历类型
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.calendar(Calendar(identifier: .gregorian))
    /// ```
    @discardableResult
    func calendar(_ calendar: Calendar) -> Self {
        self.base.calendar = calendar
        return self
    }

    /// 设置倒计时时长（CountDownDuration）
    /// - Parameter countDownDuration: 倒计时时长（秒）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.countDownDuration(60 * 5) // 5分钟
    /// ```
    @discardableResult
    func countDownDuration(_ countDownDuration: TimeInterval) -> Self {
        self.base.countDownDuration = countDownDuration
        return self
    }

    /// 设置是否将时间四舍五入到最接近的分钟
    /// - Parameter roundsToMinuteInterval: 是否四舍五入
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.roundsToMinuteInterval(true)
    /// ```
    @discardableResult
    func roundsToMinuteInterval(_ roundsToMinuteInterval: Bool) -> Self {
        self.base.roundsToMinuteInterval = roundsToMinuteInterval
        return self
    }

    /// 设置日期选择器的日期
    /// - Parameters:
    ///   - date: 设置的日期
    ///   - animated: 是否动画效果
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd.setDate(Date(), animated: true)
    /// ```
    @discardableResult
    func setDate(_ date: Date, animated: Bool) -> Self {
        self.base.setDate(date, animated: animated)
        return self
    }
}
