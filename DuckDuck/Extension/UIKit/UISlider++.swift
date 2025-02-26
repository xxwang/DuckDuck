import UIKit

// MARK: - 类型
extension UISlider {
    // MARK: - 关联键
    class AssociateKeys {
        static var eventKey = UnsafeRawPointer(bitPattern: ("UISlider" + "eventKey").hashValue)
    }
}

// MARK: - 事件关联
extension UISlider {
    /// 事件回调
    var slider_onEventHandler: ((Float) -> Void)? {
        get { AttributeBinder.retrieve(self, forKey: &AssociateKeys.eventKey) }
        set { AttributeBinder.bind(to: self, withKey: &AssociateKeys.eventKey, value: newValue) }
    }

    /// 事件处理
    /// - Parameter event: 事件发生者
    /// 处理 `UISlider` 值改变的事件。
    @objc func dd_sliderValueChanged(_ sender: UISlider) {
        self.slider_onEventHandler?(sender.value)
    }
}

// MARK: - 方法
public extension UISlider {
    /// 设置`value`值
    /// - Parameters:
    ///   - value: 要设置的值
    ///   - animated: 是否动画
    ///   - duration: 动画时间
    ///   - completion: 完成回调
    ///
    /// 示例：
    /// ```swift
    /// slider.dd_value(0.5, animated: true, duration: 0.3) {
    ///     // 动画完成后的回调
    /// }
    /// ```
    func dd_value(_ value: Float, animated: Bool = true, duration: TimeInterval = 0.15, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.setValue(value, animated: true)
            }, completion: { _ in
                completion?()
            })
        } else {
            self.setValue(value, animated: false)
            completion?()
        }
    }
}

// MARK: - 链式语法
public extension UISlider {
    /// 设置值
    /// - Parameter value: 设置的值
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_value(0.7)
    /// ```
    func dd_value(_ value: Float) -> Self {
        self.value = value
        return self
    }

    /// 设置最小值
    /// - Parameter minimumValue: 设置的最小值
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_minimumValue(0.0)
    /// ```
    func dd_minimumValue(_ minimumValue: Float) -> Self {
        self.minimumValue = minimumValue
        return self
    }

    /// 设置最大值
    /// - Parameter maximumValue: 设置的最大值
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_maximumValue(1.0)
    /// ```
    func dd_maximumValue(_ maximumValue: Float) -> Self {
        self.maximumValue = maximumValue
        return self
    }

    /// 设置最小值图片
    /// - Parameter minimumValueImage: 设置的最小值图片
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_minimumValueImage(UIImage(named: "minImage"))
    /// ```
    func dd_minimumValueImage(_ minimumValueImage: UIImage?) -> Self {
        self.minimumValueImage = minimumValueImage
        return self
    }

    /// 设置最大值图片
    /// - Parameter maximumValueImage: 设置的最大值图片
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_maximumValueImage(UIImage(named: "maxImage"))
    /// ```
    func dd_maximumValueImage(_ maximumValueImage: UIImage?) -> Self {
        self.maximumValueImage = maximumValueImage
        return self
    }

    /// 设置是否连续
    /// - Parameter isContinuous: 是否连续
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_isContinuous(true)
    /// ```
    func dd_isContinuous(_ isContinuous: Bool) -> Self {
        self.isContinuous = isContinuous
        return self
    }

    /// 设置最小值轨道颜色
    /// - Parameter minimumTrackTintColor: 最小值轨道颜色
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_minimumTrackTintColor(.blue)
    /// ```
    func dd_minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> Self {
        self.minimumTrackTintColor = minimumTrackTintColor
        return self
    }

    /// 设置最大值轨道颜色
    /// - Parameter maximumTrackTintColor: 最大值轨道颜色
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_maximumTrackTintColor(.gray)
    /// ```
    func dd_maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> Self {
        self.maximumTrackTintColor = maximumTrackTintColor
        return self
    }

    /// 设置滑动标识颜色
    /// - Parameter thumbTintColor: 滑动标识颜色
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_thumbTintColor(.red)
    /// ```
    func dd_thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        self.thumbTintColor = thumbTintColor
        return self
    }

    /// 添加事件处理
    /// - Parameters:
    ///   - closure: 响应事件的闭包
    ///   - controlEvent: 事件类型
    /// - Returns: `Self`
    /// 示例：
    /// ```swift
    /// slider.dd_closure({ value in
    ///     print("Slider value changed: \(value)")
    /// })
    /// ```
    func dd_onEvent(_ handler: ((Float) -> Void)?, for controlEvent: UIControl.Event = .valueChanged) -> Self {
        self.slider_onEventHandler = handler
        self.addTarget(self, action: #selector(dd_sliderValueChanged), for: controlEvent)
        return self
    }
}
