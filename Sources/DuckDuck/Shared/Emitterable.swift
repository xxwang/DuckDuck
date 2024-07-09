//
//  Emitterable.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import UIKit

// MARK: - 粒子发射器
public protocol Emitterable {}

public extension Emitterable where Self: UIViewController {
    /// 开始发射粒子
    /// - Parameters:
    ///   - position: 发射器位置
    ///   - images: 粒子图片
    func startEmitting(position: CGPoint, images: [UIImage?]) {
        // 创建发射器
        let emitter = CAEmitterLayer()
        // 设置发射器位置
        emitter.emitterPosition = position
        // 开启三维效果
        emitter.preservesDepth = true

        // 粒子数组
        var cells = [CAEmitterCell]()
        for image in images {
            // 创建粒子
            let cell = CAEmitterCell()
            // 设置粒子速度
            cell.velocity = 150
            cell.velocityRange = 100
            // 设置粒子大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            // 设置粒子方向
            cell.emissionLongitude = -(Double.pi / 2)
            cell.emissionRange = -(Double.pi / 12)
            // 设置粒子生命周期
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            // 设置粒子旋转
            cell.spin = Double.pi / 2
            cell.spinRange = Double.pi / 4
            // 设置粒子每秒弹出个数
            cell.birthRate = 20
            // 设置粒子图片
            cell.contents = image?.cgImage

            cells.append(cell)
        }
        // 将粒子添加到发射器中
        emitter.emitterCells = cells

        // 将发射器添加到父layer中
        self.view.layer.addSublayer(emitter)
    }

    /// 停止发射
    func stopEmitting() {
        self.view.layer.sublayers?
            .filter { $0.isKind(of: CAEmitterLayer.self) }
            .forEach { $0.removeFromSuperlayer() }
    }
}

