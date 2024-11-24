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
    func dd_toInt() -> Int {
        let red = Int(dd_RGBA().0 * 255) << 16
        let green = Int(dd_RGBA().1 * 255) << 8
        let blue = Int(dd_RGBA().2 * 255)
        return red + green + blue
    }

    /// 获取颜色的`UInt`表示
    func dd_toUInt() -> UInt {
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

