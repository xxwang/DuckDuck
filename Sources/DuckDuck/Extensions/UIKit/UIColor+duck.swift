//
//  UIColor+duck.swift
//
//
//  Created by 王哥 on 2024/6/21.
//

import CoreGraphics
import UIKit

// MARK: - 方法
public extension UIColor {
    /// 生成一个随机颜色
    static func dd_random() -> UIColor {
        let red = Int.random(in: 0 ... 255)
        let green = Int.random(in: 0 ... 255)
        let blue = Int.random(in: 0 ... 255)
        return UIColor(dd_red: red.dd_CGFloat(), dd_green: green.dd_CGFloat(), dd_blue: blue.dd_CGFloat())!
    }

    /// (设置/获取)颜色的透明度
    var dd_alpha: CGFloat {
        get { self.cgColor.alpha }
        set { self.withAlphaComponent(newValue) }
    }

    /// 获取颜色的`Int`表示
    func dd_Int() -> Int {
        let red = Int(dd_RGBA().0 * 255) << 16
        let green = Int(dd_RGBA().1 * 255) << 8
        let blue = Int(dd_RGBA().2 * 255)
        return red + green + blue
    }

    /// 获取颜色的`UInt`表示
    func dd_UInt() -> UInt {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(components[0] * 255.0) << 16
        colorAsUInt32 += UInt32(components[1] * 255.0) << 8
        colorAsUInt32 += UInt32(components[2] * 255.0)

        return UInt(colorAsUInt32)
    }

    /// 十六进制颜色字符串(短)`1位==2位 3位==4位 5位==6位, 相同使用一个`长度3位
    func dd_shortHexString() -> String? {
        let string = dd_hexString(true).replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    /// 优先返回短的十六进制颜色值,如果不能转换则返回长的十六进制颜色值(字符串)
    func dd_shortHexOrHexString() -> String {
        let components: [Int] = {
            let comps = cgColor.components!.map { Int($0 * 255.0) }
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let hexString = String(format: "#%02X%02X%02X", components[0], components[1], components[2])
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return hexString }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    /// 把`UIColor`转成`(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)`元组
    func dd_RGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let numberOfComponents = self.cgColor.numberOfComponents
        guard let components = self.cgColor.components else {
            return (0, 0, 0, 1)
        }
        if numberOfComponents == 2 {
            return (components[0], components[0], components[0], components[1])
        }
        if numberOfComponents == 4 {
            return (components[0], components[1], components[2], components[3])
        }
        return (0, 0, 0, 1)
    }

    /// 返回HSBA模式颜色
    /// - hue:色相
    /// - saturation:饱和度
    /// - brightness:亮度
    /// - alpha:透明度
    func dd_HSBA() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h * 360, s, b, a)
    }

    /// 转换为`CoreImage.CIColor`
    func dd_CIColor() -> CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }

    /// 获取互补色
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
    /// - Parameter size:图片尺寸
    /// - Returns:`UIImage`
    func dd_image(by size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

    /// 返回十六进制(长)颜色值字符串
    /// - Parameter hashPrefix:是否添加前缀
    /// - Returns:`String`
    func dd_hexString(_ hashPrefix: Bool = true) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let prefix = hashPrefix ? "#" : ""
        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    /// 从字符串中提取十六进制颜色值创建`UIColor`
    /// - Parameters:
    ///   - hex:十六进制颜色字符串
    ///   - alpha:透明度
    /// - Returns:`UIColor`
    static func dd_proceesHex(hex: String, alpha: CGFloat) -> UIColor {
        /** 如果传入的字符串为空 */
        if hex.isEmpty {
            return UIColor.clear
        }

        /** 传进来的值. 去掉了可能包含的空格、特殊字符, 并且全部转换为大写 */
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        var hHex = (hex.trimmingCharacters(in: whitespace)).uppercased()

        /** 如果处理过后的字符串少于6位 */
        if hHex.count < 6 {
            return UIColor.clear
        }

        /** 开头是用0x开始的  或者  开头是以＃＃开始的 */
        if hHex.hasPrefix("0X") || hHex.hasPrefix("##") {
            hHex = String(hHex.dropFirst(2))
        }

        /** 开头是以＃开头的 */
        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }

        /** 截取出来的有效长度是6位, 所以不是6位的直接返回 */
        if hHex.count != 6 {
            return UIColor.clear
        }

        /** R G B */
        var range = NSRange(location: 0, length: 2)

        /** R */
        let rHex = (hHex as NSString).substring(with: range)

        /** G */
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)

        /** B */
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)

        /** 类型转换 */
        var r: CUnsignedLongLong = 0,
            g: CUnsignedLongLong = 0,
            b: CUnsignedLongLong = 0

        Scanner(string: rHex).scanHexInt64(&r)
        Scanner(string: gHex).scanHexInt64(&g)
        Scanner(string: bHex).scanHexInt64(&b)

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    /// 混合特定的两个颜色
    /// - Parameters:
    ///   - color1:要混合的第一个颜色
    ///   - intensity1:第一个颜色的强度(默认值为0.5)
    ///   - color2:要混合的第二个颜色
    ///   - intensity2:第二个颜色的强度(默认值为0.5)
    /// - Returns:混合后的新颜色
    static func dd_blend(_ color1: UIColor,
                         intensity1: CGFloat = 0.5,
                         with color2: UIColor,
                         intensity2: CGFloat = 0.5) -> UIColor
    {
        let total = intensity1 + intensity2
        let level1 = intensity1 / total
        let level2 = intensity2 / total

        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }

        let components1: [CGFloat] = {
            let comps: [CGFloat] = color1.cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        let components2: [CGFloat] = {
            let comps: [CGFloat] = color2.cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        let red1 = components1[0]
        let red2 = components2[0]

        let green1 = components1[1]
        let green2 = components2[1]

        let blue1 = components1[2]
        let blue2 = components2[2]

        let alpha1 = color1.cgColor.alpha
        let alpha2 = color2.cgColor.alpha

        let red = level1 * red1 + level2 * red2
        let green = level1 * green1 + level2 * green2
        let blue = level1 * blue1 + level2 * blue2
        let alpha = level1 * alpha1 + level2 * alpha2

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 以`HSB`模式混合颜色到当前颜色
    /// - Parameters:
    ///   - hue:色调
    ///   - saturation:饱和度
    ///   - brightness:亮度
    ///   - alpha:透明度
    /// - Returns:`UIColor`
    func dd_add(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
        var (oldHue, oldSat, oldBright, oldAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getHue(&oldHue, saturation: &oldSat, brightness: &oldBright, alpha: &oldAlpha)

        // 确保颜色值不会溢出
        var newHue = oldHue + hue
        while newHue < 0.0 {
            newHue += 1.0
        }
        while newHue > 1.0 {
            newHue -= 1.0
        }

        let newBright: CGFloat = max(min(oldBright + brightness, 1.0), 0)
        let newSat: CGFloat = max(min(oldSat + saturation, 1.0), 0)
        let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)

        return UIColor(hue: newHue, saturation: newSat, brightness: newBright, alpha: newAlpha)
    }

    /// 以`RGB`模式混合颜色到当前颜色
    /// - Parameters:
    ///   - red:红色
    ///   - green:绿色
    ///   - blue:蓝色
    ///   - alpha:透明度
    /// - Returns:混合后的新颜色
    func dd_add(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        var (oldRed, oldGreen, oldBlue, oldAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getRed(&oldRed, green: &oldGreen, blue: &oldBlue, alpha: &oldAlpha)
        // 确保颜色值不会溢出
        let newRed: CGFloat = max(min(oldRed + red, 1.0), 0)
        let newGreen: CGFloat = max(min(oldGreen + green, 1.0), 0)
        let newBlue: CGFloat = max(min(oldBlue + blue, 1.0), 0)
        let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }

    /// 以`HSB`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color:要混合的颜色
    /// - Returns:`UIColor`
    func dd_add(hsb color: UIColor) -> UIColor {
        var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return dd_add(hue: h, saturation: s, brightness: b, alpha: 0)
    }

    /// 以`RGB`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color:要混合的颜色
    /// - Returns:`UIColor`
    func dd_add(rgb color: UIColor) -> UIColor {
        dd_add(red: color.dd_redComponent, green: color.dd_greenComponent, blue: color.dd_blueComponent, alpha: 0)
    }

    /// 以`HSBA`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color:要混合的颜色
    /// - Returns:`UIColor`
    func add(hsba color: UIColor) -> UIColor {
        var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return dd_add(hue: h, saturation: s, brightness: b, alpha: a)
    }

    /// 以`RGBA`模式混合一个`UIColor`对象到当前颜色
    /// - Parameter color:要混合的颜色
    /// - Returns:`UIColor`
    func dd_add(rgba color: UIColor) -> UIColor {
        dd_add(red: color.dd_redComponent, green: color.dd_greenComponent, blue: color.dd_blueComponent, alpha: color.dd_alphaComponent)
    }

    /// 根据`最小饱和度`调整颜色
    /// - Parameter minSaturation:最小饱和度
    /// - Returns:`UIColor`
    func dd_color(minSaturation: CGFloat) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return saturation < minSaturation
            ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
            : self
    }

    /// 增加颜色对象的亮度
    ///
    ///     let color = Color(red:r, green:g, blue:b, alpha:a)
    ///     let lighterColor:Color = color.lighten(by:0.2)
    ///
    /// - Parameter percentage:增加亮度的值(0-1)
    /// - Returns:一个新的颜色对象
    func dd_lighten(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: min(red + percentage, 1.0),
                       green: min(green + percentage, 1.0),
                       blue: min(blue + percentage, 1.0),
                       alpha: alpha)
    }

    /// 减少颜色对象的亮度(让颜色变暗)
    ///
    ///     let color = Color(red:r, green:g, blue:b, alpha:a)
    ///     let darkerColor:Color = color.darken(by:0.2)
    ///
    /// - Parameter percentage:减少亮度的值(0-1)
    /// - Returns:一个新的颜色对象
    func dd_darken(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: max(red - percentage, 0),
                       green: max(green - percentage, 0),
                       blue: max(blue - percentage, 0),
                       alpha: alpha)
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
        self.init(dd_red: red.dd_CGFloat(), dd_green: green.dd_CGFloat(), dd_blue: blue.dd_CGFloat(), dd_alpha: alpha)!
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

        self.init(red: red.dd_CGFloat(), green: green.dd_CGFloat(), blue: blue.dd_CGFloat(), alpha: alpha.dd_CGFloat() / 255)
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

    /// 根据特定颜色创建该颜色的互补色
    /// - Parameter color:创建互补色的基准颜色
    convenience init?(complementaryFor color: UIColor) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: UIColor) -> UIColor?) = { color -> UIColor? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }

        let color = convertColorToRGBSpace(color)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[0] * 255, 2.0)) / 255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[1] * 255, 2.0)) / 255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[2] * 255, 2.0)) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    /// 为明暗模式创建不同颜色的UIColor
    /// - Parameters:
    /// - light:高亮颜色
    /// - dark:暗调颜色
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }

    /// 创建一个渐变颜色
    /// - Parameters:
    ///   - size: 渐变大小
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - type: 渐变类型
    ///   - start: 渐变开始位置
    ///   - end: 渐变结束位置
    convenience init?(_ size: CGSize,
                      colors: [UIColor],
                      locations: [CGFloat] = [0, 1],
                      type: CAGradientLayerType = .axial,
                      start: CGPoint,
                      end: CGPoint)
    {
        let layer = CAGradientLayer()
            .dd_frame(CGRect(origin: .zero, size: size))
            .dd_colors(colors)
            .dd_locations(locations)
            .dd_type(type)
            .dd_start(start)
            .dd_end(end)

        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard image != nil else { return nil }

        self.init(patternImage: image!)
    }
}

// MARK: - 颜色组成(Components)
public extension UIColor {
    /// `RGBA`组成数组
    func dd_RGBComponents() -> [CGFloat] {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)

        return [r, g, b]
    }

    /// 获取颜色的`RGB`组成(`Int`元组)
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

    /// 获取颜色的`RGB`组成(`CGFloat`元组)
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

    /// 获取颜色的`HSBA`组成(`CGFloat`元组)
    var dd_HSBAComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /// 红色组成
    var dd_redComponent: CGFloat {
        var red: CGFloat = 0
        getRed(&red, green: nil, blue: nil, alpha: nil)
        return red
    }

    /// 绿色组成
    var dd_greenComponent: CGFloat {
        var green: CGFloat = 0
        getRed(nil, green: &green, blue: nil, alpha: nil)
        return green
    }

    /// 蓝色组成
    var dd_blueComponent: CGFloat {
        var blue: CGFloat = 0
        getRed(nil, green: nil, blue: &blue, alpha: nil)
        return blue
    }

    /// 透明值组成
    var dd_alphaComponent: CGFloat {
        var alpha: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }

    /// 色相组成
    var dd_HUEComponent: CGFloat {
        var hue: CGFloat = 0
        getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }

    /// 饱和度组成
    var dd_saturationComponent: CGFloat {
        var saturation: CGFloat = 0
        getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return saturation
    }

    /// 明度组成
    var dd_brightnessComponent: CGFloat {
        var brightness: CGFloat = 0
        getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}

// MARK: - 颜色判断
public extension UIColor {
    /// 是否是暗色
    var isDark: Bool {
        let RGB = dd_RGBComponents()
        return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
    }

    /// 是否是黑色或者白色
    var isBlackOrWhite: Bool {
        let RGB = dd_RGBComponents()
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }

    /// 是否是黑色
    var isBlack: Bool {
        let RGB = dd_RGBComponents()
        return RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09
    }

    /// 是否是白色
    var isWhite: Bool {
        let RGB = dd_RGBComponents()
        return RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91
    }

    /// 比较两个颜色是否一样
    /// - Parameter color:要比较的颜色
    /// - Returns:是否一样
    func dd_isDistinct(from color: UIColor) -> Bool {
        let bg = dd_RGBComponents()
        let fg = color.dd_RGBComponents()
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

    /// 两个颜色是否不一样
    /// - Parameter color:要比较的颜色
    /// - Returns:是否不一样
    func dd_isContrasting(with color: UIColor) -> Bool {
        let bg = dd_RGBComponents()
        let fg = color.dd_RGBComponents()

        let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
        let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
        let contrast = bgLum > fgLum
            ? (bgLum + 0.05) / (fgLum + 0.05)
            : (fgLum + 0.05) / (bgLum + 0.05)

        return contrast > 1.6
    }
}

// MARK: - 动态颜色
public extension UIColor {
    /// 动态颜色为同一种颜色
    /// - Parameter hex:十六进制颜色字符串
    /// - Returns:颜色对象
    static func dd_darkModeColor(hex: String) -> UIColor {
        dd_darkModeColor(lightColor: hex, darkColor: hex)
    }

    /// 生成一个动态颜色(十六进制 字符串格式)
    /// - Parameters:
    ///   - lightColor:高亮颜色(默认颜色)
    ///   - darkColor:暗调颜色
    /// - Returns:动态颜色
    static func dd_darkModeColor(lightColor: String, darkColor: String) -> UIColor {
        dd_darkModeColor(lightColor: UIColor(hex: lightColor), darkColor: UIColor(hex: darkColor))
    }

    /// 动态颜色为同一种颜色
    /// - Parameter hex:十六进制颜色字符串
    /// - Returns:颜色对象
    static func dd_darkModeColor(color: UIColor) -> UIColor {
        dd_darkModeColor(lightColor: color, darkColor: color)
    }

    /// 深色模式和浅色模式颜色设置,非layer颜色设置
    /// - Parameters:
    ///   - lightColor:浅色模式的颜色
    ///   - darkColor:深色模式的颜色
    /// - Returns:返回一个颜色(UIColor)
    static func dd_darkModeColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
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
    /// 生成一个线性渐变颜色`UIColor`
    /// - Parameters:
    ///   - size: 渐变大小
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - start: 开始位置
    ///   - end: 结束位置
    /// - Returns: `UIColor?`
    static func dd_createLinearGradientColor(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint) -> UIColor?
    {
        UIColor(size, colors: colors, locations: locations, type: .axial, start: start, end: end)
    }

    /// 生成一个线性渐变图层`CAGradientLayer`
    /// - Parameters:
    ///   - size: 渐变大小
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - start: 开始位置
    ///   - end: 结束位置
    /// - Returns: `CAGradientLayer`
    static func dd_createLinearGradientLayer(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint) -> CAGradientLayer
    {
        CAGradientLayer(CGRect(origin: .zero, size: size),
                        colors: colors,
                        locations: locations,
                        start: start,
                        end: end,
                        type: .axial)
    }

    /// 生成一个线性渐变图片`UIImage`
    /// - Parameters:
    ///   - size: 渐变大小
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - start: 开始位置
    ///   - end: 结束位置
    /// - Returns:`UIImage?`
    static func dd_createLinearGradientImage(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint) -> UIImage?
    {
        let layer = dd_createLinearGradientLayer(size, colors: colors, locations: locations, start: start, end: end)
        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

// MARK: - 渐变颜色(Array)
public extension [UIColor] {
    /// 生成一个线性渐变颜色`UIColor`
    /// - Parameters:
    ///   - size: 大小
    ///   - locations: 位置数组
    ///   - start: 开始位置
    ///   - end: 结束位置
    /// - Returns: `UIColor?`
    func dd_createLinearGradientColor(_ size: CGSize,
                                      locations: [CGFloat] = [0, 1],
                                      start: CGPoint,
                                      end: CGPoint) -> UIColor?
    {
        UIColor.dd_createLinearGradientColor(size, colors: self, locations: locations, start: start, end: end)
    }

    /// 生成一个线性渐变图层`CAGradientLayer`
    /// - Parameters:
    ///   - size: 渐变大小
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - start: 开始位置
    ///   - end: 结束位置
    /// - Returns: `CAGradientLayer`
    func dd_createLinearGradientLayer(_ size: CGSize,
                                      locations: [CGFloat] = [0, 1],
                                      start: CGPoint,
                                      end: CGPoint) -> CAGradientLayer
    {
        UIColor.dd_createLinearGradientLayer(size, colors: self, locations: locations, start: start, end: end)
    }

    /// 生成一个线性渐变图片`UIImage`
    /// - Parameters:
    ///   - size: 渐变大小
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - start: 开始位置
    ///   - end: 结束位置
    /// - Returns:`UIImage?`
    func dd_createLinearGradientImage(_ size: CGSize,
                                      locations: [CGFloat] = [0, 1],
                                      start: CGPoint,
                                      end: CGPoint) -> UIImage?
    {
        UIColor.dd_createLinearGradientImage(size, colors: self, locations: locations, start: start, end: end)
    }
}

// MARK: - 链式语法
public extension UIColor {
    /// 设置颜色透明度
    /// - Parameter value:要设置的透明度
    /// - Returns:`UIColor`
    func dd_withAlphaComponent(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
}
