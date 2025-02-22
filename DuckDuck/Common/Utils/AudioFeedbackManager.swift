import AVFoundation
import AVKit
import UIKit

/// 管理音频播放与震动（触觉反馈）
public class AudioFeedbackManager {
    public static let shared = AudioFeedbackManager()
    private init() {}
}

// MARK: - 播放声音
public extension AudioFeedbackManager {
    /// 播放`Bundle`中的音频文件
    /// - Parameters:
    ///   - audioName: 音频文件名称
    ///   - loops: 循环播放次数(`-1`为持续播放)
    /// - Returns: `AVAudioPlayer?` 返回音频播放器实例
    ///
    /// - Example:
    /// ```swift
    /// let player = AudioFeedbackManager.shared.playAudio(with: "background_music.mp3", loops: -1)
    /// ```
    @discardableResult
    func playAudio(with audioName: String?, loops: Int = 0) -> AVAudioPlayer? {
        guard let audioURL = Bundle.main.url(forResource: audioName, withExtension: nil) else {
            return nil
        }
        return playAudio(with: audioURL, loops: loops)
    }

    /// 播放网络音频文件(`音频文件URL`)
    /// - Parameters:
    ///   - audioUrl: 音频文件`URL`
    ///   - loops: 循环播放次数(`-1`为持续播放)
    /// - Returns: `AVAudioPlayer?` 返回音频播放器实例
    ///
    /// - Example:
    /// ```swift
    /// let url = URL(string: "https://example.com/audio.mp3")
    /// let player = AudioFeedbackManager.shared.playAudio(with: url, loops: 1)
    /// ```
    @discardableResult
    func playAudio(with audioUrl: URL?, loops: Int = 0) -> AVAudioPlayer? {
        guard let audioUrl else { return nil }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            try session.setCategory(.playback)

            let player = try AVAudioPlayer(contentsOf: audioUrl)
            player.prepareToPlay()
            player.numberOfLoops = loops
            player.play()

            return player
        } catch {
            Logger.debug(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - 播放音效
public extension AudioFeedbackManager {
    /// 播放指定`文件名称`的音效
    /// - Parameters:
    ///   - soundName: 音效文件名称
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
    ///
    /// - Example:
    /// ```swift
    /// AudioFeedbackManager.shared.playSound(with: "success_sound.mp3", isShake: true) {
    ///     print("Sound finished playing")
    /// }
    /// ```
    func playSound(with soundName: String?,
                   isShake: Bool = false,
                   completion: (() -> Void)? = nil)
    {
        guard let soundName else { return }
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil) else { return }
        playSound(with: soundURL, isShake: isShake, completion: completion)
    }

    /// 播放指定`URL`的音效
    /// - Parameters:
    ///   - soundUrl: 音效`URL`地址
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
    ///
    /// - Example:
    /// ```swift
    /// let soundUrl = URL(string: "https://example.com/success_sound.mp3")
    /// AudioFeedbackManager.shared.playSound(with: soundUrl, isShake: false) {
    ///     print("Sound finished playing")
    /// }
    /// ```
    func playSound(with soundUrl: URL?,
                   isShake: Bool = false,
                   completion: (() -> Void)? = nil)
    {
        guard let soundUrl else { return }
        let soundCFURL = soundUrl as CFURL
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundCFURL, &soundID)
        playSound(with: soundID, isShake: isShake, completion: completion)
    }

    /// 播放指定`SoundID`音效
    /// - Parameters:
    ///   - soundID: 音效ID
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
    ///
    /// - Example:
    /// ```swift
    /// AudioFeedbackManager.shared.playSound(with: soundID, isShake: true) {
    ///     print("Sound finished playing")
    /// }
    /// ```
    func playSound(with soundID: SystemSoundID,
                   isShake: Bool = false,
                   completion: (() -> Void)? = nil)
    {
        if isShake {
            AudioServicesPlayAlertSoundWithCompletion(soundID) {
                AudioServicesDisposeSystemSoundID(soundID)
                completion?()
            }
        } else {
            AudioServicesPlaySystemSoundWithCompletion(soundID) {
                completion?()
            }
        }
    }
}

// MARK: - 震动
public extension AudioFeedbackManager {
    /// 震动级别
    enum HapticFeedbackLevel {
        case standard // 标准震动
        case normal // 普通震动（短）
        case middle // 中等震动（短）
        case threeShort // 连续短震
        case continuous // 持续震动

        /// 对应的系统音效ID
        var soundID: SystemSoundID {
            switch self {
            case .standard:
                return kSystemSoundID_Vibrate
            case .normal:
                return SystemSoundID(1519)
            case .middle:
                return SystemSoundID(1520)
            case .threeShort:
                return SystemSoundID(1521)
            case .continuous:
                return kSystemSoundID_Vibrate
            }
        }
    }

    /// 触发震动或触觉反馈
    /// - Parameters:
    ///   - level: 震动级别
    ///   - completion: 完成回调，`continuous`级别不执行回调
    ///
    /// - Example:
    /// ```swift
    /// AudioFeedbackManager.shared.triggerHapticFeedback(level: .normal) {
    ///     print("Vibration finished")
    /// }
    /// ```
    func triggerHapticFeedback(level: HapticFeedbackLevel, completion: (() -> Void)? = nil) {
        if level == .continuous {
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, nil, nil, { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }, nil)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } else {
            AudioServicesPlaySystemSoundWithCompletion(level.soundID) {
                completion?()
            }
        }
    }

    /// 停止触觉反馈或震动
    ///
    /// - Example:
    /// ```swift
    /// AudioFeedbackManager.shared.stopHapticFeedback()
    /// ```
    func stopHapticFeedback() {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
    }
}
