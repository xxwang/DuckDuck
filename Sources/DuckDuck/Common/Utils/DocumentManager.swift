import UIKit
import UniformTypeIdentifiers

/// 文件操作回调类型
public typealias FileOperationCallback = (
    _ isOk: Bool,
    _ data: Data?,
    _ fileNames: [String]?,
    _ error: Error?
) -> Void

@MainActor
public class DocumentManager: NSObject {
    /// 文件操作回调
    var operationCompletion: FileOperationCallback?

    /// 检查 iCloud 是否启用
    var isICloudEnabled: Bool {
        return FileManager.default.url(forUbiquityContainerIdentifier: nil) != nil
    }

    /// 单例实例
    public static let shared = DocumentManager()

    override private init() {}
}

// MARK: - 打开文件
public extension DocumentManager {
    /// 打开文件选择器
    /// - Parameters:
    ///   - allowedTypes: 支持的文件类型标识符列表（例如 ["public.text", "com.apple.iwork.pages.pages"]）
    ///   - completion: 操作完成后的回调，返回操作结果
    ///
    /// - Example:
    /// ```swift
    /// DocumentManager.shared.presentDocumentPicker(forAllowedTypes: ["public.text"]) { isOk, data, fileNames, error in
    ///     if isOk {
    ///         // 处理文件
    ///     } else {
    ///         // 处理错误
    ///     }
    /// }
    /// ```
    func presentDocumentPicker(forAllowedTypes allowedTypes: [String], completion: @escaping FileOperationCallback) {
        self.operationCompletion = completion

        // 使用 UTType 指定文件类型
        let documentTypes = allowedTypes.compactMap { UTType($0) }

        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        if let controller = UIWindow.dd_rootViewController() {
            controller.dd_present(documentPicker)
        }
    }

    /// 打开多个文件选择器
    /// - Parameters:
    ///   - allowedTypes: 支持的文件类型
    ///   - completion: 操作完成后的回调，返回操作结果
    ///
    /// - Example:
    /// ```swift
    /// DocumentManager.shared.presentMultipleDocumentsPicker(forAllowedTypes: ["public.text"]) { isOk, data, fileNames, error in
    ///     if isOk {
    ///         // 处理多个文件
    ///     } else {
    ///         // 处理错误
    ///     }
    /// }
    /// ```
    func presentMultipleDocumentsPicker(forAllowedTypes allowedTypes: [String], completion: @escaping FileOperationCallback) {
        self.operationCompletion = completion

        // 使用 UTType 指定文件类型
        let documentTypes = allowedTypes.compactMap { UTType($0) }

        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        documentPicker.allowsMultipleSelection = true
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        if let controller = UIWindow.dd_rootViewController() {
            controller.dd_present(documentPicker)
        }
    }
}

// MARK: - UIDocumentPickerDelegate
extension DocumentManager: UIDocumentPickerDelegate {
    /// 文件选择回调
    /// - Parameters:
    ///   - controller: UIDocumentPickerViewController
    ///   - urls: 选择的文件 URL 数组
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else {
            self.operationCompletion?(false, nil, nil, NSError(domain: "DocumentManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No file selected"]))
            return
        }

        // 获取文件名
        let fileName = fileURL.lastPathComponent

        // 判断是否启用 iCloud
        if isICloudEnabled {
            Task {
                do {
                    let fileData = try await downloadFile(from: fileURL)
                    self.operationCompletion?(true, fileData, [fileName], nil)
                } catch {
                    self.operationCompletion?(false, nil, nil, error)
                }
            }
        } else {
            // 提示用户开启 iCloud
            UIApplication.shared.dd_promptToOpenSettings(
                title: "请允许使用【iCloud】云盘",
                message: nil,
                cancelTitle: "取消",
                confirmTitle: "确认",
                parentController: UIWindow.dd_rootViewController()
            )
        }
    }

    /// 用户取消文件选择回调
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.operationCompletion?(false, nil, nil, NSError(domain: "DocumentManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "File picker was cancelled"]))
    }
}

// MARK: - 文件下载功能
public extension DocumentManager {
    /// 下载文件
    /// - Parameter documentURL: 文件 URL
    /// - Returns: 文件数据
    /// - Throws: 文件下载过程中发生的错误
    ///
    /// - Example:
    /// ```swift
    /// Task {
    ///     do {
    ///         let fileData = try await DocumentManager.shared.downloadFile(from: documentURL)
    ///         // 处理文件数据
    ///     } catch {
    ///         print("文件下载失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func downloadFile(from documentURL: URL) async throws -> Data? {
        let document = UIDocument(fileURL: documentURL)
        if await document.open() {
            return try Data(contentsOf: document.fileURL)
        }
        await document.close()
        return nil
    }

    /// 下载文件并保存到本地
    /// - Parameter documentURL: 文件 URL
    /// - Returns: 保存文件的本地路径
    /// - Throws: 文件下载过程中发生的错误
    ///
    /// - Example:
    /// ```swift
    /// Task {
    ///     do {
    ///         let savedURL = try await DocumentManager.shared.downloadAndSaveFile(from: documentURL)
    ///         print("文件已保存到: \(savedURL.path)")
    ///     } catch {
    ///         print("文件保存失败: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    func downloadAndSaveFile(from documentURL: URL) async throws -> URL {
        let fileData = try await downloadFile(from: documentURL)

        let fileName = documentURL.lastPathComponent
        let filePath = makeFilePath(forFileName: fileName)

        try fileData?.write(to: filePath)
        return filePath
    }

    /// 生成文件保存路径
    /// - Parameter fileName: 文件名称
    /// - Returns: 文件路径
    private func makeFilePath(forFileName fileName: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
