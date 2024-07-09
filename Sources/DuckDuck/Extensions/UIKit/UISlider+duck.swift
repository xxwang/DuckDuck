//
//  UISlider+duck.swift
//
//
//  Created by 王哥 on 2024/6/25.
//

import UIKit

// MARK: - 方法
public extension DDExtension where Base: UISlider {
    /// 设置`value`值
    /// - Parameters:
    ///   - value:要设置的值
    ///   - animated:是否动画
    ///   - duration:动画时间
    ///   - completion:完成回调
    func setValue(_ value: Float, animated: Bool = true, duration: TimeInterval = 0.15, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.base.setValue(value, animated: true)
            }, completion: { _ in
                completion?()
            })
        } else {
            self.base.setValue(value, animated: false)
            completion?()
        }
    }
}

// MARK: - 关联键
private class AssociateKeys {
    static var kBlockKey = UnsafeRawPointer(bitPattern: ("UISlider" + "EventBlockKey").hashValue)
}

// MARK: - AssociatedAttributes
extension UISlider: AssociatedEventBlock {
    public typealias T = Float
    public var eventBlock: EventBlock? {
        get { AssociatedObject.get(self, &AssociateKeys.kBlockKey) as? EventBlock }
        set { AssociatedObject.set(self, &AssociateKeys.kBlockKey, newValue) }
    }

    /// 事件处理
    /// - Parameter event:事件发生者
    @objc func sliderValueChanged(_ sender: UISlider) {
        self.eventBlock?(sender.value)
    }
}


// MARK: - Defaultable
public extension UISlider {
    public typealias Associatedtype = UISlider
    open override class func `default`() -> Associatedtype {
        return UISlider()
    }
}

// MARK: - 链式语法
public extension UISlider {
    /// 设置值
    /// - Parameter value: 值
    /// - Returns: `Self`
    func dd_value(_ value: Float) -> Self {
        self.value = value
        return self
    }

    /// 设置最小值
    /// - Parameter minimumValue: 最小值
    /// - Returns: `Self`
    func dd_minimumValue(_ minimumValue: Float) -> Self {
        self.minimumValue = value
        return self
    }

    /// 设置最大值
    /// - Parameter maximumValue: 最大值
    /// - Returns: `Self`
    func dd_maximumValue(_ maximumValue: Float) -> Self {
        self.maximumValue = maximumValue
        return self
    }

    /// 设置最小值图片
    /// - Parameter minimumValueImage: 最小值图片
    /// - Returns: `Self`
    func dd_minimumValueImage(_ minimumValueImage: UIImage?) -> Self {
        self.minimumValueImage = minimumValueImage
        return self
    }

    /// 设置最大值图片
    /// - Parameter maximumValueImage: 最大值图片
    /// - Returns: `Self`
    func dd_maximumValueImage(_ maximumValueImage: UIImage?) -> Self {
        self.maximumValueImage = maximumValueImage
        return self
    }

    /// 设置是否连续
    /// - Parameter isContinuous: 是否连续
    /// - Returns: `Self`
    func dd_isContinuous(_ isContinuous: Bool) -> Self {
        self.isContinuous = isContinuous
        return self
    }

    /// 设置最小值轨道颜色
    /// - Parameter minimumTrackTintColor: 最小值轨道颜色
    /// - Returns: `Self`
    func dd_minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> Self {
        self.minimumTrackTintColor = minimumTrackTintColor
        return self
    }

    /// 设置最大值轨道颜色
    /// - Parameter maximumTrackTintColor: 最大值轨道颜色
    /// - Returns: `Self`
    func dd_maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> Self {
        self.maximumTrackTintColor = maximumTrackTintColor
        return self
    }

    /// 设置滑动标识颜色
    /// - Parameter thumbTintColor: 滑动标识颜色
    /// - Returns: `Self`
    func dd_thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        self.thumbTintColor = thumbTintColor
        return self
    }

    /// 添加事件处理
    /// - Parameters:
    ///   - callback: 响应事件的闭包
    ///   - controlEvent: 事件类型
    /// - Returns: `Self`
    func dd_callback(_ block: ((Float?) -> Void)?, for controlEvent: UIControl.Event = .valueChanged) -> Self {
        self.eventBlock = block
        self.addTarget(self, action: #selector(sliderValueChanged), for: controlEvent)
        return self
    }
}

