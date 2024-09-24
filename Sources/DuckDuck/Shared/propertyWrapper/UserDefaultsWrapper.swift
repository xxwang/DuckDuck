//
//  UserDefaultsWrapper.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import Foundation

// MARK: - UserDefaultsWrapper
@propertyWrapper
public struct UserDefaultsWrapper<T> {
    private let userDefaults = UserDefaults.standard
    private let key: String
    private let defaultValue: T

    public var wrappedValue: T {
        get { return self.userDefaults.object(forKey: key) as? T ?? defaultValue }
        set { self.userDefaults.set(newValue, forKey: key) }
    }

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults.register(defaults: [key: defaultValue])
    }
}

// MARK: - ObjectUserDefaultsWrapper
@propertyWrapper
public struct ObjectUserDefaultsWrapper<T> where T: Codable {
    private let userDefaults = UserDefaults.standard
    private let key: String
    private let defaultValue: T?

    public var wrappedValue: T? {
        get { return self.userDefaults.dd_object(T.self, for: key) }
        set { self.userDefaults.dd_set(newValue, for: key) }
    }

    public init(_ key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults.register(defaults: [key: defaultValue ?? ""])
    }
}
