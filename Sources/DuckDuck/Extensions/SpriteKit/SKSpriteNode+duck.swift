//
//  SKSpriteNode+duck.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import SpriteKit

// MARK: - 方法
public extension SKSpriteNode {
    /// 等比例填充
    /// - Parameter fillSize:边界尺寸
    func dd_aspectFill(to fillSize: CGSize) {
        guard let textureSize = self.texture?.size() else { return }

        let width = textureSize.width
        let height = textureSize.height

        guard width > 0, height > 0 else { return }

        let horizontalRatio = fillSize.width / width
        let verticalRatio = fillSize.height / height
        let ratio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
        self.size = CGSize(width: width * ratio, height: height * ratio)
    }
}
