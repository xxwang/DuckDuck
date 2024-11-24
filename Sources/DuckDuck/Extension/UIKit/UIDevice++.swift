//
//  UIDevice++.swift
//  DuckDuck-temp
//
//  Created by 王哥 on 24/11/2024.
//

import AdSupport
import AppTrackingTransparency
import AVKit
import CoreTelephony
import Security
import SystemConfiguration.CaptiveNetwork
import UIKit

// MARK: - 标识
public extension UIDevice {
    /// 获取设备的 IDFV (Identifier for Vendor)
    /// - Returns: 返回设备的 IDFV，如果无法获取则返回 nil
    ///
    /// 示例:
    /// ```swift
    /// if let idfv = UIDevice.dd_idfv() {
    ///     print("IDFV: \(idfv)")
    /// }
    /// ```
    static func dd_idfv() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    /// 获取设备的 IDFA (Identifier for Advertising)，仅在用户允许广告追踪时有效
    /// - Returns: 返回设备的 IDFA，如果用户关闭广告追踪则返回 nil
    ///
    /// 示例:
    /// ```swift
    /// if let idfa = UIDevice.dd_idfa() {
    ///     print("IDFA: \(idfa)")
    /// } else {
    ///     print("IDFA is not available.")
    /// }
    /// ```
    static func dd_idfa() -> String? {
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
        return nil
    }

    /// 生成并返回一个 UUID
    /// - Returns: 返回一个新的 UUID 字符串
    ///
    /// 示例:
    /// ```swift
    /// let uuid = UIDevice.dd_uuidString()
    /// print("Generated UUID: \(uuid)")
    /// ```
    static func dd_uuidString() -> String {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        let uuidString = (strRef! as String).replacingOccurrences(of: "_", with: "")
        return uuidString
    }
}

// MARK: - 设备区分
public extension UIDevice {
    /// 检查当前设备是否越狱
    /// - Returns: 返回 `true` 如果设备越狱，否则返回 `false`
    ///
    /// 示例:
    /// ```swift
    /// if UIDevice.dd_isBreak() {
    ///     print("Device is jailbroken")
    /// } else {
    ///     print("Device is not jailbroken")
    /// }
    /// ```
    static func dd_isBreak() -> Bool {
        // 检查是否为模拟器，模拟器不能越狱
        if CommonHelper.isSimulator {
            return false
        }

        // 检查常见的越狱路径
        let paths = ["/Applications/Cydia.app", "/private/var/lib/apt/",
                     "/private/var/lib/cydia", "/private/var/stash"]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        // 检查是否可以打开 bash，bash 是越狱设备上的常见工具
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }

        // 尝试写入文件，如果成功，表示设备可能被越狱
        let path = String(format: "/private/%@", self.dd_uuidString())
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            NSLog(error.localizedDescription)
        }
        return false
    }

    /// 检查当前设备是否能够拨打电话
    /// - Returns: 返回 `true` 如果设备支持拨打电话，`false` 如果不支持
    ///
    /// 示例:
    /// ```swift
    /// if UIDevice.dd_isCanCallTel() {
    ///     print("Device can make calls")
    /// } else {
    ///     print("Device cannot make calls")
    /// }
    /// ```
    static func dd_isCanCallTel() -> Bool {
        if let url = URL(string: "tel://") {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

// MARK: - 设备的基本信息
public extension UIDevice {
    /// 获取当前设备的系统版本
    /// - Returns: 当前设备的系统版本字符串
    ///
    /// 示例:
    /// ```swift
    /// let systemVersion = UIDevice.dd_systemVersion()
    /// print("System Version: \(systemVersion)")
    /// ```
    static func dd_systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /// 获取当前系统的更新时间
    /// - Returns: 系统启动以来的时间
    ///
    /// 示例:
    /// ```swift
    /// let systemUptime = UIDevice.dd_systemUptime()
    /// print("System Update Time: \(systemUptime)")
    /// ```
    static func dd_systemUptime() -> Date {
        let time = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: 0 - time)
    }

    /// 获取当前设备的类型
    /// - Returns: 当前设备的类型，如 "iPhone", "iPad", 等
    ///
    /// 示例:
    /// ```swift
    /// let deviceModel = UIDevice.dd_model()
    /// print("Device Model: \(deviceModel)")
    /// ```
    static func dd_model() -> String {
        return UIDevice.current.model
    }

    /// 获取当前系统的名称
    /// - Returns: 当前系统的名称，如 "iOS"
    ///
    /// 示例:
    /// ```swift
    /// let systemName = UIDevice.dd_systemName()
    /// print("System Name: \(systemName)")
    /// ```
    static func dd_systemName() -> String {
        return UIDevice.current.systemName
    }

    /// 获取当前设备的名称
    /// - Returns: 当前设备的名称
    ///
    /// 示例:
    /// ```swift
    /// let deviceName = UIDevice.dd_name()
    /// print("Device Name: \(deviceName)")
    /// ```
    static func dd_name() -> String {
        return UIDevice.current.name
    }

    /// 获取当前设备的语言
    /// - Returns: 当前设备的语言
    ///
    /// 示例:
    /// ```swift
    /// let deviceLanguage = UIDevice.dd_preferredLocalization()
    /// print("Device Language: \(deviceLanguage)")
    /// ```
    static func dd_preferredLocalization() -> String {
        return Bundle.main.preferredLocalizations[0]
    }

    /// 获取设备的区域化型号
    /// - Returns: 设备的区域化型号，如 "iPhone" 或 "iPad"
    ///
    /// 示例:
    /// ```swift
    /// let localizedModel = UIDevice.dd_localizedModel()
    /// print("Localized Model: \(localizedModel)")
    /// ```
    static func dd_localizedModel() -> String {
        return UIDevice.current.localizedModel
    }

    /// 获取设备的 CPU 核心数量
    /// - Returns: 设备的 CPU 核心数量
    ///
    /// 示例:
    /// ```swift
    /// let cpuCount = UIDevice.dd_cpuCount()
    /// print("CPU Count: \(cpuCount)")
    /// ```
    static func dd_cpuCount() -> Int {
        var ncpu = UInt(0)
        var len: size_t = MemoryLayout.size(ofValue: ncpu)
        sysctlbyname("hw.ncpu", &ncpu, &len, nil, 0)
        return Int(ncpu)
    }
}

// MARK: - 存储信息
public extension UIDevice {
    /// 获取当前硬盘的总空间
    /// - Returns: 当前硬盘的总空间（字节）
    ///
    /// 示例:
    /// ```swift
    /// let diskSpace = UIDevice.dd_diskSpace()
    /// print("Disk Space: \(diskSpace)")
    /// ```
    static func dd_diskSpace() -> Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    /// 获取当前硬盘的可用空间
    /// - Returns: 当前硬盘可用空间（字节）
    ///
    /// 示例:
    /// ```swift
    /// let freeDiskSpace = UIDevice.dd_diskSpaceFree()
    /// print("Free Disk Space: \(freeDiskSpace)")
    /// ```
    static func dd_diskSpaceFree() -> Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemFreeSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    /// 获取当前可用磁盘空间（字节）
    /// - Returns: 可用磁盘空间（字节）
    ///
    /// 示例:
    /// ```swift
    /// let freeSpaceInBytes = UIDevice.dd_freeDiskSpaceInBytes()
    /// print("Free Disk Space in Bytes: \(freeSpaceInBytes)")
    /// ```
    static func dd_freeDiskSpaceInBytes() -> Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
            {
                return freeSpace
            } else {
                return 0
            }
        }
    }

    /// 获取当前硬盘已经使用的空间
    /// - Returns: 当前硬盘已经使用的空间（字节）
    ///
    /// 示例:
    /// ```swift
    /// let usedDiskSpace = UIDevice.dd_diskSpaceUsed()
    /// print("Used Disk Space: \(usedDiskSpace)")
    /// ```
    static func dd_diskSpaceUsed() -> Int64 {
        let total = dd_diskSpace()
        let free = dd_diskSpaceFree()
        guard total > 0, free > 0 else {
            return -1
        }
        let used = total - free
        guard used > 0 else {
            return -1
        }

        return used
    }

    /// 获取设备的总内存大小
    /// - Returns: 设备的总内存大小（字节）
    ///
    /// 示例:
    /// ```swift
    /// let memoryTotal = UIDevice.dd_memoryTotal()
    /// print("Total Memory: \(memoryTotal)")
    /// ```
    static func dd_memoryTotal() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
}

// MARK: - 有关设备运营商的信息
public extension UIDevice {
    /// 获取SIM卡信息
    /// - Returns: 返回SIM卡信息的数组，如果没有找到信息，则返回nil
    ///
    /// 示例:
    /// ```swift
    /// if let simInfos = UIDevice.dd_simCardInfos() {
    ///     print("SIM Card Info: \(simInfos)")
    /// }
    /// ```
    static func dd_simCardInfos() -> [CTCarrier]? {
        return dd_getCarriers()
    }

    /// 获取当前的数据业务对应的通信技术
    /// - Returns: 返回一个包含通信技术的字符串数组，若无法获取则返回nil
    ///
    /// 示例:
    /// ```swift
    /// if let radioTech = UIDevice.dd_currentRadioAccessTechnologys() {
    ///     print("Current Radio Tech: \(radioTech)")
    /// }
    /// ```
    static func dd_currentRadioAccessTechnologys() -> [String]? {
        guard !CommonHelper.isSimulator else {
            return nil
        }
        // 获取运营商信息
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let currentRadioTechs = info.serviceCurrentRadioAccessTechnology else {
                return nil
            }
            return currentRadioTechs.dd_values()
        } else {
            guard let currentRadioTech = info.currentRadioAccessTechnology else {
                return nil
            }
            return [currentRadioTech]
        }
    }

    /// 获取设备当前的网络制式
    /// - Returns: 返回一个包含网络类型的字符串数组，若无法获取则返回nil
    ///
    /// 示例:
    /// ```swift
    /// if let networkTypes = UIDevice.dd_networkTypes() {
    ///     print("Network Types: \(networkTypes)")
    /// }
    /// ```
    static func dd_networkTypes() -> [String]? {
        guard let currentRadioTechs = dd_currentRadioAccessTechnologys() else {
            return nil
        }
        return currentRadioTechs.compactMap { dd_getNetworkType(currentRadioTech: $0) }
    }

    /// 获取运营商的名称
    /// - Returns: 返回运营商的名称数组，如果没有获取到运营商则返回nil
    ///
    /// 示例:
    /// ```swift
    /// if let carrierNames = UIDevice.dd_carrierNames() {
    ///     print("Carrier Names: \(carrierNames)")
    /// }
    /// ```
    static func dd_carrierNames() -> [String]? {
        guard let carriers = dd_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.carrierName! }
    }

    /// 获取设备的移动国家码(MCC)
    /// - Returns: 返回一个包含移动国家码的字符串数组
    ///
    /// 示例:
    /// ```swift
    /// if let mccCodes = UIDevice.dd_mobileCountryCodes() {
    ///     print("MCC Codes: \(mccCodes)")
    /// }
    /// ```
    static func dd_mobileCountryCodes() -> [String]? {
        guard let carriers = dd_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileCountryCode! }
    }

    /// 获取设备的移动网络码(MNC)
    /// - Returns: 返回一个包含移动网络码的字符串数组
    ///
    /// 示例:
    /// ```swift
    /// if let mncCodes = UIDevice.dd_mobileNetworkCodes() {
    ///     print("MNC Codes: \(mncCodes)")
    /// }
    /// ```
    static func dd_mobileNetworkCodes() -> [String]? {
        guard let carriers = dd_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileNetworkCode! }
    }

    /// 获取设备的ISO国家代码
    /// - Returns: 返回一个包含ISO国家代码的字符串数组
    ///
    /// 示例:
    /// ```swift
    /// if let isoCountryCodes = UIDevice.dd_isoCountryCodes() {
    ///     print("ISO Country Codes: \(isoCountryCodes)")
    /// }
    /// ```
    static func dd_isoCountryCodes() -> [String]? {
        guard let carriers = dd_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.isoCountryCode! }
    }

    /// 检查设备是否允许VoIP
    /// - Returns: 返回一个布尔值的数组，表示每个运营商是否允许VoIP
    ///
    /// 示例:
    /// ```swift
    /// if let voipAllowed = UIDevice.dd_isAllowsVOIPs() {
    ///     print("VoIP Allowed: \(voipAllowed)")
    /// }
    /// ```
    static func dd_isAllowsVOIPs() -> [Bool]? {
        guard let carriers = dd_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map(\.allowsVOIP)
    }

    /// 获取运营商信息
    /// - Returns: 返回一个包含运营商信息的数组，如果无法获取则返回nil
    private static func dd_getCarriers() -> [CTCarrier]? {
        guard !CommonHelper.isSimulator else {
            return nil
        }
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let providers = info.serviceSubscriberCellularProviders else {
                return []
            }
            return providers.filter { $0.value.carrierName != nil }.dd_values()
        } else {
            guard let carrier = info.subscriberCellularProvider, carrier.carrierName != nil else {
                return []
            }
            return [carrier]
        }
    }

    /// 根据无线接入技术信息获取网络类型
    /// - Parameter currentRadioTech: 当前的无线电接入技术信息
    /// - Returns: 返回网络类型字符串（如：2G、3G、4G、5G）
    private static func dd_getNetworkType(currentRadioTech: String) -> String {
        if #available(iOS 14.1, *), currentRadioTech == CTRadioAccessTechnologyNRNSA || currentRadioTech == CTRadioAccessTechnologyNR {
            return "5G"
        }
        var networkType = ""
        switch currentRadioTech {
        case CTRadioAccessTechnologyCDMA1x,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyGPRS:
            networkType = "2G"
        case CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyWCDMA:
            networkType = "3G"
        case CTRadioAccessTechnologyLTE:
            networkType = "4G"
        default:
            break
        }
        return networkType
    }

    /// 获取当前设备的运营商
    static var dd_deviceSupplier: String {
        let info = CTTelephonyNetworkInfo()
        var supplier = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.isEmpty {
                    return "无手机卡"
                } else {
                    for (index, carrier) in carriers.values.enumerated() {
                        guard carrier.carrierName != nil else {
                            return "无手机卡"
                        }
                        if index == 0 {
                            supplier = carrier.carrierName!
                        } else {
                            supplier = supplier + "," + carrier.carrierName!
                        }
                    }
                    return supplier
                }
            } else {
                return "无手机卡"
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else {
                    return "无手机卡"
                }
                return carrier.carrierName!
            } else {
                return "无手机卡"
            }
        }
    }
}

// MARK: - 设备控制
public extension UIDevice {
    /// 检查闪光灯是否开启
    /// - Returns: `true` 表示闪光灯已打开，`false` 表示闪光灯未打开
    static func dd_torchMode() -> Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("摄像头不可用，请检查设备")
            return false
        }
        return device.torchMode == .on
    }

    /// 设置闪光灯的开关状态
    /// - Parameter isOn: `true` 打开闪光灯，`false` 关闭闪光灯
    /// - Example:
    /// ```swift
    /// UIDevice.dd_torchMode(true) // 打开闪光灯
    /// UIDevice.dd_torchMode(false) // 关闭闪光灯
    /// ```
    static func dd_torchMode(_ isOn: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("摄像头不可用，请检查设备")
            return
        }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if isOn, device.torchMode == .off {
                    device.torchMode = .on
                }
                if !isOn, device.torchMode == .on {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("闪光灯配置错误: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 网络
public extension UIDevice {
    /// 获取当前连接Wi-Fi的名称和MAC地址
    /// - Returns: 一个包含Wi-Fi名称和MAC地址的元组，`(wifiName, macIP)`
    /// - Example:
    /// ```swift
    /// let (wifiName, macIP) = UIDevice.dd_wifiNameAndMacAddress()
    /// print(wifiName, macIP)
    /// ```
    static func dd_wifiNameAndMacAddress() -> (wifiName: String?, macIP: String?) {
        guard let interfaces: NSArray = CNCopySupportedInterfaces() else {
            return (nil, nil)
        }
        var ssid: String?
        var mac: String?
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
                mac = dict["BSSID"] as? String
            }
        }
        return (ssid, mac)
    }

    /// 获取当前设备的IP地址
    /// - Returns: 设备的IP地址，返回`nil`表示无法获取
    /// - Example:
    /// ```swift
    /// if let ip = UIDevice.dd_ipAddress() {
    ///     print("当前IP地址：\(ip)")
    /// } else {
    ///     print("无法获取IP地址")
    /// }
    /// ```
    static func dd_ipAddress() -> String? {
        var addresses = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                            if #available(iOS 18.0, *) {
                                if let address = String(validating: hostname, as: UTF8.self) {
                                    addresses.append(address)
                                }
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }

    /// 获取当前Wi-Fi网络的IP地址
    /// - Returns: 返回Wi-Fi的IP地址，如果无法获取，返回`nil`
    /// - Example:
    /// ```swift
    /// if let wifiIP = UIDevice.dd_wifiIPAddress() {
    ///     print("Wi-Fi IP地址：\(wifiIP)")
    /// } else {
    ///     print("无法获取Wi-Fi IP地址")
    /// }
    /// ```
    static func dd_wifiIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    if #available(iOS 18.0, *) {
                        address = String(validating: hostName, as: UTF8.self)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}
