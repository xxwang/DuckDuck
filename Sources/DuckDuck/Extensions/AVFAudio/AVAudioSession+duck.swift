//
//  AVAudioSession+duck.swift
//
//
//  Created by 王哥 on 2024/7/10.
//

import AVFAudio

// MARK: - 静态方法
public extension DDExtension where Base: AVAudioSession {
    /// 蓝牙耳机支持
    static func setAudioSessionActive(_ isActive: Bool = true) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
            try session.setActive(isActive)
        } catch {
            DDLog.error(error.localizedDescription)
        }
    }
}
