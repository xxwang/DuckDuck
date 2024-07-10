//
//  Loadable.swift
//
//
//  Created by 王哥 on 2024/7/9.
//

import UIKit

public protocol Loadable {}

public extension Loadable where Self: UIView {
    /// 加载与类同名的`xib`
    /// - Parameters:
    ///   - nibName: `xib`文件名称
    ///   - bundle: `Xib`所在`bundle`
    /// - Returns: `Self`实例
    static func loadNib(by nibName: String? = nil, in bundle: Bundle? = nil) -> Self {
        let named = nibName ?? "\(self)"
        guard let view = UINib(nibName: named, bundle: .main).instantiate(withOwner: nil, options: nil)[0] as? Self else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        return view
    }
}

public extension Loadable where Self: UIViewController {
    /// 加载`storyboard`中的控制器
    /// - Parameters:
    ///   - identifier: 控制器对应标识,默认使用`控制器类名称`
    ///   - fileName: `storyboard`文件名称,默认使用`Main.storyboard`
    ///   - bundle: `storyboard`文件所在`Bundle`,默认使用`Bundle.main`
    /// - Returns: 控制器实例
    static func loadStoryboard(identifier: String? = nil, fileName: String? = nil, bundle: Bundle = .main) -> Self? {
        guard let fileName = fileName ?? (bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String) else {
            fatalError("Storyboard file does not exist")
        }
        let identifier = identifier ?? String(describing: self)
        return UIStoryboard(name: fileName, bundle: bundle).instantiateViewController(withIdentifier: identifier) as? Self
    }
}
