import Photos
import UIKit

// MARK: - PhotoAlbumResult
/// 用于表示相册操作的结果
public enum PhotoAlbumResult {
    case success // 保存成功
    case error // 保存失败
    case denied // 权限被拒绝
}

// MARK: - PhotoManager
/// 管理照片操作，包括相机、相册选择和自定义相册保存功能
@MainActor
public class PhotoManager: NSObject {
    /// 是否为编辑状态，决定是否允许编辑图片
    var isEditingEnabled: Bool = false
    /// 图片选择完成后的回调
    var imageSelectionHandler: ((_ image: UIImage) -> Void)?
    /// 保存图片完成后的回调
    var saveCompletionHandler: ((Bool) -> Void)?

    /// 单例实例
    public static let shared = PhotoManager()
    override private init() {}
}

public extension PhotoManager {
    /// 打开相机进行拍摄
    ///
    /// - Parameters:
    ///   - isEditingEnabled: 是否启用编辑功能
    ///   - completion: 图片选择后的回调
    /// - Returns: 返回 UIImagePickerController 相机控制器实例
    /// - Example:
    ///   ```swift
    ///   let cameraController = PhotoManager.shared.openCamera(isEditingEnabled: true) { image in
    ///       // 处理拍摄后的图片
    ///   }
    ///   ```
    func openCamera(isEditingEnabled: Bool, completion: @escaping (_ image: UIImage) -> Void) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("\(#file) - [\(#line)]: Camera is unavailable.")
            return nil
        }
        self.imageSelectionHandler = completion
        self.isEditingEnabled = isEditingEnabled

        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        cameraController.allowsEditing = isEditingEnabled
        return cameraController
    }

    /// 打开相册选择图片
    ///
    /// - Parameters:
    ///   - isEditingEnabled: 是否允许编辑
    ///   - completion: 图片选择后的回调
    /// - Returns: 返回 UIImagePickerController 相册控制器实例
    /// - Example:
    ///   ```swift
    ///   let photoLibraryController = PhotoManager.shared.openPhotoLibrary(isEditingEnabled: false) { image in
    ///       // 处理选择的图片
    ///   }
    ///   ```
    func openPhotoLibrary(isEditingEnabled: Bool = false, completion: @escaping (_ image: UIImage) -> Void) -> UIImagePickerController {
        self.imageSelectionHandler = completion
        self.isEditingEnabled = isEditingEnabled

        let photoLibraryController = UIImagePickerController()
        photoLibraryController.delegate = self
        photoLibraryController.sourceType = .photoLibrary
        photoLibraryController.allowsEditing = isEditingEnabled
        return photoLibraryController
    }

    /// 保存图片到相册
    ///
    /// - Parameters:
    ///   - image: 要保存的图片
    ///   - completion: 保存完成后的回调
    /// - Example:
    ///   ```swift
    ///   PhotoManager.shared.saveImageToLibrary(image) { success in
    ///       if success {
    ///           print("Image saved successfully.")
    ///       } else {
    ///           print("Failed to save image.")
    ///       }
    ///   }
    ///   ```
    func saveImageToLibrary(_ image: UIImage, completion: ((Bool) -> Void)? = nil) {
        self.saveCompletionHandler = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveCompletion(image:didFinishSavingWithError:contextInfo:)), nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PhotoManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 处理图片选择后完成的回调
    ///
    /// - Parameters:
    ///   - picker: 当前 UIImagePickerController 实例
    ///   - info: 包含选中的媒体信息
    /// - Example:
    ///   ```swift
    ///   // 此方法会在图片选择完后自动调用
    ///   photoManager.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
    ///   ```
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 获取选中的图片，如果是编辑状态则使用编辑后的图片，否则使用原始图片
        guard let selectedImage = info[isEditingEnabled ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true) {
            // 完成后回调返回选中的图片
            self.imageSelectionHandler?(selectedImage)
        }
    }

    /// 取消选择图片时的回调
    ///
    /// - Parameters:
    ///   - picker: 当前 UIImagePickerController 实例
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Custom Album Management
public extension PhotoManager {
    /// 检查是否有权限访问相册
    ///
    /// - Returns: 是否有权限访问相册
    /// - Example:
    ///   ```swift
    ///   if PhotoManager.shared.isPhotoLibraryAuthorized {
    ///       // 有权限
    ///   } else {
    ///       // 没有权限
    ///   }
    ///   ```
    var isPhotoLibraryAuthorized: Bool {
        PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .notDetermined
    }

    /// 将图片保存到自定义相册
    ///
    /// - Parameters:
    ///   - image: 要保存的图片
    ///   - albumName: 自定义相册的名称
    ///   - completion: 完成回调
    /// - Example:
    ///   ```swift
    ///   PhotoManager.shared.saveImageToCustomAlbum(image, albumName: "MyAlbum") { result in
    ///       switch result {
    ///       case .success:
    ///           print("Image saved successfully.")
    ///       case .error:
    ///           print("Failed to save image.")
    ///       case .denied:
    ///           print("Permission denied.")
    ///       }
    ///   }
    ///   ```
    func saveImageToCustomAlbum(_ image: UIImage, albumName: String = "", completion: ((_ result: PhotoAlbumResult) -> Void)?) {
        // 检查相册权限
        guard isPhotoLibraryAuthorized else {
            completion?(.denied)
            return
        }

        // 查找目标相册
        var targetAlbum: PHAssetCollection?

        if albumName.isEmpty {
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            targetAlbum = smartAlbums.firstObject
        } else {
            let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            albums.enumerateObjects { album, _, stop in
                if album.localizedTitle == albumName {
                    targetAlbum = album
                    stop.initialize(to: true)
                }
            }

            // 如果没有找到相册，则创建新的相册
            if targetAlbum == nil {
                PHPhotoLibrary.shared().performChanges {
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                } completionHandler: { success, error in
                    if success {
                        self.saveImageToCustomAlbum(image, albumName: albumName, completion: completion)
                    } else {
                        print("Error creating album: \(error?.localizedDescription ?? "")")
                    }
                }
                return
            }
        }

        // 将图片保存到相册
        PHPhotoLibrary.shared().performChanges {
            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if !albumName.isEmpty, let albumPlaceholder = assetRequest.placeholderForCreatedAsset {
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: targetAlbum!)
                albumChangeRequest?.addAssets([albumPlaceholder] as NSArray)
            }
        } completionHandler: { success, error in
            if success {
                completion?(.success)
            } else {
                print("Error saving image to album: \(error?.localizedDescription ?? "")")
                completion?(.error)
            }
        }
    }
}

extension PhotoManager {
    /// 保存图片完成后的回调
    ///
    /// - Parameters:
    ///   - image: 保存的图片
    ///   - error: 是否发生错误
    ///   - contextInfo: 上下文信息
    @objc private func imageSaveCompletion(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        saveCompletionHandler?(error == nil)
    }
}
