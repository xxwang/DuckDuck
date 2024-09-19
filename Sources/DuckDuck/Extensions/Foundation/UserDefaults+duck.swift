//
//  UserDefaults+duck.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import Foundation

// MARK: - 模型持久化
public extension UserDefaults {
    /// 保存遵守`Codable`协议的对象到`UserDefaults`
    /// - Parameters:
    ///   - object: 要存储的对象
    ///   - key: 存取数据使用的`关键字`
    ///   - encoder: 编码器
    /// - Returns: 操作是否成功
    func dd_set(_ object: (some Codable)?, for key: String?, using encoder: JSONEncoder = JSONEncoder()) {
        guard let key else { return }
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
        self.synchronize()
    }

    /// 从`UserDefaults`检索遵守`Codable`的对象
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: 存取数据使用的`关键字`
    ///   - decoder: 解码器
    /// - Returns: 遵守`Codable`的对象
    func dd_object<T: Codable>(_ type: T.Type, for key: String?, using decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let key, let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    /// 从`UserDefaults`中移除当前应用存储的所有数据
    func dd_clearAll() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
}
