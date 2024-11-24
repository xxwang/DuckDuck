//
//  UIColor++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 24/11/2024.
//

import CoreGraphics
import UIKit

// MARK: - 构造方法扩展
public extension UIColor {
    /// 使用十六进制颜色字符串创建 `UIColor`
    ///
    /// - Parameters:
    ///   - rgbString: 十六进制颜色字符串（支持 `#RRGGBB` 或 `RRGGBB` 格式）
    ///   - alpha: 透明度（默认值为 `1.0`）
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor(hex: "#FF5733", alpha: 0.8)
    /// ```
    convenience init(hex rgbString: String, alpha: CGFloat = 1.0) {
        var hexString = rgbString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString

        guard hexString.count == 3 || hexString.count == 6 else {
            self.init(white: 1.0, alpha: 0.0) // 返回透明颜色
            return
        }

        if hexString.count == 3 {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }

        var colorValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&colorValue)

        let mask = 0x0000_00FF
        let red = Int(colorValue >> 16) & mask
        let green = Int(colorValue >> 8) & mask
        let blue = Int(colorValue) & mask

        self.init(r: CGFloat(red), g: CGFloat(green), b: CGFloat(blue), alpha: alpha)!
    }

    /// 使用十六进制 ARGB 颜色字符串创建 `UIColor`
    ///
    /// - Parameter argbString: 十六进制 ARGB 颜色字符串（支持 `#ARGB` 或 `ARGB` 格式）
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor(hex: "#7FEDE7F6")
    /// ```
    convenience init?(hex argbString: String) {
        var string = argbString.replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "#", with: "")

        if string.count <= 4 {
            string = string.map { "\($0)\($0)" }.joined()
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        let hasAlpha = string.count == 8
        let alpha = hasAlpha ? (hexValue >> 24) & 0xFF : 0xFF
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF

        self.init(r: CGFloat(red), g: CGFloat(green), b: CGFloat(blue), alpha: CGFloat(alpha) / 255)!
    }

    /// 使用十六进制值和透明度创建 `UIColor`
    ///
    /// - Parameters:
    ///   - rgbInt: 十六进制 `Int` 值
    ///   - alpha: 透明度（默认值为 `1.0`）
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor(hex: 0xFF5733, alpha: 1.0)
    /// ```
    convenience init(hex rgbInt: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbInt & 0xFF0000) >> 16)
        let green = CGFloat((rgbInt & 0xFF00) >> 8)
        let blue = CGFloat(rgbInt & 0xFF)
        self.init(r: red, g: green, b: blue, alpha: alpha)!
    }

    /// 使用 `RGBA` 创建 `UIColor`（支持 0-255 范围值）
    ///
    /// - Parameters:
    ///   - r: 红色值
    ///   - g: 绿色值
    ///   - b: 蓝色值
    ///   - alpha: 透明度（默认值为 `1.0`）
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor((r: 255, g: 87,  b: 51, alpha: 1.0)
    /// ```
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        guard (0 ... 255).contains(r), (0 ... 255).contains(g), (0 ... 255).contains(b) else { return nil }
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }

    /// 根据给定颜色生成其互补色
    ///
    /// - Parameter color: 原始颜色
    ///
    /// 示例：
    /// ```swift
    /// let complementary = UIColor(dd_complementaryFor: UIColor.red)
    /// ```
    convenience init?(complementaryFor color: UIColor) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertToRGB: (UIColor) -> UIColor? = { color in
            if color.cgColor.colorSpace?.model == .monochrome {
                let oldComponents = color.cgColor.components ?? [0, 0]
                let newComponents = [oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]]
                return UIColor(cgColor: CGColor(colorSpace: colorSpaceRGB, components: newComponents)!)
            }
            return color
        }

        guard let rgbColor = convertToRGB(color), let components = rgbColor.cgColor.components else { return nil }

        let red = sqrt(1.0 - pow(components[0], 2.0))
        let green = sqrt(1.0 - pow(components[1], 2.0))
        let blue = sqrt(1.0 - pow(components[2], 2.0))
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    /// 为明暗模式指定不同颜色
    ///
    /// - Parameters:
    ///   - light: 浅色模式下使用的颜色
    ///   - dark: 深色模式下使用的颜色
    ///
    /// 示例：
    /// ```swift
    /// let adaptiveColor = UIColor(light: .white, dark: .black)
    /// ```
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }

    /// 创建渐变颜色的 `UIColor`
    ///
    /// - Parameters:
    ///   - size: 渐变颜色的大小（必填）
    ///   - colors: 渐变颜色数组（必填）
    ///   - locations: 渐变颜色位置数组（默认值为 `[0, 1]`）
    ///   - type: 渐变类型（默认值为 `.axial`）
    ///   - startPoint: 渐变的起点（默认值为 `.zero`）
    ///   - endPoint: 渐变的终点（默认值为 `(x: 1, y: 0)`）
    ///
    /// 示例：
    /// ```swift
    /// let gradientColor = UIColor(
    ///     size: CGSize(width: 100, height: 100),
    ///     colors: [.red, .blue],
    ///     locations: [0, 1],
    ///     startPoint: .zero,
    ///     endPoint: CGPoint(x: 1, y: 1)
    /// )
    /// ```
    convenience init?(size: CGSize,
                      colors: [UIColor],
                      locations: [CGFloat] = [0, 1],
                      type: CAGradientLayerType = .axial,
                      startPoint: CGPoint = .zero,
                      endPoint: CGPoint = CGPoint(x: 1, y: 0))
    {
        // 创建渐变图层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.locations = locations.map { NSNumber(value: Float($0)) }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.type = type

        // 渲染渐变图层为图像
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        // 使用生成的图像初始化颜色
        self.init(patternImage: gradientImage)
    }
}

// MARK: - 常用方法
public extension UIColor {
    /// 生成一个随机颜色
    ///
    /// 生成一个RGB值在0到255之间的随机颜色。
    ///
    /// - Returns: 一个随机的 `UIColor` 实例。
    ///
    /// **示例:**
    /// ```swift
    /// let randomColor = UIColor.dd_random()
    /// ```
    static func dd_random() -> UIColor {
        let red = Int.random(in: 0 ... 255)
        let green = Int.random(in: 0 ... 255)
        let blue = Int.random(in: 0 ... 255)
        return UIColor(red: red.dd_toCGFloat(), green: green.dd_toCGFloat(), blue: blue.dd_toCGFloat(), alpha: 1.0)
    }

    /// (设置/获取)颜色的透明度
    ///
    /// 获取或设置当前颜色的透明度。
    ///
    /// - Returns: 颜色的透明度 `CGFloat` 值。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let alphaValue = color.dd_alpha  // 获取透明度
    /// color.dd_alpha = 0.5  // 设置透明度为50%
    /// ```
    var dd_alpha: CGFloat {
        get { self.cgColor.alpha }
        set { self.withAlphaComponent(newValue) }
    }

    /// 获取颜色的`Int`表示
    ///
    /// 将颜色的RGB分量转换为一个整数值。
    /// 例如，RGB为(255, 0, 0)时返回的整数为 16711680。
    ///
    /// - Returns: 颜色的整数表示。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let colorInt = color.dd_toInt()  // 获取整数表示 (16711680)
    /// ```
    func dd_toInt() -> Int {
        let (red, green, blue, _) = dd_toRGBA()
        return (Int(red * 255) << 16) + (Int(green * 255) << 8) + Int(blue * 255)
    }

    /// 获取颜色的`UInt`表示
    ///
    /// 将颜色的RGB分量转换为一个无符号整数表示。
    ///
    /// - Returns: 颜色的无符号整数表示。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let colorUInt = color.dd_toUInt()  // 获取无符号整数表示
    /// ```
    func dd_toUInt() -> UInt {
        let (red, green, blue, _) = dd_toRGBA()
        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(red * 255.0) << 16
        colorAsUInt32 += UInt32(green * 255.0) << 8
        colorAsUInt32 += UInt32(blue * 255.0)
        return UInt(colorAsUInt32)
    }

    /// 十六进制颜色字符串(短)
    ///
    /// 将颜色转换为短格式的十六进制字符串，格式为 `#RGB`。
    /// 如果不能转换成短格式，则返回 `nil`。
    ///
    /// - Returns: 短格式十六进制颜色字符串，或者 `nil` 如果不能转换。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// if let shortHex = color.dd_toShortHexString() {
    ///     print(shortHex)  // 输出: #F00
    /// }
    /// ```
    func dd_toShortHexString() -> String? {
        let hex = dd_toHexString(true).replacingOccurrences(of: "#", with: "")
        let chars = Array(hex)
        guard chars[0] == chars[1], chars[2] == chars[3], chars[4] == chars[5] else { return nil }
        return "#\(chars[0])\(chars[2])\(chars[4])"
    }

    /// 优先返回短的十六进制颜色值，如果不能转换则返回长的十六进制颜色值
    ///
    /// 将颜色转换为十六进制颜色字符串，优先使用短格式，如果无法转换则返回长格式。
    ///
    /// - Returns: 十六进制颜色字符串，短格式或者长格式。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let hexString = color.dd_toShortHexOrHexString()  // 输出: #F00
    /// ```
    func dd_toShortHexOrHexString() -> String {
        let (r, g, b, _) = dd_toRGBA()
        let hexString = String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chars = Array(string)
        guard chars[0] == chars[1], chars[2] == chars[3], chars[4] == chars[5] else { return hexString }
        return "#\(chars[0])\(chars[2])\(chars[4])"
    }

    /// 返回十六进制(长)颜色值字符串
    ///
    /// 将颜色转换为十六进制字符串，默认返回格式为 `#RRGGBB`。
    ///
    /// - Parameter hashPrefix: 是否在十六进制颜色值前添加 `#` 前缀，默认值为 `true`。
    /// - Returns: 转换后的十六进制颜色字符串。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let hexString = color.dd_toHexString()  // 输出: "#FF0000"
    /// ```
    func dd_toHexString(_ hashPrefix: Bool = true) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let prefix = hashPrefix ? "#" : ""
        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    /// 把`UIColor`转成`(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)`元组
    ///
    /// 获取颜色的RGBA组件，包括透明度。
    ///
    /// - Returns: 颜色的RGBA元组。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let rgba = color.dd_toRGBA()
    /// print(rgba)  // 输出: (1.0, 0.0, 0.0, 1.0)
    /// ```
    func dd_toRGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let components = cgColor.components else { return (0, 0, 0, 1) }
        let count = cgColor.numberOfComponents
        if count == 2 {
            return (components[0], components[0], components[0], components[1]) // grayscale
        } else if count == 4 {
            return (components[0], components[1], components[2], components[3]) // RGBA
        }
        return (0, 0, 0, 1)
    }

    /// 返回HSBA模式颜色
    ///
    /// 将当前颜色转换为HSBA模式，并返回色相、饱和度、亮度和透明度。
    ///
    /// - Parameters:
    ///   - hue: 色相
    ///   - saturation: 饱和度
    ///   - brightness: 亮度
    ///   - alpha: 透明度
    ///
    /// - Returns: 包含色相、饱和度、亮度和透明度的元组。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let hsba = color.dd_toHSBA()
    /// print(hsba)  // 输出: (hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    /// ```
    func dd_toHSBA() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h * 360, s, b, a)
    }

    /// 转换为`CoreImage.CIColor`
    ///
    /// 将当前 `UIColor` 转换为 `CoreImage.CIColor` 类型。
    ///
    /// - Returns: 转换后的 `CoreImage.CIColor` 实例，或者 `nil` 如果转换失败。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// if let ciColor = color.dd_toCIColor() {
    ///     print(ciColor)  // 输出: CIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    /// }
    /// ```
    func dd_toCIColor() -> CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }

    /// 获取互补色
    ///
    /// 返回当前颜色的互补色。
    /// 互补色是指RGB模型下，通过补充当前颜色的RGB分量所获得的颜色。
    ///
    /// - Returns: 当前颜色的互补色，如果计算失败则返回 `nil`。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// if let complement = color.dd_complementaryColor() {
    ///     print(complement)  // 输出互补色
    /// }
    /// ```
    func dd_complementaryColor() -> UIColor? {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: UIColor) -> UIColor?) = { _ -> UIColor? in
            if self.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = self.cgColor.components
                let components: [CGFloat] = [oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            } else { return self }
        }

        let color = convertColorToRGBSpace(self)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[0] * 255, 2.0)) / 255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[1] * 255, 2.0)) / 255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[2] * 255, 2.0)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    /// 颜色转图片
    ///
    /// 将颜色转换为指定尺寸的图片。
    ///
    /// - Parameter size: 图片的尺寸，单位为 `CGSize`。
    /// - Returns: 转换后的 `UIImage` 实例。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.red
    /// let image = color.dd_toImage(by: CGSize(width: 100, height: 100))
    /// ```
    func dd_toImage(by size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

    /// 从字符串中提取十六进制颜色值创建`UIColor`
    ///
    /// 从给定的十六进制颜色字符串创建 `UIColor` 实例，支持带有 `#` 或 `0x` 前缀的颜色值。
    ///
    /// - Parameters:
    ///   - hex: 十六进制颜色字符串，可以带有 `#` 或 `0x` 前缀。
    ///   - alpha: 透明度值，范围为 0.0 到 1.0。
    /// - Returns: 创建的 `UIColor` 实例，如果字符串无效则返回 `UIColor.clear`。
    ///
    /// **示例:**
    /// ```swift
    /// let color = UIColor.dd_proceesHex(hex: "#FF0000", alpha: 1.0)
    /// print(color)  // 输出: UIColor.red
    /// ```
    static func dd_proceesHex(hex: String, alpha: CGFloat) -> UIColor {
        if hex.isEmpty {
            return UIColor.clear
        }

        let whitespace = NSCharacterSet.whitespacesAndNewlines
        var hHex = (hex.trimmingCharacters(in: whitespace)).uppercased()

        if hHex.count < 6 {
            return UIColor.clear
        }

        if hHex.hasPrefix("0X") || hHex.hasPrefix("##") {
            hHex = String(hHex.dropFirst(2))
        }

        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }

        if hHex.count != 6 {
            return UIColor.clear
        }

        var range = NSRange(location: 0, length: 2)

        let rHex = (hHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)

        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)

        var r: CUnsignedLongLong = 0, g: CUnsignedLongLong = 0, b: CUnsignedLongLong = 0
        Scanner(string: rHex).scanHexInt64(&r)
        Scanner(string: gHex).scanHexInt64(&g)
        Scanner(string: bHex).scanHexInt64(&b)

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    /// 混合两个颜色，返回混合后的新颜色
    /// - Parameters:
    ///   - color1: 第一个颜色
    ///   - intensity1: 第一个颜色的混合强度 (默认值为 0.5)
    ///   - color2: 第二个颜色
    ///   - intensity2: 第二个颜色的混合强度 (默认值为 0.5)
    /// - Returns: 混合后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color1 = UIColor.red
    ///   let color2 = UIColor.blue
    ///   let blendedColor = UIColor.dd_blend(color1, intensity1: 0.7, with: color2, intensity2: 0.3)
    ///   ```
    static func dd_blend(_ color1: UIColor,
                         intensity1: CGFloat = 0.5,
                         with color2: UIColor,
                         intensity2: CGFloat = 0.5) -> UIColor
    {
        let totalIntensity = intensity1 + intensity2
        let level1 = intensity1 / totalIntensity
        let level2 = intensity2 / totalIntensity

        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }

        let components1 = color1.cgColor.components ?? [0, 0, 0, 0]
        let components2 = color2.cgColor.components ?? [0, 0, 0, 0]

        let red = level1 * components1[0] + level2 * components2[0]
        let green = level1 * components1[1] + level2 * components2[1]
        let blue = level1 * components1[2] + level2 * components2[2]
        let alpha = level1 * color1.cgColor.alpha + level2 * color2.cgColor.alpha

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 以 HSB 模式混合颜色到当前颜色并返回新颜色
    /// - Parameters:
    ///   - hue: 需要添加的色调值
    ///   - saturation: 需要添加的饱和度值
    ///   - brightness: 需要添加的亮度值
    ///   - alpha: 需要添加的透明度值
    /// - Returns: 以 HSB 模式混合后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color = UIColor.red
    ///   let newColor = color.dd_addHSB(hue: 0.1, saturation: 0.2, brightness: -0.1, alpha: 0.5)
    ///   ```
    func dd_addHSB(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
        var (currentHue, currentSat, currentBrightness, currentAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getHue(&currentHue, saturation: &currentSat, brightness: &currentBrightness, alpha: &currentAlpha)

        // 确保色调不会溢出
        var newHue = currentHue + hue
        while newHue < 0.0 {
            newHue += 1.0
        }
        while newHue > 1.0 {
            newHue -= 1.0
        }

        let newBrightness = max(min(currentBrightness + brightness, 1.0), 0)
        let newSaturation = max(min(currentSat + saturation, 1.0), 0)
        let newAlpha = max(min(currentAlpha + alpha, 1.0), 0)

        return UIColor(hue: newHue, saturation: newSaturation, brightness: newBrightness, alpha: newAlpha)
    }

    /// 以 RGB 模式混合颜色到当前颜色并返回新颜色
    /// - Parameters:
    ///   - red: 需要添加的红色值
    ///   - green: 需要添加的绿色值
    ///   - blue: 需要添加的蓝色值
    ///   - alpha: 需要添加的透明度值
    /// - Returns: 以 RGB 模式混合后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color = UIColor.red
    ///   let newColor = color.dd_addRGB(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.5)
    ///   ```
    func dd_addRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        var (currentRed, currentGreen, currentBlue, currentAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getRed(&currentRed, green: &currentGreen, blue: &currentBlue, alpha: &currentAlpha)

        // 确保颜色值不会溢出
        let newRed = max(min(currentRed + red, 1.0), 0)
        let newGreen = max(min(currentGreen + green, 1.0), 0)
        let newBlue = max(min(currentBlue + blue, 1.0), 0)
        let newAlpha = max(min(currentAlpha + alpha, 1.0), 0)

        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }

    /// 以`HSB`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color: 要混合的颜色
    /// - Returns: 混合后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color1 = UIColor.red
    ///   let color2 = UIColor.blue
    ///   let mixedColor = color1.dd_addHSB(color2)
    ///   ```
    func dd_addHSB(color: UIColor) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return dd_addHSB(hue: hue, saturation: saturation, brightness: brightness, alpha: 0)
    }

    /// 以`RGB`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color: 要混合的颜色
    /// - Returns: 混合后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color1 = UIColor.red
    ///   let color2 = UIColor.blue
    ///   let mixedColor = color1.dd_addRGB(color2)
    ///   ```
    func dd_addRGB(color: UIColor) -> UIColor {
        dd_addRGB(red: color.dd_redComponent, green: color.dd_greenComponent, blue: color.dd_blueComponent, alpha: 0)
    }

    /// 以`HSBA`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color: 要混合的颜色
    /// - Returns: 混合后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color1 = UIColor.red
    ///   let color2 = UIColor.blue
    ///   let mixedColor = color1.dd_addHSBA(color2)
    ///   ```
    func dd_addHSBA(color: UIColor) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return dd_addHSB(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /// 以`RGBA`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color: 要混合的颜色
    /// - Returns: 混合后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color1 = UIColor.red
    ///   let color2 = UIColor.blue
    ///   let mixedColor = color1.dd_addRGBA(color2)
    ///   ```
    func dd_addRGBA(color: UIColor) -> UIColor {
        dd_addRGB(red: color.dd_redComponent, green: color.dd_greenComponent, blue: color.dd_blueComponent, alpha: color.dd_alphaComponent)
    }

    /// 根据`最小饱和度`调整当前颜色的饱和度
    /// - Parameter minSaturation: 最小饱和度值
    /// - Returns: 调整后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color = UIColor.red
    ///   let adjustedColor = color.dd_saturation(0.5)
    ///   ```
    func dd_saturation(_ minSaturation: CGFloat) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return saturation < minSaturation
            ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
            : self
    }

    /// 增加颜色的亮度，返回一个更亮的新颜色
    /// - Parameter percentage: 亮度增加的百分比 (0-1)
    /// - Returns: 增加亮度后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color = UIColor.red
    ///   let lighterColor = color.dd_lighten(by: 0.2)
    ///   ```
    func dd_lighten(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: min(red + percentage, 1.0),
                       green: min(green + percentage, 1.0),
                       blue: min(blue + percentage, 1.0),
                       alpha: alpha)
    }

    /// 减少颜色的亮度，使颜色变暗
    /// - Parameter percentage: 亮度减少的百分比 (0-1)
    /// - Returns: 减少亮度后的新颜色
    ///
    /// - Example:
    ///   ```swift
    ///   let color = UIColor.red
    ///   let darkerColor = color.dd_darken(by: 0.2)
    ///   ```
    func dd_darken(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: max(red - percentage, 0),
                       green: max(green - percentage, 0),
                       blue: max(blue - percentage, 0),
                       alpha: alpha)
    }
}

// MARK: - 颜色判断
public extension UIColor {
    /// 判断颜色是否为暗色
    ///
    /// 使用 `0.2126 * R + 0.7152 * G + 0.0722 * B` 的公式计算亮度，如果亮度值小于0.5，则为暗色。
    /// - Returns: `true` 如果颜色是暗色，`false` 否则
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.black
    /// let isDark = color.dd_isDark // true
    /// ```
    var dd_isDark: Bool {
        let RGB = dd_toRGBComponents()
        return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
    }

    /// 判断颜色是否为黑色或白色
    ///
    /// 如果颜色的 RGB 值在接近黑色或接近白色的范围内，则返回 `true`。
    /// - Returns: `true` 如果颜色为黑色或白色，`false` 否则
    ///
    /// 示例：
    /// ```swift
    /// let color1 = UIColor.white
    /// let color2 = UIColor.darkGray
    /// print(color1.dd_isBlackOrWhite) // true
    /// print(color2.dd_isBlackOrWhite) // false
    /// ```
    var dd_isBlackOrWhite: Bool {
        let RGB = dd_toRGBComponents()
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }

    /// 判断颜色是否为黑色
    ///
    /// 如果颜色的 RGB 值非常接近黑色，返回 `true`。
    /// - Returns: `true` 如果颜色为黑色，`false` 否则
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.black
    /// let isBlack = color.dd_isBlack // true
    /// ```
    var dd_isBlack: Bool {
        let RGB = dd_toRGBComponents()
        return RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09
    }

    /// 判断颜色是否为白色
    ///
    /// 如果颜色的 RGB 值非常接近白色，返回 `true`。
    /// - Returns: `true` 如果颜色为白色，`false` 否则
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.white
    /// let isWhite = color.dd_isWhite // true
    /// ```
    var dd_isWhite: Bool {
        let RGB = dd_toRGBComponents()
        return RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91
    }

    /// 比较两个颜色是否不同
    ///
    /// 比较当前颜色与另一个颜色的 RGB 组件，如果差异超过预设阈值，返回 `true`。
    /// - Parameter color: 要比较的颜色
    /// - Returns: `true` 如果颜色不同，`false` 如果颜色相同
    ///
    /// 示例：
    /// ```swift
    /// let color1 = UIColor.red
    /// let color2 = UIColor.blue
    /// print(color1.dd_isDistinct(from: color2)) // true
    /// ```
    func dd_isDistinct(from color: UIColor) -> Bool {
        let bg = dd_toRGBComponents()
        let fg = color.dd_toRGBComponents()
        let threshold: CGFloat = 0.25
        var result = false

        if Swift.abs(bg[0] - fg[0]) > threshold || Swift.abs(bg[1] - fg[1]) > threshold || Swift.abs(bg[2] - fg[2]) > threshold {
            if Swift.abs(bg[0] - bg[1]) < 0.03, Swift.abs(bg[0] - bg[2]) < 0.03 {
                if Swift.abs(fg[0] - fg[1]) < 0.03, Swift.abs(fg[0] - fg[2]) < 0.03 {
                    result = false
                }
            }
            result = true
        }

        return result
    }

    /// 判断两个颜色是否具有足够的对比度
    ///
    /// 使用亮度公式计算两个颜色的亮度对比度，如果对比度大于1.6，则认为两个颜色有足够的对比度。
    /// - Parameter color: 要比较的颜色
    /// - Returns: `true` 如果颜色有足够的对比度，`false` 否则
    ///
    /// 示例：
    /// ```swift
    /// let color1 = UIColor.black
    /// let color2 = UIColor.white
    /// print(color1.dd_isContrasting(with: color2)) // true
    /// ```
    func dd_isContrasting(with color: UIColor) -> Bool {
        let bg = dd_toRGBComponents()
        let fg = color.dd_toRGBComponents()

        let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
        let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
        let contrast = bgLum > fgLum
            ? (bgLum + 0.05) / (fgLum + 0.05)
            : (fgLum + 0.05) / (bgLum + 0.05)

        return contrast > 1.6
    }
}

// MARK: - 颜色组成(Components)
public extension UIColor {
    /// 获取颜色的 `RGBA` 组成数组
    ///
    /// 返回当前颜色的红色、绿色、蓝色和透明度（alpha）分量的数组。
    /// - Returns: `CGFloat` 数组，包含红色、绿色、蓝色分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.red
    /// let components = color.dd_toRGBComponents() // [1.0, 0.0, 0.0]
    /// ```
    func dd_toRGBComponents() -> [CGFloat] {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b]
    }

    /// 获取颜色的 `RGB` 组成 (返回 `Int` 元组)
    ///
    /// 返回当前颜色的红色、绿色、蓝色分量的整数值（0 到 255 范围）。
    /// - Returns: `Int` 元组，包含红色、绿色、蓝色分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.green
    /// let intComponents = color.dd_IntComponents // (red: 0, green: 255, blue: 0)
    /// ```
    var dd_IntComponents: (red: Int, green: Int, blue: Int) {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: Int(red * 255.0), green: Int(green * 255.0), blue: Int(blue * 255.0))
    }

    /// 获取颜色的 `RGB` 组成 (返回 `CGFloat` 元组)
    ///
    /// 返回当前颜色的红色、绿色、蓝色分量的浮动值（0 到 1 范围）。
    /// - Returns: `CGFloat` 元组，包含红色、绿色、蓝色分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.blue
    /// let floatComponents = color.dd_CGFloatComponents // (red: 0.0, green: 0.0, blue: 1.0)
    /// ```
    var dd_CGFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: red * 255.0, green: green * 255.0, blue: blue * 255.0)
    }

    /// 获取颜色的 `HSBA` 组成
    ///
    /// 返回当前颜色的色相（hue）、饱和度（saturation）、亮度（brightness）和透明度（alpha）分量的元组。
    /// - Returns: `CGFloat` 元组，包含色相、饱和度、亮度和透明度
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.cyan
    /// let hsbaComponents = color.dd_HSBAComponents // (hue: 0.5, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    /// ```
    var dd_HSBAComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /// 获取红色组成
    ///
    /// 返回当前颜色的红色分量（浮动值 0 到 1）。
    /// - Returns: `CGFloat` 红色分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.purple
    /// let red = color.dd_redComponent // 0.5
    /// ```
    var dd_redComponent: CGFloat {
        var red: CGFloat = 0
        getRed(&red, green: nil, blue: nil, alpha: nil)
        return red
    }

    /// 获取绿色组成
    ///
    /// 返回当前颜色的绿色分量（浮动值 0 到 1）。
    /// - Returns: `CGFloat` 绿色分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.orange
    /// let green = color.dd_greenComponent // 0.5
    /// ```
    var dd_greenComponent: CGFloat {
        var green: CGFloat = 0
        getRed(nil, green: &green, blue: nil, alpha: nil)
        return green
    }

    /// 获取蓝色组成
    ///
    /// 返回当前颜色的蓝色分量（浮动值 0 到 1）。
    /// - Returns: `CGFloat` 蓝色分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.blue
    /// let blue = color.dd_blueComponent // 1.0
    /// ```
    var dd_blueComponent: CGFloat {
        var blue: CGFloat = 0
        getRed(nil, green: nil, blue: &blue, alpha: nil)
        return blue
    }

    /// 获取透明值组成
    ///
    /// 返回当前颜色的透明度分量（浮动值 0 到 1）。
    /// - Returns: `CGFloat` 透明度分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.red.withAlphaComponent(0.5)
    /// let alpha = color.dd_alphaComponent // 0.5
    /// ```
    var dd_alphaComponent: CGFloat {
        var alpha: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }

    /// 获取色相组成
    ///
    /// 返回当前颜色的色相分量（浮动值 0 到 1）。
    /// - Returns: `CGFloat` 色相分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.yellow
    /// let hue = color.dd_HUEComponent // 0.1667
    /// ```
    var dd_HUEComponent: CGFloat {
        var hue: CGFloat = 0
        getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }

    /// 获取饱和度组成
    ///
    /// 返回当前颜色的饱和度分量（浮动值 0 到 1）。
    /// - Returns: `CGFloat` 饱和度分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.green
    /// let saturation = color.dd_saturationComponent // 1.0
    /// ```
    var dd_saturationComponent: CGFloat {
        var saturation: CGFloat = 0
        getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return saturation
    }

    /// 获取亮度组成
    ///
    /// 返回当前颜色的亮度分量（浮动值 0 到 1）。
    /// - Returns: `CGFloat` 亮度分量
    ///
    /// 示例：
    /// ```swift
    /// let color = UIColor.blue
    /// let brightness = color.dd_brightnessComponent // 1.0
    /// ```
    var dd_brightnessComponent: CGFloat {
        var brightness: CGFloat = 0
        getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}

// MARK: - 动态颜色
public extension UIColor {
    /// 创建一个动态颜色，使用相同的颜色值在浅色模式和深色模式下显示
    /// - Parameter hex: 十六进制颜色字符串，表示颜色值
    /// - Returns: 返回动态颜色 `UIColor`
    ///
    /// 示例：
    /// ```swift
    /// let dynamicColor = UIColor.createDynamicColor(hex: "#FF5733")
    /// ```
    static func createDynamicColor(hex: String) -> UIColor {
        return self.createDynamicColor(lightColor: hex, darkColor: hex)
    }

    /// 创建一个动态颜色，分别为浅色模式和深色模式设置不同的颜色
    /// - Parameters:
    ///   - lightColor: 浅色模式下的颜色（十六进制颜色字符串）
    ///   - darkColor: 深色模式下的颜色（十六进制颜色字符串）
    /// - Returns: 返回动态颜色 `UIColor`
    ///
    /// 示例：
    /// ```swift
    /// let dynamicColor = UIColor.createDynamicColor(
    ///     lightColor: "#FF5733",
    ///     darkColor: "#C70039"
    /// )
    /// ```
    static func createDynamicColor(lightColor: String, darkColor: String) -> UIColor {
        return self.createDynamicColor(lightColor: UIColor(hex: lightColor), darkColor: UIColor(hex: darkColor))
    }

    /// 创建一个动态颜色，使用相同的 `UIColor` 在浅色模式和深色模式下显示
    /// - Parameter color: 单一颜色对象
    /// - Returns: 返回动态颜色 `UIColor`
    ///
    /// 示例：
    /// ```swift
    /// let dynamicColor = UIColor.createDynamicColor(color: .red)
    /// ```
    static func createDynamicColor(color: UIColor) -> UIColor {
        return self.createDynamicColor(lightColor: color, darkColor: color)
    }

    /// 根据浅色模式和深色模式的颜色生成动态颜色
    /// - Parameters:
    ///   - lightColor: 浅色模式下的颜色对象
    ///   - darkColor: 深色模式下的颜色对象
    /// - Returns: 返回动态颜色 `UIColor`
    ///
    /// 示例：
    /// ```swift
    /// let dynamicColor = UIColor.createDynamicColor(
    ///     lightColor: .blue,
    ///     darkColor: .green
    /// )
    /// ```
    static func createDynamicColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
        } else {
            return lightColor
        }
    }
}

// MARK: - 渐变颜色
public extension UIColor {
    /// 生成一个线性渐变颜色 `UIColor`
    ///
    /// 通过指定的颜色数组、位置和渐变起始/结束点生成一个线性渐变颜色。
    /// - Parameters:
    ///   - size: 渐变区域的大小，决定渐变区域的尺寸。
    ///   - colors: 颜色数组，包含渐变中的颜色。
    ///   - locations: 位置数组，定义每个颜色的停靠点，范围 `0.0 ~ 1.0`，默认为 `[0, 1]`。
    ///   - startPoint: 渐变起始位置，决定渐变的开始点。
    ///   - endPoint: 渐变结束位置，决定渐变的结束点。
    /// - Returns: 返回生成的渐变颜色 `UIColor?`，可以用作背景或其他需要渐变效果的地方。
    ///
    /// 示例：
    /// ```swift
    /// let gradientColor = UIColor.dd_createLinearGradientColor(
    ///     size: CGSize(width: 100, height: 100),
    ///     colors: [.red, .blue],
    ///     startPoint: .zero,
    ///     endPoint: CGPoint(x: 1, y: 1)
    /// )
    /// ```
    static func dd_createLinearGradientColor(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             startPoint: CGPoint,
                                             endPoint: CGPoint) -> UIColor?
    {
        return UIColor(size: size, colors: colors, locations: locations, type: .axial, startPoint: startPoint, endPoint: endPoint)
    }

    /// 生成一个线性渐变图层 `CAGradientLayer`
    ///
    /// 通过指定的颜色数组、位置和渐变起始/结束点生成一个线性渐变图层，适用于 `CALayer` 等图层组件。
    /// - Parameters:
    ///   - size: 渐变区域的大小，决定渐变区域的尺寸。
    ///   - colors: 颜色数组，包含渐变中的颜色。
    ///   - locations: 位置数组，定义每个颜色的停靠点，范围 `0.0 ~ 1.0`，默认为 `[0, 1]`。
    ///   - startPoint: 渐变起始位置，决定渐变的开始点。
    ///   - endPoint: 渐变结束位置，决定渐变的结束点。
    /// - Returns: 返回配置好的 `CAGradientLayer`，可以直接用于 `UIView` 的图层。
    ///
    /// 示例：
    /// ```swift
    /// let gradientLayer = UIColor.dd_createLinearGradientLayer(
    ///     size: CGSize(width: 200, height: 200),
    ///     colors: [.green, .yellow],
    ///     startPoint: .zero,
    ///     endPoint: CGPoint(x: 1, y: 1)
    /// )
    /// ```
    static func dd_createLinearGradientLayer(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             startPoint: CGPoint,
                                             endPoint: CGPoint) -> CAGradientLayer
    {
        return CAGradientLayer(
            CGRect(origin: .zero, size: size),
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            type: .axial
        )
    }

    /// 生成一个线性渐变图片 `UIImage`
    ///
    /// 通过指定的颜色数组、位置和渐变起始/结束点生成一个线性渐变图片，适用于需要用图片做背景的情况。
    /// - Parameters:
    ///   - size: 渐变区域的大小，决定渐变区域的尺寸。
    ///   - colors: 颜色数组，包含渐变中的颜色。
    ///   - locations: 位置数组，定义每个颜色的停靠点，范围 `0.0 ~ 1.0`，默认为 `[0, 1]`。
    ///   - startPoint: 渐变起始位置，决定渐变的开始点。
    ///   - endPoint: 渐变结束位置，决定渐变的结束点。
    /// - Returns: 返回生成的渐变 `UIImage?`，可以用作背景图片或其他需要渐变图像的场景。
    ///
    /// 示例：
    /// ```swift
    /// let gradientImage = UIColor.dd_createLinearGradientImage(
    ///     size: CGSize(width: 50, height: 50),
    ///     colors: [.orange, .purple],
    ///     startPoint: .zero,
    ///     endPoint: CGPoint(x: 1, y: 0)
    /// )
    /// ```
    static func dd_createLinearGradientImage(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             startPoint: CGPoint,
                                             endPoint: CGPoint) -> UIImage?
    {
        let layer = dd_createLinearGradientLayer(size, colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

// MARK: - 渐变颜色(Array)
public extension [UIColor] {
    /// 创建线性渐变颜色的 `UIColor`
    ///
    /// 通过指定的颜色数组、位置和渐变起始/结束点生成一个渐变颜色。
    /// - Parameters:
    ///   - size: 渐变区域的大小，决定渐变区域的尺寸。
    ///   - locations: 渐变位置数组，定义每个颜色的停靠点，范围 `0.0 ~ 1.0`，默认为 `[0, 1]`。
    ///   - startPoint: 渐变起始点，决定渐变的起始位置，范围 `0.0 ~ 1.0`。
    ///   - endPoint: 渐变结束点，决定渐变的结束位置，范围 `0.0 ~ 1.0`。
    /// - Returns: 渐变颜色的 `UIColor?`，返回一个渐变效果的 `UIColor` 实例。
    ///
    /// 示例：
    /// ```swift
    /// let gradientColor = [UIColor.red, UIColor.blue].dd_toLinearGradientColor(
    ///     size: CGSize(width: 100, height: 100),
    ///     startPoint: CGPoint(x: 0, y: 0),
    ///     endPoint: CGPoint(x: 1, y: 1)
    /// )
    /// ```
    func dd_toLinearGradientColor(size: CGSize,
                                  locations: [CGFloat] = [0, 1],
                                  startPoint: CGPoint,
                                  endPoint: CGPoint) -> UIColor?
    {
        return UIColor.dd_createLinearGradientColor(size,
                                                    colors: self,
                                                    locations: locations,
                                                    startPoint: startPoint,
                                                    endPoint: endPoint)
    }

    /// 创建线性渐变的 `CAGradientLayer`
    ///
    /// 通过指定的颜色数组、位置和渐变起始/结束点生成一个线性渐变图层，适用于 `CALayer` 等图层组件。
    /// - Parameters:
    ///   - size: 渐变区域的大小，决定渐变区域的尺寸。
    ///   - locations: 渐变位置数组，定义每个颜色的停靠点，范围 `0.0 ~ 1.0`，默认为 `[0, 1]`。
    ///   - startPoint: 渐变起始点，决定渐变的起始位置，范围 `0.0 ~ 1.0`。
    ///   - endPoint: 渐变结束点，决定渐变的结束位置，范围 `0.0 ~ 1.0`。
    /// - Returns: 配置好的 `CAGradientLayer`，可以直接用于 `UIView` 的图层。
    ///
    /// 示例：
    /// ```swift
    /// let gradientLayer = [UIColor.green, UIColor.yellow].dd_toLinearGradientLayer(
    ///     size: CGSize(width: 200, height: 200),
    ///     startPoint: CGPoint(x: 0.5, y: 0),
    ///     endPoint: CGPoint(x: 0.5, y: 1)
    /// )
    /// ```
    func dd_toLinearGradientLayer(size: CGSize,
                                  locations: [CGFloat] = [0, 1],
                                  startPoint: CGPoint,
                                  endPoint: CGPoint) -> CAGradientLayer
    {
        return UIColor.dd_createLinearGradientLayer(size,
                                                    colors: self,
                                                    locations: locations,
                                                    startPoint: startPoint,
                                                    endPoint: endPoint)
    }

    /// 创建线性渐变的图片
    ///
    /// 通过指定的颜色数组、位置和渐变起始/结束点生成一个渐变图片，适用于需要用图片做背景的情况。
    /// - Parameters:
    ///   - size: 渐变区域的大小，决定渐变区域的尺寸。
    ///   - locations: 渐变位置数组，定义每个颜色的停靠点，范围 `0.0 ~ 1.0`，默认为 `[0, 1]`。
    ///   - startPoint: 渐变起始点，决定渐变的起始位置，范围 `0.0 ~ 1.0`。
    ///   - endPoint: 渐变结束点，决定渐变的结束位置，范围 `0.0 ~ 1.0`。
    /// - Returns: 渐变生成的 `UIImage?`，可以用作背景图片或其他用途。
    ///
    /// 示例：
    /// ```swift
    /// let gradientImage = [UIColor.orange, UIColor.purple].dd_toLinearGradientImage(
    ///     size: CGSize(width: 50, height: 50),
    ///     startPoint: CGPoint(x: 0, y: 0),
    ///     endPoint: CGPoint(x: 1, y: 0)
    /// )
    /// ```
    func dd_toLinearGradientImage(size: CGSize,
                                  locations: [CGFloat] = [0, 1],
                                  startPoint: CGPoint,
                                  endPoint: CGPoint) -> UIImage?
    {
        return UIColor.dd_createLinearGradientImage(size,
                                                    colors: self,
                                                    locations: locations,
                                                    startPoint: startPoint,
                                                    endPoint: endPoint)
    }
}

// MARK: - 链式语法扩展
public extension UIColor {
    /// 设置颜色的透明度（链式调用）
    /// - Parameter alpha: 透明度（范围 0.0 ~ 1.0）
    /// - Returns: 透明度调整后的 `UIColor`
    ///
    /// 示例：
    /// ```swift
    /// let semiTransparentRed = UIColor.red.dd_alpha(0.5)
    /// ```
    func dd_alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}
