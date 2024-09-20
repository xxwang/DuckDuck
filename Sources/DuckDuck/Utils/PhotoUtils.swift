//
//  PhotoUtils.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import Photos
import UIKit

// MARK: - AlbumResult
public enum AlbumResult {
    case success
    case error
    case denied
}

// MARK: - PhotoUtils
public class PhotoUtils: NSObject {
    /// 是否是编辑
    var isEditor: Bool = false
    /// 图片选择完成回调
    var completed: ((_ image: UIImage) -> Void)?
    /// 保存完成回调
    var saveCompleted: ((Bool) -> Void)?

    public static let shared = PhotoUtils()
    override private init() {}
}

public extension PhotoUtils {
    /// 打开相机
    ///
    /// - APP需要您的同意,才能访问相机进行拍摄/识别/视频通话,如禁止将无法拍摄/识别图片以及视频通话
    /// - Parameters:
    ///   - editor:是否是编辑状态
    ///   - complete:image回调
    func openCamera(editor: Bool, complete: @escaping (_ image: UIImage) -> Void) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("\(#file) - [\(#line)]:camera is invalid, please check")
            return nil
        }
        completed = complete
        isEditor = editor

        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .camera
        photo.allowsEditing = editor
        return photo
    }

    /// 打开相册
    ///
    /// - APP需要您的同意,才能访问相册进行选择照片上传/发布信息,如禁止将无法上传选择照片上传/发布信息
    /// - APP需要您的同意,才能将照片保存至相册,如禁止将无法保存图片
    /// - Parameters:
    ///   - editor:是否允许编辑
    ///   - complete:image回调
    func openPhotoLibrary(editor: Bool = false, complete: @escaping (_ image: UIImage) -> Void) -> UIImagePickerController {
        completed = complete
        isEditor = editor

        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .photoLibrary
        photo.allowsEditing = editor
        return photo
    }

    /// 保存图片
    func saveImage(_ image: UIImage, completed: ((Bool) -> Void)? = nil) {
        saveCompleted = completed
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
}

extension PhotoUtils {
    /// 保存照片完成回调
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        saveCompleted?(error == nil)
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PhotoUtils: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[isEditor ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true) {
            guard let completed = self.completed else {
                return
            }
            completed(image)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 保存图片到指定相册
public extension PhotoUtils {
    /// 判断是否授权
    var PHPhotoLibraryIsAuthorized: Bool {
        PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .notDetermined
    }

    /// 保存图片到自定义相册
    /// - Parameters:
    ///   - image:要保存的图片
    ///   - albumName:自定义相册名称
    ///   - completion:完成回调
    func saveImage2Album(_ image: UIImage, albumName: String = "", completion: ((_ result: AlbumResult) -> Void)?) {
        // 验证权限
        if !PHPhotoLibraryIsAuthorized {
            completion?(.denied)
            return
        }

        // 待写入图片的相册
        var assetAlbum: PHAssetCollection?

        // 如果指定相册名称为空,则保存到相机胶卷(否则保存到指定相册)
        if albumName.isEmpty {
            let list = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            assetAlbum = list.firstObject
        } else {
            let list = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            // 获取已存在同名相册
            list.enumerateObjects { album, _, stop in
                let assetCollection = album
                if albumName == assetCollection.localizedTitle {
                    assetAlbum = assetCollection
                    stop.initialize(to: true)
                }
            }

            // 不存在同名相册,创建相册
            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges {
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                } completionHandler: { isSuccess, error in
                    if isSuccess {
                        self.saveImage2Album(image, albumName: albumName, completion: completion)
                    } else {
                        DDLog.info(error?.localizedDescription ?? "")
                    }
                }
                return
            }

            // 保存图片
            PHPhotoLibrary.shared().performChanges {
                // 添加到相机胶卷
                let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
                if !albumName.isEmpty { // 添加到自定义相册
                    if let assetPlaceholder = result.placeholderForCreatedAsset {
                        let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetAlbum!)
                        albumChangeRequest?.addAssets([assetPlaceholder] as NSArray)
                    }
                }
            } completionHandler: { isSuccess, error in
                if isSuccess {
                    completion?(.success)
                } else {
                    DDLog.info(error?.localizedDescription ?? "")
                    completion?(.error)
                }
            }
        }
    }
}
