//
//  VideoUtils.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import AVFoundation
import AVKit
import Photos
import UIKit

public class VideoUtils {
    public static let shared = VideoUtils()
    private init() {}
}

// MARK: - 信息
public extension VideoUtils {
    /// 获取视频的总时长
    /// - Parameter path: 路径
    /// - Returns: 时长(秒)
    func videoDuration(path: String?) -> Double {
        guard let path, let url = path.dd_URL() else { return 0 }
        let asset = AVURLAsset(url: url)
        let time = asset.duration
        return Double(time.value / Int64(time.timescale))
    }
}

// MARK: - 播放
public extension VideoUtils {
    /// 播放视频(`AVPlayerViewController`)
    /// - Parameters:
    ///   - videoUrl:视频`URL`
    ///   - sourceController:弹出控制器的来源控制器
    func playVideo(with videoUrl: URL, sourceController: UIViewController) {
        let player = AVPlayer(url: videoUrl)
        let controller = AVPlayerViewController()
        controller.player = player
        sourceController.present(controller, animated: true) { player.play() }
    }
}

// MARK: - 截图
public extension VideoUtils {
    /// 截图视频封面(同步)
    /// - Parameter url:视频`URL`
    /// - Returns:封面图片
    func videoCover(with videoUrl: URL?) -> UIImage? {
        guard let videoUrl else { return nil }
        let asset = AVURLAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        // 截图的时候调整到正确的方向
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    /// 截图视频封面(异步)
    /// - Parameter url:视频`URL`
    /// - Parameter success:结果回调
    /// - Returns:封面图片
    static func videoCover(with videoUrl: URL, success: ((UIImage?) -> Void)?) {
        DispatchQueue.global().async {
            let options = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
            let avAsset = AVURLAsset(url: videoUrl, options: options)
            // 生成视频截图
            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            generator.apertureMode = .encodedPixels
            // 最大尺寸
//            generator.maximumSize = maximumSize
            let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
            var actualTime = CMTimeMake(value: 0, timescale: 0)
            var imageRef: CGImage?
            var image: UIImage?
            do {
                imageRef = try generator.copyCGImage(at: time, actualTime: &actualTime)
                if let cgimage = imageRef { image = UIImage(cgImage: cgimage) }
            } catch {
                DDLog.info("出现错误!\(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                success?(image)
            }
        }
    }
}

// MARK: - 保存/读取
public extension VideoUtils {
    /// 保存视频,`url`需要是本地路径
    /// - Parameters:
    ///   - url:视频保存的地址
    ///   - completed:完成回调
    func saveVideo(with videoUrl: URL, completed: ((Bool) -> Void)?) {
        if AuthorizationManager.shared.photoLibraryStatus == .authorized {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
            }) { success, error in
                if let error {
                    DDLog.info(error.localizedDescription)
                }
                completed?(success)
            }
        } else if AuthorizationManager.shared.photoLibraryStatus == .notDetermined {
            AuthorizationManager.shared.requestPhotoLibrary { granted in
                if granted {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
                    }) { success, error in
                        if let error {
                            DDLog.info(error.localizedDescription)
                        }
                        completed?(success)
                    }
                }
            }
        }
    }

    /// 视频格式转换&压缩`.mov`转成`.mp4`
    /// - Parameters:
    ///   - file:文件URL
    ///   - completed:完成回调
    func mov2mp4(_ videoUrl: URL, completed: ((URL) -> Void)?) {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        let output = "\(Date().dd_secondStamp()).mp4".dd_urlByCache()
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = output
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .failed:
                let exportError = exportSession.error
                if let exportError {
                    DDLog.info("AVAssetExportSessionStatusFailed:\(exportError.localizedDescription)")
                }
            case .completed:
                completed?(output)
            default: break
            }
        })
    }

    /// 从`PHAsset`中获取`MP4`链接
    /// - Parameters:
    ///   - asset:`PHAsset`
    ///   - completed:完成回调
    func mp4Path(from asset: PHAsset, completed: ((String?) -> Void)?) {
        let assetResources = PHAssetResource.assetResources(for: asset)
        var _resource: PHAssetResource?
        for res in assetResources {
            if res.type == .video {
                _resource = res
                break
            }
        }
        guard let resource = _resource else {
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
            PHAssetResourceManager.default().writeData(for: resource, toFile: URL(fileURLWithPath: savePath), options: nil, completionHandler: { error in
                if let error {
                    DDLog.info("convert mp4 failed. \(error)")
                    completed?(nil)
                } else {
                    DDLog.info("convert mp4 success")
                    completed?(savePath)
                }
            })
        }
    }
}
