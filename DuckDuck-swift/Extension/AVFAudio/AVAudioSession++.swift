import AVFAudio

// MARK: - AVAudioSession扩展
public extension AVAudioSession {
    /// 设置音频会话为蓝牙耳机支持模式
    /// - Parameter isActive: 是否激活音频会话，默认为 `true`
    /// - Throws: 如果设置失败，抛出错误
    ///
    /// - Example:
    /// ```swift
    /// do {
    ///     try AVAudioSession.dd_setBluetoothAudioSession(active: true)
    ///     print("音频会话已激活并支持蓝牙耳机")
    /// } catch {
    ///     print("音频会话设置失败：\(error.localizedDescription)")
    /// }
    /// ```
    static func dd_setBluetoothAudioSession(active isActive: Bool = true) throws {
        let session = AVAudioSession.sharedInstance()
        do {
            // 设置音频会话类别、模式和选项
            try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
            // 激活或停用音频会话
            try session.setActive(isActive)
        } catch {
            // 抛出错误以便调用方处理
            throw error
        }
    }
}
