import SpriteKit

// MARK: - SKSpriteNode 扩展方法
public extension SKSpriteNode {
    /// 等比例缩放到适应指定尺寸
    /// - Parameter fillSize: 目标尺寸，`CGSize` 类型
    ///
    /// - Example:
    /// ```swift
    /// let sprite = SKSpriteNode(imageNamed: "exampleImage")
    /// let targetSize = CGSize(width: 200, height: 300)
    /// sprite.resizeToFitWithAspectRatio(to: targetSize)
    /// // 该方法会根据 sprite 的原始纹理大小，保持比例缩放以适应目标尺寸
    /// ```
    func resizeToFitWithAspectRatio(to fillSize: CGSize) {
        // 获取 sprite 的原始纹理尺寸
        guard let textureSize = self.texture?.size() else { return }

        let width = textureSize.width
        let height = textureSize.height

        // 如果纹理尺寸无效，则返回
        guard width > 0, height > 0 else { return }

        // 计算水平和垂直缩放比例
        let horizontalRatio = fillSize.width / width
        let verticalRatio = fillSize.height / height

        // 选择较小的比例来保持图像的纵横比
        let ratio = min(horizontalRatio, verticalRatio)

        // 设置 sprite 的新尺寸
        self.size = CGSize(width: width * ratio, height: height * ratio)
    }

    /// 为节点添加缩放动画
    /// - Parameters:
    ///   - duration: 动画持续时间
    ///   - scale: 缩放比例，1.0 表示原始大小，大于 1.0 为放大，小于 1.0 为缩小
    /// - Example:
    ///   ```swift
    ///   // 为节点添加一个持续 2 秒的缩放动画，将节点缩小到原始大小的一半
    ///   node.dd_scaleAnimation(duration: 2.0, scale: 0.5)
    ///   ```
    func dd_scaleAnimation(duration: TimeInterval, scale: CGFloat) {
        // 创建一个缩放动作，将节点的缩放比例设置为指定的 scale
        let scaleAction = SKAction.scale(to: scale, duration: duration)

        // 执行缩放动画
        self.run(scaleAction)
    }

    /// 设置节点的纹理
    /// - Parameter imageName: 图片名称
    /// - Example:
    ///   ```swift
    ///   spriteNode.dd_setTextureFromImageNamed("newImage")
    ///   ```
    func dd_setTextureFromImageNamed(_ imageName: String) {
        self.texture = SKTexture(imageNamed: imageName)
    }

    /// 执行动作并指定持续时间
    /// - Parameters:
    ///   - action: 要执行的动作
    ///   - duration: 动作持续时间
    /// - Example:
    ///   ```swift
    ///   let moveAction = SKAction.moveTo(x: 100, duration: 1.0)
    ///   spriteNode.dd_runActionWithDuration(moveAction, duration: 1.0)
    ///   ```
    func dd_runActionWithDuration(_ action: SKAction, duration: TimeInterval) {
        self.run(action, withKey: "actionKey")
    }

    /// 为节点添加物理引擎体
    /// - Parameters:
    ///   - mass: 物体质量
    ///   - isDynamic: 是否动态
    /// - Example:
    ///   ```swift
    ///   sprite.dd_applyPhysicsBody(mass: 1.0, isDynamic: true)
    ///   ```
    func dd_applyPhysicsBody(mass: CGFloat, isDynamic: Bool) {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.mass = mass
        self.physicsBody?.isDynamic = isDynamic
    }

    /// 更改精灵的大小
    /// - Parameter size: 目标大小
    /// - Example:
    ///   ```swift
    ///   sprite.dd_changeSize(CGSize(width: 200, height: 200))
    ///   ```
    func dd_changeSize(_ size: CGSize) {
        self.size = size
    }

    /// 使精灵节点淡入
    /// - Parameter duration: 淡入的持续时间
    /// - Example:
    ///   ```swift
    ///   sprite.dd_fadeIn(duration: 2.0)
    ///   ```
    func dd_fadeIn(duration: TimeInterval) {
        let fadeInAction = SKAction.fadeIn(withDuration: duration)
        self.run(fadeInAction)
    }

    /// 使精灵节点淡出
    /// - Parameter duration: 淡出的持续时间
    /// - Example:
    ///   ```swift
    ///   sprite.dd_fadeOut(duration: 2.0)
    ///   ```
    func dd_fadeOut(duration: TimeInterval) {
        let fadeOutAction = SKAction.fadeOut(withDuration: duration)
        self.run(fadeOutAction)
    }
}
