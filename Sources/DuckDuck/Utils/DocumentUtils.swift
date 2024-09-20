//
//  DocumentUtils.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import UIKit

public class DocumentUtils: NSObject {
    /// 文件回调
    var completion: ((_ isOk: Bool, _ data: Data?, _ fileName: String?) -> Void)?

    /// iCloud是否开启
    var iCloudEnable: Bool {
        let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        return url != nil
    }

    public static let shared = DocumentUtils()
    override private init() {}
}

// MARK: - 打开文件
public extension DocumentUtils {
    /// 打开文件
    /// - `Capabilities` -> `iCloud` -> `iCould Documents`允许访问文件
    /// - `Containers` -> `+` -> `iCloud.bundleid` 允许下载icloud资源
    /// - Parameters:
    ///   - types:需要的文件类型
    ///   - mode:操作模式
    ///   - complete:完成回调(文件数据,文件名)
    func openDocument(_ types: [String], mode: UIDocumentPickerMode, complete: @escaping (_ isOk: Bool, _ data: Data?, _ fileName: String?) -> Void) {
        completion = complete
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: types, in: mode)
        documentPickerViewController.delegate = self
        documentPickerViewController.modalPresentationStyle = .fullScreen
        UIWindow.dd_window()?.rootViewController?.dd_present(viewController: documentPickerViewController)
    }
}

// MARK: - UIDocumentPickerDelegate
extension DocumentUtils: UIDocumentPickerDelegate {
    /// 文件选择回调
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let fileName = url.lastPathComponent

        if iCloudEnable {
            download(url) { fileData in self.completion?(true, fileData, fileName) }
        } else {
            UIApplication.shared.dd_openSettings("请允许使用【iCloud】云盘",
                                                 message: nil,
                                                 cancel: "取消",
                                                 confirm: "确认",
                                                 parent: UIWindow.dd_window()?.rootViewController)
        }
    }

    /// 用户关闭文件选择控制器回调
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion?(false, nil, nil)
    }
}

// MARK: - 下载文件
public extension DocumentUtils {
    /// 下载文件
    func download(_ documentUrl: URL, completion: ((Data) -> Void)? = nil) {
        let document = PDDocument(fileURL: documentUrl)
        document.open { success in
            if success {
                document.close(completionHandler: nil)
            }
            if let callback = completion {
                callback(document.data)
            }
        }
    }
}

// MARK: - PDDocument
public class PDDocument: UIDocument {
    public var data = Data()
    override public func load(fromContents contents: Any, ofType typeName: String?) throws {
        data = contents as! Data
    }
}
