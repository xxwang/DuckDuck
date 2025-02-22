import UIKit
import WebKit

// MARK: - Creatable 协议
public protocol Creatable: NSObject {
    static func create<T: Creatable>(_ aClass: T.Type) -> T
    static func `default`<T: Creatable>(_ aClass: T.Type) -> T
}

// MARK: - Creatable默认实现
public extension Creatable {
    /// 纯净的创建方法
    static func create<T: Creatable>(_ aClass: T.Type = NSObject.self) -> T {
        return aClass.init()
    }

    /// 带默认配置的创建方法
    static func `default`<T: Creatable>(_ aClass: T.Type = NSObject.self) -> T {
        return self.create(aClass)
    }
}

// MARK: - NSObject: Creatable
extension NSObject: Creatable {}

// MARK: - UIAlertController
public extension UIAlertController {
    /// 纯净的创建方法
    static func create<T: UIAlertController>(_ aClass: T.Type = UIAlertController.self) -> T {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        return alertController as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIAlertController>(_ aClass: T.Type = UIAlertController.self) -> T {
        let alertController: UIAlertController = self.create()
        return alertController as! T
    }
}

// MARK: - UITabBarController
public extension UITabBarController {
    /// 纯净的创建方法
    static func create<T: UITabBarController>(_ aClass: T.Type = UITabBarController.self) -> T {
        let tabBarController = UITabBarController()
        return tabBarController as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITabBarController>(_ aClass: T.Type = UITabBarController.self) -> T {
        let tabBarController: UITabBarController = self.create()
        return tabBarController as! T
    }
}

// MARK: - UINavigationController
public extension UINavigationController {
    /// 纯净的创建方法
    static func create<T: UINavigationController>(_ aClass: T.Type = UINavigationController.self) -> T {
        let navigationController = UINavigationController()
        return navigationController as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UINavigationController>(_ aClass: T.Type = UINavigationController.self) -> T {
        let navigationController: UINavigationController = self.create()
        return navigationController as! T
    }
}

// MARK: - UIViewController
public extension UIViewController {
    /// 纯净的创建方法
    static func create<T: UIViewController>(_ aClass: T.Type = UIViewController.self) -> T {
        let viewController = UIViewController()
        return viewController as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIViewController>(_ aClass: T.Type = UIViewController.self) -> T {
        let viewController: UIViewController = self.create()
        return viewController as! T
    }
}

// MARK: - View

// MARK: - UIScrollView
public extension UIScrollView {
    /// 纯净的创建方法
    static func create<T: UIScrollView>(_ aClass: T.Type = UIScrollView.self) -> T {
        let scrollView = UIScrollView()
        return scrollView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIScrollView>(_ aClass: T.Type = UIScrollView.self) -> T {
        let scrollView: UIScrollView = self.create()
        return scrollView as! T
    }
}

// MARK: - UITableView
public extension UITableView {
    /// 纯净的创建方法
    static func create<T: UITableView>(_ aClass: T.Type = UITableView.self) -> T {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITableView>(_ aClass: T.Type = UITableView.self) -> T {
        let tableView: UITableView = self.create()
            .dd_rowHeight(UITableView.automaticDimension)
            .dd_estimatedRowHeight(50)
            .dd_backgroundColor(.clear)
            .dd_sectionHeaderHeight(0.001)
            .dd_sectionFooterHeight(0.001)
            .dd_separatorStyle(.none)
            .dd_keyboardDismissMode(.onDrag)
            .dd_showsHorizontalScrollIndicator(false)
            .dd_showsVerticalScrollIndicator(false)
            .dd_contentInsetAdjustmentBehavior(.never)
            .dd_sectionHeaderTopPadding(0)
            .dd_cellLayoutMarginsFollowReadableWidth(false)
        return tableView as! T
    }
}

// MARK: - UITableViewCell
public extension UITableViewCell {
    /// 纯净的创建方法
    static func create<T: UITableViewCell>(_ aClass: T.Type = UITableViewCell.self) -> T {
        let cell = UITableViewCell()
        return cell as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITableViewCell>(_ aClass: T.Type = UITableViewCell.self) -> T {
        let cell: UITableViewCell = self.create()
        return cell as! T
    }
}

// MARK: - UICollectionView
public extension UICollectionView {
    /// 纯净的创建方法
    static func create<T: UICollectionView>(_ aClass: T.Type = UICollectionView.self) -> T {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UICollectionView>(_ aClass: T.Type = UICollectionView.self) -> T {
        let collectionView: UICollectionView = self.create()
            .dd_bounces(true)
            .dd_isPagingEnabled(false)
            .dd_isScrollEnabled(true)
            .dd_showsHorizontalScrollIndicator(false)
            .dd_showsVerticalScrollIndicator(false)
            .dd_backgroundColor(.clear)
        return collectionView as! T
    }
}

// MARK: - UICollectionReusableView
public extension UICollectionReusableView {
    /// 纯净的创建方法
    static func create<T: UICollectionReusableView>(_ aClass: T.Type = UICollectionReusableView.self) -> T {
        let reusableView = UICollectionReusableView()
        return reusableView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UICollectionReusableView>(_ aClass: T.Type = UICollectionReusableView.self) -> T {
        let reusableView: UICollectionReusableView = self.create()
        return reusableView as! T
    }
}

// MARK: - UICollectionViewCell
public extension UICollectionViewCell {
    /// 纯净的创建方法
    static func create<T: UICollectionViewCell>(_ aClass: T.Type = UICollectionViewCell.self) -> T {
        let cell = UICollectionViewCell()
        return cell as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UICollectionViewCell>(_ aClass: T.Type = UICollectionViewCell.self) -> T {
        let cell: UICollectionViewCell = self.create()
        return cell as! T
    }
}

// MARK: - UICollectionViewFlowLayout
public extension UICollectionViewFlowLayout {
    /// 纯净的创建方法
    static func create<T: UICollectionViewFlowLayout>(_ aClass: T.Type = UICollectionViewFlowLayout.self) -> T {
        let layout = UICollectionViewFlowLayout()
        return layout as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UICollectionViewFlowLayout>(_ aClass: T.Type = UICollectionViewFlowLayout.self) -> T {
        let layout: UICollectionViewFlowLayout = self.create()
        return layout as! T
    }
}

// MARK: - UIControl
public extension UIControl {
    /// 纯净的创建方法
    static func create<T: UIControl>(_ aClass: T.Type = UIControl.self) -> T {
        let control = UIControl(frame: .zero)
        return control as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIControl>(_ aClass: T.Type = UIControl.self) -> T {
        let control: UIControl = self.create()
        return control as! T
    }
}

// MARK: - UIButton
public extension UIButton {
    /// 纯净的创建方法
    static func create<T: UIButton>(_ aClass: T.Type = UIButton.self) -> T {
        let button = UIButton(type: .custom)
        return button as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIButton>(_ aClass: T.Type = UIButton.self) -> T {
        let button: UIButton = self.create()
        return button as! T
    }
}

// MARK: - UIBarButtonItem
public extension UIBarButtonItem {
    /// 纯净的创建方法
    static func create<T: UIBarButtonItem>(_ aClass: T.Type = UIBarButtonItem.self) -> T {
        let barButtonItem = UIBarButtonItem()
        return barButtonItem as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIBarButtonItem>(_ aClass: T.Type = UIBarButtonItem.self) -> T {
        let barButtonItem: UIBarButtonItem = self.create()
        return barButtonItem as! T
    }
}

// MARK: - UINavigationBar
public extension UINavigationBar {
    /// 纯净的创建方法
    static func create<T: UINavigationBar>(_ aClass: T.Type = UINavigationBar.self) -> T {
        let navigationBar = UINavigationBar()
        return navigationBar as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UINavigationBar>(_ aClass: T.Type = UINavigationBar.self) -> T {
        let navigationBar: UINavigationBar = self.create()
        return navigationBar as! T
    }
}

// MARK: - UINavigationItem
public extension UINavigationItem {
    /// 纯净的创建方法
    static func create<T: UINavigationItem>(_ aClass: T.Type = UINavigationItem.self) -> T {
        let navigationItem = UINavigationItem()
        return navigationItem as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UINavigationItem>(_ aClass: T.Type = UINavigationItem.self) -> T {
        let navigationItem: UINavigationItem = self.create()
        return navigationItem as! T
    }
}

// MARK: - UIDatePicker
public extension UIDatePicker {
    /// 纯净的创建方法
    static func create<T: UIDatePicker>(_ aClass: T.Type = UIDatePicker.self) -> T {
        let datePicker = UIDatePicker(frame: .zero)
        return datePicker as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIDatePicker>(_ aClass: T.Type = UIDatePicker.self) -> T {
        let datePicker: UIDatePicker = self.create()
        return datePicker as! T
    }
}

// MARK: - UIPickerView
public extension UIPickerView {
    /// 纯净的创建方法
    static func create<T: UIPickerView>(_ aClass: T.Type = UIPickerView.self) -> T {
        let pickerView = UIPickerView()
        return pickerView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIPickerView>(_ aClass: T.Type = UIPickerView.self) -> T {
        let pickerView: UIPickerView = self.create()
        return pickerView as! T
    }
}

// MARK: - UIImageView
public extension UIImageView {
    /// 纯净的创建方法
    static func create<T: UIImageView>(_ aClass: T.Type = UIImageView.self) -> T {
        let imageView = UIImageView()
        return imageView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIImageView>(_ aClass: T.Type = UIImageView.self) -> T {
        let imageView: UIImageView = self.create()
        return imageView as! T
    }
}

// MARK: - UILabel
public extension UILabel {
    /// 纯净的创建方法
    static func create<T: UILabel>(_ aClass: T.Type = UILabel.self) -> T {
        let label = UILabel()
        return label as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UILabel>(_ aClass: T.Type = UILabel.self) -> T {
        let label: UILabel = self.create()
        return label as! T
    }
}

// MARK: - NSMutableParagraphStyle
public extension NSMutableParagraphStyle {
    /// 纯净的创建方法
    static func create<T: NSMutableParagraphStyle>(_ aClass: T.Type = NSMutableParagraphStyle.self) -> T {
        let style = NSMutableParagraphStyle()
        return style as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: NSMutableParagraphStyle>(_ aClass: T.Type = NSMutableParagraphStyle.self) -> T {
        let style: NSMutableParagraphStyle = self.create()
            .dd_hyphenationFactor(1.0) // 设置连字符系数
            .dd_firstLineHeadIndent(0.0) // 设置第一行缩进
            .dd_paragraphSpacingBefore(0.0) // 设置段落前间距
            .dd_headIndent(0) // 设置头部缩进
            .dd_tailIndent(0) // 设置尾部缩进
        return style as! T
    }
}

// MARK: - UIBezierPath
public extension UIBezierPath {
    /// 纯净的创建方法
    static func create<T: UIBezierPath>(_ aClass: T.Type = UIBezierPath.self) -> T {
        let bezierPath = UIBezierPath()
        return bezierPath as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIBezierPath>(_ aClass: T.Type = UIBezierPath.self) -> T {
        let bezierPath: UIBezierPath = self.create()
        return bezierPath as! T
    }
}

// MARK: - UIPageControl
public extension UIPageControl {
    /// 纯净的创建方法
    static func create<T: UIPageControl>(_ aClass: T.Type = UIPageControl.self) -> T {
        let pageControl = UIPageControl()
        return pageControl as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIPageControl>(_ aClass: T.Type = UIPageControl.self) -> T {
        let pageControl: UIPageControl = self.create()
        return pageControl as! T
    }
}

// MARK: - UIProgressView
public extension UIProgressView {
    /// 纯净的创建方法
    static func create<T: UIProgressView>(_ aClass: T.Type = UIProgressView.self) -> T {
        let progressView = UIProgressView()
        return progressView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIProgressView>(_ aClass: T.Type = UIProgressView.self) -> T {
        let progressView: UIProgressView = self.create()
        return progressView as! T
    }
}

// MARK: - UIRefreshControl
public extension UIRefreshControl {
    /// 纯净的创建方法
    static func create<T: UIRefreshControl>(_ aClass: T.Type = UIRefreshControl.self) -> T {
        let refreshControl = UIRefreshControl()
        return refreshControl as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIRefreshControl>(_ aClass: T.Type = UIRefreshControl.self) -> T {
        let refreshControl: UIRefreshControl = self.create()
        return refreshControl as! T
    }
}

// MARK: - UISearchBar
public extension UISearchBar {
    /// 纯净的创建方法
    static func create<T: UISearchBar>(_ aClass: T.Type = UISearchBar.self) -> T {
        let searchBar = UISearchBar()
        return searchBar as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UISearchBar>(_ aClass: T.Type = UISearchBar.self) -> T {
        let searchBar: UISearchBar = self.create()
        return searchBar as! T
    }
}

// MARK: - UISegmentedControl
public extension UISegmentedControl {
    /// 纯净的创建方法
    static func create<T: UISegmentedControl>(_ aClass: T.Type = UISegmentedControl.self) -> T {
        let segmentedControl = UISegmentedControl()
        return segmentedControl as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UISegmentedControl>(_ aClass: T.Type = UISegmentedControl.self) -> T {
        let segmentedControl: UISegmentedControl = self.create()
        return segmentedControl as! T
    }
}

// MARK: - UISlider
public extension UISlider {
    /// 纯净的创建方法
    static func create<T: UISlider>(_ aClass: T.Type = UISlider.self) -> T {
        let slider = UISlider()
        return slider as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UISlider>(_ aClass: T.Type = UISlider.self) -> T {
        let slider: UISlider = self.create()
        return slider as! T
    }
}

// MARK: - UIStackView
public extension UIStackView {
    /// 纯净的创建方法
    static func create<T: UIStackView>(_ aClass: T.Type = UIStackView.self) -> T {
        let stackView = UIStackView()
        return stackView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIStackView>(_ aClass: T.Type = UIStackView.self) -> T {
        let stackView: UIStackView = self.create()
        return stackView as! T
    }
}

// MARK: - UISwitch
public extension UISwitch {
    /// 纯净的创建方法
    static func create<T: UISwitch>(_ aClass: T.Type = UISwitch.self) -> T {
        let switchButton = UISwitch()
        return switchButton as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UISwitch>(_ aClass: T.Type = UISwitch.self) -> T {
        let switchButton: UISwitch = self.create()
        return switchButton as! T
    }
}

// MARK: - UITabBar
public extension UITabBar {
    /// 纯净的创建方法
    static func create<T: UITabBar>(_ aClass: T.Type = UITabBar.self) -> T {
        let tabBar = UITabBar()
        return tabBar as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITabBar>(_ aClass: T.Type = UITabBar.self) -> T {
        let tabBar: UITabBar = self.create()
        return tabBar as! T
    }
}

// MARK: - UITabBarItem
public extension UITabBarItem {
    /// 纯净的创建方法
    static func create<T: UITabBarItem>(_ aClass: T.Type = UITabBarItem.self) -> T {
        let tabBarItem = UITabBarItem()
        return tabBarItem as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITabBarItem>(_ aClass: T.Type = UITabBarItem.self) -> T {
        let tabBarItem: UITabBarItem = self.create()
        return tabBarItem as! T
    }
}

// MARK: - UITextField
public extension UITextField {
    /// 纯净的创建方法
    static func create<T: UITextField>(_ aClass: T.Type = UITextField.self) -> T {
        let textField = UITextField()
        return textField as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITextField>(_ aClass: T.Type = UITextField.self) -> T {
        let textField: UITextField = self.create()
        return textField as! T
    }
}

// MARK: - UITextView
public extension UITextView {
    /// 纯净的创建方法
    static func create<T: UITextView>(_ aClass: T.Type = UITextView.self) -> T {
        let textView = UITextView()
        return textView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITextView>(_ aClass: T.Type = UITextView.self) -> T {
        let textView: UITextView = self.create()
        return textView as! T
    }
}

// MARK: - UIView
public extension UIView {
    /// 纯净的创建方法
    static func create<T: UIView>(_ aClass: T.Type = UIView.self) -> T {
        let view = UIView()
        return view as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIView>(_ aClass: T.Type = UIView.self) -> T {
        let view: UIView = self.create()
        return view as! T
    }
}

// MARK: - UIWindow
public extension UIWindow {
    /// 纯净的创建方法
    static func create<T: UIWindow>(_ aClass: T.Type = UIWindow.self) -> T {
        let window = UIWindow()
        return window as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIWindow>(_ aClass: T.Type = UIWindow.self) -> T {
        let window: UIWindow = self.create()
        return window as! T
    }
}

// MARK: - WKWebView
public extension WKWebView {
    /// 纯净的创建方法
    static func create<T: WKWebView>(_ aClass: T.Type = WKWebView.self) -> T {
        let webView = WKWebView()
        return webView as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: WKWebView>(_ aClass: T.Type = WKWebView.self) -> T {
        let webView: WKWebView = self.create()
        return webView as! T
    }
}

// MARK: - UIGestureRecognizer
public extension UIGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIGestureRecognizer>(_ aClass: T.Type = UIGestureRecognizer.self) -> T {
        let gesture = UIGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIGestureRecognizer>(_ aClass: T.Type = UIGestureRecognizer.self) -> T {
        let gesture: UIGestureRecognizer = self.create()
        return gesture as! T
    }
}

// MARK: - UIHoverGestureRecognizer
public extension UIHoverGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIHoverGestureRecognizer>(_ aClass: T.Type = UIHoverGestureRecognizer.self) -> T {
        let gesture = UIHoverGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIHoverGestureRecognizer>(_ aClass: T.Type = UIHoverGestureRecognizer.self) -> T {
        let gesture: UIHoverGestureRecognizer = self.create()
        return gesture as! T
    }
}

// MARK: - UILongPressGestureRecognizer
public extension UILongPressGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UILongPressGestureRecognizer>(_ aClass: T.Type = UILongPressGestureRecognizer.self) -> T {
        let gesture = UILongPressGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UILongPressGestureRecognizer>(_ aClass: T.Type = UILongPressGestureRecognizer.self) -> T {
        let gesture: UILongPressGestureRecognizer = self.create()
        return gesture as! T
    }
}

// MARK: - UIPanGestureRecognizer
public extension UIPanGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIPanGestureRecognizer>(_ aClass: T.Type = UIPanGestureRecognizer.self) -> T {
        let control = UIPanGestureRecognizer()
        return control as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIPanGestureRecognizer>(_ aClass: T.Type = UIPanGestureRecognizer.self) -> T {
        let control: UIPanGestureRecognizer = self.create()
        return control as! T
    }
}

// MARK: - UIPinchGestureRecognizer
public extension UIPinchGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIPinchGestureRecognizer>(_ aClass: T.Type = UIPinchGestureRecognizer.self) -> T {
        let control = UIPinchGestureRecognizer()
        return control as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIPinchGestureRecognizer>(_ aClass: T.Type = UIPinchGestureRecognizer.self) -> T {
        let control: UIPinchGestureRecognizer = self.create()
        return control as! T
    }
}

// MARK: - UIRotationGestureRecognizer
public extension UIRotationGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIRotationGestureRecognizer>(_ aClass: T.Type = UIRotationGestureRecognizer.self) -> T {
        let gesture = UIRotationGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIRotationGestureRecognizer>(_ aClass: T.Type = UIRotationGestureRecognizer.self) -> T {
        let gesture: UIRotationGestureRecognizer = self.create()
        return gesture as! T
    }
}

// MARK: - UIScreenEdgePanGestureRecognizer
public extension UIScreenEdgePanGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UIScreenEdgePanGestureRecognizer>(_ aClass: T.Type = UIScreenEdgePanGestureRecognizer.self) -> T {
        let gesture = UIScreenEdgePanGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UIScreenEdgePanGestureRecognizer>(_ aClass: T.Type = UIScreenEdgePanGestureRecognizer.self) -> T {
        let gesture: UIScreenEdgePanGestureRecognizer = self.create()
        return gesture as! T
    }
}

// MARK: - UISwipeGestureRecognizer
public extension UISwipeGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UISwipeGestureRecognizer>(_ aClass: T.Type = UISwipeGestureRecognizer.self) -> T {
        let gesture = UISwipeGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UISwipeGestureRecognizer>(_ aClass: T.Type = UISwipeGestureRecognizer.self) -> T {
        let gesture: UISwipeGestureRecognizer = self.create()
        return gesture as! T
    }
}

// MARK: - UITapGestureRecognizer
public extension UITapGestureRecognizer {
    /// 纯净的创建方法
    static func create<T: UITapGestureRecognizer>(_ aClass: T.Type = UITapGestureRecognizer.self) -> T {
        let gesture = UITapGestureRecognizer()
        return gesture as! T
    }

    /// 带默认配置的创建方法
    static func `default`<T: UITapGestureRecognizer>(_ aClass: T.Type = UITapGestureRecognizer.self) -> T {
        let gesture: UITapGestureRecognizer = self.create()
        return gesture as! T
    }
}
