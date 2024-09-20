//
//  AudioUtils.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import AVFoundation
import AVKit
import UIKit

public class AudioUtils {
    public static let shared = AudioUtils()
    private init() {}
}

// MARK: - 播放声音
public extension AudioUtils {
    /// 播放`Bundle`中的音频文件
    /// - Parameters:
    ///   - audioName: 音频文件名称
    ///   - loops: 循环播放次数(`-1`为持续播放)
    /// - Returns: `AVAudioPlayer?`
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
    /// - Returns: `AVAudioPlayer?`
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
            DDLog.debug(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - 播放音效
public extension AudioUtils {
    /// 播放指定`文件名称`的音效
    /// - Parameters:
    ///   - soundName: 音效文件名称
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
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

    /// 播放指定`SoundID`
    /// - Parameters:
    ///   - soundID: 音效ID
    ///   - isShake: 是否震动
    ///   - completion: 完成回调
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
public extension AudioUtils {
    enum ShakeLevel {
        /// 标准长震动
        case standard
        /// 普通短震`3D Touch`中`Peek`震动反馈
        case normal
        /// 普通短震`3D Touch`中`Pop`震动反馈`home键`的振动
        case middle
        /// 连续三次短震
        case three
        /// 持续震动
        case always

        /// 系统音效ID
        var soundID: SystemSoundID {
            switch self {
            case .standard:
                return kSystemSoundID_Vibrate
            case .normal:
                return SystemSoundID(1519)
            case .middle:
                return SystemSoundID(1520)
            case .three:
                return SystemSoundID(1521)
            case .always:
                return kSystemSoundID_Vibrate
            }
        }
    }

    /// 震动
    /// - Parameters:
    ///   - level: 震动级别`类型`
    ///   - completion: 完成回调, 如果`level == .always`回调不执行
    func shake(_ level: ShakeLevel, completion: (() -> Void)? = nil) {
        if level == .always { // 持续震动
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

    /// 停止震动
    func stopShake() {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
    }
}
