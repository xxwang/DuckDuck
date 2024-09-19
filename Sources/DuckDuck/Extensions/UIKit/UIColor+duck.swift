//
//  UIColor+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import UIKit

// MARK: - 计算属性
public extension UIColor {
    /// 生成一个随机颜色
    static func dd_random() -> UIColor {
        let red = Int.random(in: 0 ... 255)
        let green = Int.random(in: 0 ... 255)
        let blue = Int.random(in: 0 ... 255)
        return UIColor(dd_red: red.dd.as2CGFloat, dd_green: green.dd.as2CGFloat, dd_blue: blue.dd.as2CGFloat)!
    }

    /// (设置/获取)颜色的透明度
    var dd_alpha: CGFloat {
        get { self.cgColor.alpha }
        set { self.withAlphaComponent(newValue) }
    }
}

// MARK: - 构造方法
public extension UIColor {
    /// 使用`十六进制颜色字符串`创建`UIColor`
    /// - Parameters:
    ///   - string: 十六进制颜色字符串
    ///   - alpha: 透明度
    convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex

        guard hex.count == 3 || hex.count == 6 else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }

        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        let scanner = Scanner(string: hex)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x0000_00FF
        let red = Int(color >> 16) & mask
        let green = Int(color >> 8) & mask
        let blue = Int(color) & mask
        self.init(dd_red: red.dd.as2CGFloat, dd_green: green.dd.as2CGFloat, dd_blue: blue.dd.as2CGFloat, dd_alpha: alpha)!
    }

    /// 使用`十六进制ARGB颜色字符串`创建`UIColor`
    /// - Parameters:
    ///   - string: `十六进制ARGB`颜色字符串(例如:7FEDE7F6、0x7FEDE7F6、#7FEDE7F6、#f0ff、0xFF0F)
    convenience init?(hexARGB string: String) {
        // 移除字符串中的"0x"和"#"
        var string = string.replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "#", with: "")

        if string.count <= 4 {
            var str = ""
            for character in string {
                str.append(String(repeating: String(character), count: 2))
            }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        let hasAlpha = string.count == 8
        let alpha = hasAlpha ? (hexValue >> 24) & 0xFF : 0xFF
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF

        self.init(red: red.dd.as2CGFloat, green: green.dd.as2CGFloat, blue: blue.dd.as2CGFloat, alpha: alpha.dd.as2CGFloat / 255)
    }

    /// 使用16进制值和透明度创建`UIColor`
    /// - Parameters:
    ///   - int: 16进制`Int`值
    ///   - alpha: 透明度
    convenience init(hex int: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((int & 0xFF0000) >> 16)
        let green = CGFloat((int & 0xFF00) >> 8)
        let blue = CGFloat(int & 0xFF)
        self.init(dd_red: red, dd_green: green, dd_blue: blue, dd_alpha: alpha)!
    }

    /// 使用`RGBA`创建`UIColor`(0-255)
    ///
    /// - Parameters:
    ///   - red: 红色
    ///   - green: 绿色
    ///   - blue: 蓝色
    ///   - transparency:透明度
    convenience init?(dd_red: CGFloat, dd_green: CGFloat, dd_blue: CGFloat, dd_alpha: CGFloat = 1.0) {
        guard dd_red >= 0, dd_red <= 255 else { return nil }
        guard dd_green >= 0, dd_green <= 255 else { return nil }
        guard dd_blue >= 0, dd_blue <= 255 else { return nil }

        var alpha = dd_alpha
        if alpha < 0 { alpha = 0 }
        if alpha > 1 { alpha = 1 }
        self.init(red: dd_red / 255.0, green: dd_green / 255.0, blue: dd_blue / 255.0, alpha: alpha)
    }
}

// MARK: - 方法
public extension UIColor {}

// MARK: - 链式语法
public extension UIColor {
    /// 设置颜色透明度
    /// - Parameter value:要设置的透明度
    /// - Returns:`UIColor`
    func dd_withAlphaComponent(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
}
