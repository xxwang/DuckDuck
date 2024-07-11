//
//  LoggerWrapper.swift
//
//
//  Created by 王哥 on 2024/7/11.
//

import os.log

@propertyWrapper
public struct LoggerWrapper {
    private let logger: Logger

    public var wrappedValue: Logger {
        return self.logger
    }

    public init(subsystem: String = "com.dd.app", category: String = "duckduck") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
}
