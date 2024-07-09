//
//  SkinManager.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import UIKit

// MARK: - Skinable协议
public protocol Skinable: AnyObject {
    /// 在这个方法中更新主题
    func apply()
}

// MARK: - UITraitEnvironment
public extension Skinable where Self: UITraitEnvironment {
    /// 返回单例对象
    var skinManager: SkinProvider {
        return SkinManager.shared
    }
}

// MARK: - SkinProvider协议
public protocol SkinProvider: AnyObject {
    /// 注册监听
    func register<Observer: Skinable>(observer: Observer)
    /// 移除监听
    func remove<Observer: Skinable>(observer: Observer)
    /// 更新主题
    func updateSkin()
}

// MARK: - SkinManager
public class SkinManager {
    /// 监听对象数组
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    /// 单例
    public static let shared = SkinManager()
    private init() {}
}

// MARK: - SkinProvider
extension SkinManager: SkinProvider {
    /// 注册监听
    /// - Parameter observer: 监听对象
    public func register(observer: some Skinable) {
        observers.add(observer)
    }

    /// 移除监听
    /// - Parameter observer: 监听对象
    public func remove(observer: some Skinable) {
        if !observers.contains(observer) { return }
        observers.remove(observer)
    }

    /// 更新主题
    public func updateSkin() {
        // 通知监听对象更新Skin
        DispatchQueue.main.async {
            self.observers
                .allObjects
                .compactMap { $0 as? Skinable }
                .forEach { $0.apply() }
        }
    }
}
