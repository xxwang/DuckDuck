import UIKit

// MARK: - 粒子特效协议
public protocol ParticleEffectProvider {}
@MainActor
public extension ParticleEffectProvider where Self: UIViewController {
    /// 启动粒子效果
    ///
    /// - Parameters:
    ///   - position: 粒子发射器的位置
    ///   - images: 粒子使用的图片数组
    ///   - configuration: 可选的粒子发射器配置闭包，允许自定义发射器属性
    /// - Returns: 此发射器的唯一标识符，便于后续操作
    ///
    /// - Example:
    /// ```swift
    /// let identifier = emitParticles(
    ///     at: CGPoint(x: 200, y: 300),
    ///     with: [UIImage(named: "particle1"), UIImage(named: "particle2")]) { emitter in
    ///         emitter.emitterShape = .circle
    ///         emitter.emitterSize = CGSize(width: 100, height: 100)
    ///     }
    /// ```
    @discardableResult
    func emitParticles(
        at position: CGPoint,
        with images: [UIImage?],
        configuration: ((CAEmitterLayer) -> Void)? = nil
    ) -> String {
        // 创建粒子发射器
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = position
        emitterLayer.preservesDepth = true
        emitterLayer.name = UUID().uuidString // 生成唯一标识符

        // 配置粒子单元
        let emitterCells: [CAEmitterCell] = images.compactMap { image in
            guard let cgImage = image?.cgImage else { return nil }
            let cell = CAEmitterCell()
            cell.contents = cgImage
            cell.velocity = 150
            cell.velocityRange = 100
            cell.scale = 0.7
            cell.scaleRange = 0.3
            cell.emissionLongitude = -(.pi / 2)
            cell.emissionRange = .pi / 12
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            cell.spin = .pi / 2
            cell.spinRange = .pi / 4
            cell.birthRate = 20
            return cell
        }
        emitterLayer.emitterCells = emitterCells
        configuration?(emitterLayer)

        // 添加发射器到视图
        self.view.layer.addSublayer(emitterLayer)
        return emitterLayer.name ?? ""
    }

    /// 停止指定发射器的粒子效果
    ///
    /// - Parameter identifier: 要停止的发射器的唯一标识符
    ///
    /// - Example:
    /// ```swift
    /// stopParticles(for: "uniqueIdentifier")
    /// ```
    func stopParticles(for identifier: String) {
        self.view.layer.sublayers?
            .filter { $0 is CAEmitterLayer && $0.name == identifier }
            .forEach { $0.removeFromSuperlayer() }
    }

    /// 停止所有粒子效果
    ///
    /// - Example:
    /// ```swift
    /// stopAllParticles()
    /// ```
    func stopAllParticles() {
        self.view.layer.sublayers?
            .filter { $0 is CAEmitterLayer }
            .forEach { $0.removeFromSuperlayer() }
    }

    /// 暂停所有粒子效果
    ///
    /// - Example:
    /// ```swift
    /// pauseParticles()
    /// ```
    func pauseParticles() {
        self.view.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .forEach { $0.speed = 0 }
    }

    /// 恢复所有粒子效果
    ///
    /// - Example:
    /// ```swift
    /// resumeParticles()
    /// ```
    func resumeParticles() {
        self.view.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .forEach { $0.speed = 1 }
    }

    /// 启动雪花效果
    ///
    /// - Parameter position: 雪花发射器的位置
    ///
    /// - Example:
    /// ```swift
    /// emitSnow(at: CGPoint(x: 200, y: 0))
    /// ```
    func emitSnow(at position: CGPoint) {
        emitParticles(at: position, with: [UIImage(named: "snowflake")]) { emitter in
            emitter.emitterShape = .line
            emitter.emitterSize = CGSize(width: self.view.bounds.width, height: 1)
        }
    }

    /// 启动烟花效果
    ///
    /// - Parameter position: 烟花发射器的位置
    ///
    /// - Example:
    /// ```swift
    /// emitFireworks(at: CGPoint(x: 200, y: 400))
    /// ```
    func emitFireworks(at position: CGPoint) {
        emitParticles(at: position, with: [UIImage(named: "firework")]) { emitter in
            emitter.emitterShape = .point
            emitter.emitterSize = CGSize(width: 10, height: 10)
        }
    }
}
