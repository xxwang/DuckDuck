//
//  VideoManager.swift
//  DuckDuck
//
//  Created by xxwang on 21/11/2024.
//

import AVFoundation
import AVKit
import Photos
import UIKit

@MainActor
public class VideoManager {
    // 单例实例
    public static let shared = VideoManager()
    private init() {}
}

// MARK: - 信息获取
public extension VideoManager {
    /// 获取视频的总时长
    /// - Parameter path: 视频文件的路径，类型为 `String?`，如果为 `nil` 或无效路径将返回 `0`
    /// - Returns: 返回视频时长（单位：秒），若路径无效返回 `0`
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     let duration = await VideoManager.shared.videoDuration(from: "path/to/video.mp4")
    ///     print("视频时长：\(duration)秒")
    /// }
    /// ```
    func videoDuration(from path: String?) async -> Double {
        // 确保路径有效且能够转换为 URL
        guard let path, let url = path.dd_toURL() else { return 0 }

        let asset = AVURLAsset(url: url) // 使用 AVURLAsset 获取视频资产

        // iOS 16 及以上版本使用 load(.duration)，其他版本继续使用 duration 属性
        if #available(iOS 16.0, *) {
            do {
                let time = try await asset.load(.duration)
                return Double(time.value) / Double(time.timescale)
            } catch {
                // 如果加载失败或出现错误，返回默认值
                Logger.fail("Error loading video duration: \(error.localizedDescription)")
                return 0
            }
        } else {
            // 对于 iOS 16 以下版本，继续使用原来的 duration 属性
            let time = asset.duration
            return Double(time.value) / Double(time.timescale)
        }
    }
}

// MARK: - 视频播放
public extension VideoManager {
    /// 播放视频 (`AVPlayerViewController`)
    /// - Parameters:
    ///   - videoUrl: 视频文件的 URL
    ///   - sourceController: 发起播放的视图控制器
    ///
    /// - Example:
    /// ```swift
    /// if let url = URL(string: "path/to/video.mp4") {
    ///     VideoManager.shared.playVideo(from: url, in: self)
    /// }
    /// ```
    func playVideo(from videoUrl: URL, in sourceController: UIViewController) {
        // 创建播放器实例
        let player = AVPlayer(url: videoUrl)
        // 创建播放器控制器
        let controller = AVPlayerViewController()
        controller.player = player
        // 弹出播放器控制器
        sourceController.present(controller, animated: true) {
            // 播放视频
            player.play()
        }
    }
}

// MARK: - 视频截图
public extension VideoManager {
    /// 截图视频封面(异步)
    /// - Parameter videoUrl: 视频 `URL`
    /// - Parameter success: 成功回调，返回封面图片
    ///
    /// - Example:
    /// ```swift
    /// VideoManager.shared.captureVideoCover(with: videoUrl) { image in
    ///     if let coverImage = image {
    ///         print("视频封面截图成功")
    ///     }
    /// }
    /// ```
    func captureVideoCover(with videoUrl: URL, success: @escaping @Sendable (UIImage?) -> Void) {
        Task {
            let asset = AVURLAsset(url: videoUrl)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1.0, preferredTimescale: 600)

            // iOS 18 及以上使用异步方法
            if #available(iOS 18.0, *) {
                imageGenerator.generateCGImageAsynchronously(for: time) { cgImage, actualTime, error in
                    if let error {
                        DispatchQueue.main.async {
                            Logger.fail("图片生成失败: \(error.localizedDescription)")
                            success(nil)
                        }
                        return
                    }
                    if let cgImage {
                        DispatchQueue.main.async {
                            success(UIImage(cgImage: cgImage))
                        }
                    }
                }
            } else {
                // 对于旧版 iOS，继续使用同步方法
                var actualTime = CMTime.zero
                do {
                    let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
                    DispatchQueue.main.async {
                        success(UIImage(cgImage: cgImage))
                    }
                } catch {
                    Logger.fail("生成视频封面时发生错误：\(error.localizedDescription)")
                    DispatchQueue.main.async {
                        success(nil)
                    }
                }
            }
        }
    }
}

// MARK: - 视频保存与读取
public extension VideoManager {
    /// 将视频保存到相册
    /// - Parameters:
    ///   - videoUrl: 视频文件的 URL，必须是本地路径
    ///   - completed: 完成回调，返回保存结果
    ///
    /// - Example:
    /// ```swift
    /// async {
    ///     await VideoManager.shared.saveVideoToGallery(from: videoUrl) { success in
    ///         print(success ? "视频保存成功" : "视频保存失败")
    ///     }
    /// }
    /// ```
    func saveVideoToGallery(from videoUrl: URL, completed: @escaping (Bool) -> Void) async {
        // 获取相册权限状态
        let status = AuthorizationManager.shared.albumAuthorizationStatus

        if status == .authorized {
            // 已授权，直接保存视频
            saveVideoToGallery(videoUrl: videoUrl, completed: completed)
        } else if status == .notDetermined {
            // 如果权限尚未确定，申请授权
            let granted = await AuthorizationManager.shared.requestAlbumAuthorization()
            if granted {
                // 授权成功后保存视频
                saveVideoToGallery(videoUrl: videoUrl, completed: completed)
            } else {
                // 授权失败，返回失败结果
                DispatchQueue.main.async {
                    completed(false)
                }
            }
        } else {
            // 已拒绝权限，返回失败结果
            DispatchQueue.main.async {
                completed(false)
            }
        }
    }

    /// 保存视频到相册
    /// - Parameters:
    ///   - videoUrl: 视频文件的 URL，必须是本地路径
    ///   - completed: 完成回调，返回保存结果
    private func saveVideoToGallery(videoUrl: URL, completed: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
        }) { success, error in
            if let error {
                Logger.fail("Error saving video: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completed(success)
            }
        }
    }

    /// 从 `PHAsset` 获取视频的 `.mp4` 格式路径
    /// - Parameters:
    ///   - asset: `PHAsset` 对象
    ///   - completed: 完成回调，返回 `.mp4` 文件路径
    ///
    /// - Example:
    /// ```swift
    /// VideoManager.shared.mp4Path(from: phAsset) { mp4Path in
    ///     print("MP4文件路径：\(mp4Path)")
    /// }
    /// ```
    func mp4Path(from asset: PHAsset, completed: ((String?) -> Void)?) {
        let assetResources = PHAssetResource.assetResources(for: asset)
        var videoResource: PHAssetResource?
        for res in assetResources {
            if res.type == .video {
                videoResource = res
                break
            }
        }
        guard let resource = videoResource else {
            completed?(nil)
            return
        }
        let fileName = resource.originalFilename.components(separatedBy: ".")[0] + ".mp4"

        if asset.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            let savePath = NSTemporaryDirectory() + fileName
            if FileManager.default.fileExists(atPath: savePath) {
                completed?(savePath)
                return
            }
            PHAssetResourceManager.default().writeData(for: resource, toFile: URL(fileURLWithPath: savePath), options: nil) { error in
                if let error {
                    Logger.fail("Failed to convert to mp4: \(error)")
                    completed?(nil)
                } else {
                    Logger.fail("Successfully converted to mp4")
                    completed?(savePath)
                }
            }
        }
    }
}

// MARK: - 格式转换
public extension VideoManager {
    /// 将 MOV 格式视频转换为 MP4（适用于 iOS 18.0 及以上）
    ///
    /// 此方法使用异步导出功能实现高效的 MOV 到 MP4 格式转换。
    ///
    /// - Parameters:
    ///   - videoUrl: 输入的 MOV 格式视频文件的 URL。
    /// - Returns: 转换后的 MP4 格式视频文件的 URL。
    /// - Throws: 如果转换失败，抛出相应的错误。
    ///
    /// ## 示例
    /// ```swift
    /// do {
    ///     let videoUrl = URL(fileURLWithPath: "path/to/video.mov")
    ///     let convertedUrl = try await VideoManager().mov2mp4(from: videoUrl)
    ///     print("Converted video saved to: \(convertedUrl)")
    /// } catch {
    ///     print("Failed to convert video: \(error)")
    /// }
    /// ```
    @available(iOS 18.0, *)
    func mov2mp4(from videoUrl: URL) async throws -> URL {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            throw NSError(domain: "AVAssetExportSessionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create export session"])
        }

        // 获取输出 URL
        let outputUrl = "\(UUID().uuidString).mp4".dd_urlInCachesDirectory()

        exportSession.outputURL = outputUrl
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        try await exportSession.export(to: outputUrl, as: .mp4)

        return outputUrl
    }

    /// 将 MOV 格式视频转换为 MP4（适用于 iOS 10.0 及以上）
    ///
    /// 此方法兼容 iOS 10.0 至 17.0，并在 iOS 18.0 中自动使用新的异步导出功能。
    ///
    /// - Parameters:
    ///   - videoUrl: 输入的 MOV 格式视频文件的 URL。
    ///   - completion: 异步回调，返回转换后的 MP4 文件 URL（若转换失败，则返回 nil）。
    ///
    /// ## 示例
    /// ```swift
    /// let videoUrl = URL(fileURLWithPath: "path/to/video.mov")
    /// VideoManager().mov2mp4(from: videoUrl) { convertedUrl in
    ///     if let url = convertedUrl {
    ///         print("Converted video saved to: \(url)")
    ///     } else {
    ///         print("Failed to convert video.")
    ///     }
    /// }
    /// ```
    @available(iOS 10.0, *)
    func mov2mp4(from videoUrl: URL, completion: @Sendable @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            completion(nil)
            return
        }

        // 获取输出 URL
        let outputUrl = "\(UUID().uuidString).mp4".dd_urlInCachesDirectory()
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = outputUrl
        exportSession.outputFileType = .mp4

        if #available(iOS 18.0, *) {
            // 使用新的异步方法
            Task {
                do {
                    try await exportSession.export(to: outputUrl, as: .mp4)
                    completion(outputUrl)
                } catch {
                    completion(nil)
                }
            }
        } else {
            // 导出会话包装类
            class ExportSessionWrapper: @unchecked Sendable {
                private let exportSession: AVAssetExportSession
                init(exportSession: AVAssetExportSession) {
                    self.exportSession = exportSession
                }

                @available(iOS, introduced: 10.0, deprecated: 18.0)
                func export(completion: @Sendable @escaping (Bool) -> Void) {
                    exportSession.exportAsynchronously {
                        switch self.exportSession.status {
                        case .completed:
                            completion(true)
                        default:
                            completion(false)
                        }
                    }
                }
            }

            // 使用旧版的异步方法
            let session = ExportSessionWrapper(exportSession: exportSession)
            session.export { success in
                completion(success ? outputUrl : nil)
            }
        }
    }
}
