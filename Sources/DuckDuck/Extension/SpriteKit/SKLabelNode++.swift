//
//  SKLabelNode++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 20/11/2024.
//

import SpriteKit

extension SKLabelNode {
    /// 设置字体样式
    /// - Parameters:
    ///   - fontName: 字体名称
    ///   - fontSize: 字体大小
    /// - Example:
    ///   ```swift
    ///   labelNode.dd_setFontStyle(fontName: "Arial", fontSize: 30)
    ///   ```
    func dd_setFontStyle(fontName: String, fontSize: CGFloat) {
        self.fontName = fontName
        self.fontSize = fontSize
    }

    /// 设置标签的文本
    /// - Parameter text: 标签显示的文本
    /// - Example:
    ///   ```swift
    ///   labelNode.dd_setText("Game Over")
    ///   ```
    func dd_setText(_ text: String) {
        self.text = text
    }

    /// 设置文本水平对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Example:
    ///   ```swift
    ///   labelNode.dd_setHorizontalAlignmentMode(.center)
    ///   ```
    func dd_setHorizontalAlignmentMode(_ alignment: SKLabelHorizontalAlignmentMode) {
        self.horizontalAlignmentMode = alignment
    }

    /// 设置文本垂直对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Example:
    ///   ```swift
    ///   labelNode.dd_setHorizontalAlignmentMode(.center)
    ///   ```
    func dd_setVerticalAlignmentMode(_ alignment: SKLabelVerticalAlignmentMode) {
        self.verticalAlignmentMode = alignment
    }

    /// 设置标签文本颜色
    /// - Parameter color: 颜色
    /// - Example:
    ///   ```swift
    ///   labelNode.dd_setColor(.red)
    ///   ```
    func dd_setColor(_ color: UIColor) {
        self.fontColor = color
    }
}
