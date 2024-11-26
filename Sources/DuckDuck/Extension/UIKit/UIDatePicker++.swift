//
//  UIDatePicker++.swift
//  DuckDuck
//
//  Created by xxwang on 23/11/2024.
//

import UIKit

// MARK: - 链式语法
public extension UIDatePicker {
    /// 设置时区
    /// - Parameter timeZone:时区
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_timeZone(TimeZone(abbreviation: "PST")!)
    /// ```
    @discardableResult
    func dd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置模式
    /// - Parameter datePickerMode:模式
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_datePickerMode(.date)
    /// ```
    @discardableResult
    func dd_datePickerMode(_ datePickerMode: UIDatePicker.Mode) -> Self {
        self.datePickerMode = datePickerMode
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
    ///     datePicker.dd_preferredDatePickerStyle(.inline)
    /// }
    /// ```
    @discardableResult
    @available(iOS 13.4, *)
    func dd_preferredDatePickerStyle(_ preferredDatePickerStyle: UIDatePickerStyle) -> Self {
        self.preferredDatePickerStyle = preferredDatePickerStyle
        return self
    }

    /// 是否高亮今天
    /// - Parameter highlightsToday:是否高亮今天
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_highlightsToday(true)
    /// ```
    @discardableResult
    func dd_highlightsToday(_ highlightsToday: Bool) -> Self {
        self.setValue(highlightsToday, forKey: "highlightsToday")
        return self
    }

    /// 设置文字颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_textColor(.red)
    /// ```
    @discardableResult
    func dd_textColor(_ textColor: UIColor) -> Self {
        self.setValue(textColor, forKeyPath: "textColor")
        return self
    }

    /// 设置日期
    /// - Parameter date:日期
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_date(Date())
    /// ```
    @discardableResult
    func dd_date(_ date: Date) -> Self {
        self.date = date
        return self
    }

    /// 设置最小日期
    /// - Parameter minimumDate:最小日期
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_minimumDate(Date())
    /// ```
    @discardableResult
    func dd_minimumDate(_ minimumDate: Date?) -> Self {
        self.minimumDate = minimumDate
        return self
    }

    /// 设置最大日期
    /// - Parameter maximumDate:最大日期
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_maximumDate(Date().addingTimeInterval(60*60*24*365)) // 一年后的日期
    /// ```
    @discardableResult
    func dd_maximumDate(_ maximumDate: Date?) -> Self {
        self.maximumDate = maximumDate
        return self
    }

    /// 设置日期选择器的行数
    /// - Parameter minuteInterval:分钟间隔
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_minuteInterval(5)
    /// ```
    @discardableResult
    func dd_minuteInterval(_ minuteInterval: Int) -> Self {
        self.minuteInterval = minuteInterval
        return self
    }

    /// 设置是否启用自动显示日历
    /// - Parameter showsCalendar:是否显示日历
    /// - Returns:`Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_showsCalendar(false)
    /// ```
    @discardableResult
    func dd_showsCalendar(_ showsCalendar: Bool) -> Self {
        self.setValue(showsCalendar, forKey: "showsCalendar")
        return self
    }

    /// 设置区域（Locale）
    /// - Parameter locale: 区域设置
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_locale(Locale(identifier: "en_US"))
    /// ```
    @discardableResult
    func dd_locale(_ locale: Locale) -> Self {
        self.locale = locale
        return self
    }

    /// 设置日历（Calendar）
    /// - Parameter calendar: 日历类型
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_calendar(Calendar(identifier: .gregorian))
    /// ```
    @discardableResult
    func dd_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }

    /// 设置倒计时时长（CountDownDuration）
    /// - Parameter countDownDuration: 倒计时时长（秒）
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_countDownDuration(60 * 5) // 5分钟
    /// ```
    @discardableResult
    func dd_countDownDuration(_ countDownDuration: TimeInterval) -> Self {
        self.countDownDuration = countDownDuration
        return self
    }

    /// 设置是否将时间四舍五入到最接近的分钟
    /// - Parameter roundsToMinuteInterval: 是否四舍五入
    /// - Returns: `Self`
    ///
    /// 示例：
    /// ```swift
    /// let datePicker = UIDatePicker()
    /// datePicker.dd_roundsToMinuteInterval(true)
    /// ```
    @discardableResult
    func dd_roundsToMinuteInterval(_ roundsToMinuteInterval: Bool) -> Self {
        self.roundsToMinuteInterval = roundsToMinuteInterval
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
    /// datePicker.dd_setDate(Date(), animated: true)
    /// ```
    @discardableResult
    func dd_setDate(_ date: Date, animated: Bool) -> Self {
        self.setDate(date, animated: animated)
        return self
    }
}
