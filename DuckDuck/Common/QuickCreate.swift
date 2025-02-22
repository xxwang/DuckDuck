import UIKit
import WebKit

// MARK: - UIAlertController
public extension DDExtension where Base == UIAlertController {
    /// 纯净的创建方法
    static func create() -> Base {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        return alertController
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let alertController: UIAlertController = self.create()
        return alertController
    }
}

// MARK: - UITabBarController
public extension DDExtension where Base == UITabBarController {
    /// 纯净的创建方法
    static func create() -> Base {
        let tabBarController = UITabBarController()
        return tabBarController
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let tabBarController: UITabBarController = self.create()
        return tabBarController
    }
}

// MARK: - UINavigationController
public extension DDExtension where Base == UINavigationController {
    /// 纯净的创建方法
    static func create() -> Base {
        let navigationController = UINavigationController()
        return navigationController
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let navigationController: UINavigationController = self.create()
        return navigationController
    }
}

// MARK: - UIViewController
public extension DDExtension where Base == UIViewController {
    /// 纯净的创建方法
    static func create() -> Base {
        let viewController = UIViewController()
        return viewController
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let viewController: UIViewController = self.create()
        return viewController
    }
}

// MARK: - UIScrollView
public extension DDExtension where Base == UIScrollView {
    /// 纯净的创建方法
    static func create() -> Base {
        let scrollView = UIScrollView()
        return scrollView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let scrollView: UIScrollView = self.create()
        return scrollView
    }
}

// MARK: - UITableView
public extension DDExtension where Base == UITableView {
    /// 纯净的创建方法
    static func create() -> Base {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
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
        return tableView
    }
}

// MARK: - UITableViewCell
public extension DDExtension where Base == UITableViewCell {
    /// 纯净的创建方法
    static func create() -> Base {
        let cell = UITableViewCell()
        return cell
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let cell: UITableViewCell = self.create()
        return cell
    }
}

// MARK: - UICollectionView
public extension DDExtension where Base == UICollectionView {
    /// 纯净的创建方法
    static func create() -> Base {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let collectionView: UICollectionView = self.create()
            .dd_bounces(true)
            .dd_isPagingEnabled(false)
            .dd_isScrollEnabled(true)
            .dd_showsHorizontalScrollIndicator(false)
            .dd_showsVerticalScrollIndicator(false)
            .dd_backgroundColor(.clear)
        return collectionView
    }
}

// MARK: - UICollectionReusableView
public extension DDExtension where Base == UICollectionReusableView {
    /// 纯净的创建方法
    static func create() -> Base {
        let reusableView = UICollectionReusableView()
        return reusableView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let reusableView: UICollectionReusableView = self.create()
        return reusableView
    }
}

// MARK: - UICollectionViewCell
public extension DDExtension where Base == UICollectionViewCell {
    /// 纯净的创建方法
    static func create() -> Base {
        let cell = UICollectionViewCell()
        return cell
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let cell: UICollectionViewCell = self.create()
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
public extension DDExtension where Base == UICollectionViewFlowLayout {
    /// 纯净的创建方法
    static func create() -> Base {
        let layout = UICollectionViewFlowLayout()
        return layout
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let layout: UICollectionViewFlowLayout = self.create()
        return layout
    }
}

// MARK: - UIControl
public extension DDExtension where Base == UIControl {
    /// 纯净的创建方法
    static func create() -> Base {
        let control = UIControl(frame: .zero)
        return control
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let control: UIControl = self.create()
        return control
    }
}

// MARK: - UIButton
public extension DDExtension where Base == UIButton {
    /// 纯净的创建方法
    static func create() -> Base {
        let button = UIButton(type: .custom)
        return button
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let button: UIButton = self.create()
        return button
    }
}

// MARK: - UIBarButtonItem
public extension DDExtension where Base == UIBarButtonItem {
    /// 纯净的创建方法
    static func create() -> Base {
        let barButtonItem = UIBarButtonItem()
        return barButtonItem
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let barButtonItem: UIBarButtonItem = self.create()
        return barButtonItem
    }
}

// MARK: - UINavigationBar
public extension DDExtension where Base == UINavigationBar {
    /// 纯净的创建方法
    static func create() -> Base {
        let navigationBar = UINavigationBar()
        return navigationBar
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let navigationBar: UINavigationBar = self.create()
        return navigationBar
    }
}

// MARK: - UINavigationItem
public extension DDExtension where Base == UINavigationItem {
    /// 纯净的创建方法
    static func create() -> Base {
        let navigationItem = UINavigationItem()
        return navigationItem
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let navigationItem: UINavigationItem = self.create()
        return navigationItem
    }
}

// MARK: - UIDatePicker
public extension DDExtension where Base == UIDatePicker {
    /// 纯净的创建方法
    static func create() -> Base {
        let datePicker = UIDatePicker(frame: .zero)
        return datePicker
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let datePicker: UIDatePicker = self.create()
        return datePicker
    }
}

// MARK: - UIPickerView
public extension DDExtension where Base == UIPickerView {
    /// 纯净的创建方法
    static func create() -> Base {
        let pickerView = UIPickerView()
        return pickerView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let pickerView: UIPickerView = self.create()
        return pickerView
    }
}

// MARK: - UIImageView
public extension DDExtension where Base == UIImageView {
    /// 纯净的创建方法
    static func create() -> Base {
        let imageView = UIImageView()
        return imageView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let imageView: UIImageView = self.create()
        return imageView
    }
}

// MARK: - UILabel
public extension DDExtension where Base == UILabel {
    /// 纯净的创建方法
    static func create() -> Base {
        let label = UILabel()
        return label
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let label: UILabel = self.create()
        return label
    }
}

// MARK: - NSMutableParagraphStyle
public extension DDExtension where Base == NSMutableParagraphStyle {
    /// 纯净的创建方法
    static func create() -> Base {
        let style = NSMutableParagraphStyle()
        return style
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let style: NSMutableParagraphStyle = self.create()
            .dd_hyphenationFactor(1.0) // 设置连字符系数
            .dd_firstLineHeadIndent(0.0) // 设置第一行缩进
            .dd_paragraphSpacingBefore(0.0) // 设置段落前间距
            .dd_headIndent(0) // 设置头部缩进
            .dd_tailIndent(0) // 设置尾部缩进
        return style
    }
}

// MARK: - UIBezierPath
public extension DDExtension where Base == UIBezierPath {
    /// 纯净的创建方法
    static func create() -> Base {
        let bezierPath = UIBezierPath()
        return bezierPath
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let bezierPath: UIBezierPath = self.create()
        return bezierPath
    }
}

// MARK: - UIPageControl
public extension DDExtension where Base == UIPageControl {
    /// 纯净的创建方法
    static func create() -> Base {
        let pageControl = UIPageControl()
        return pageControl
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let pageControl: UIPageControl = self.create()
        return pageControl
    }
}

// MARK: - UIProgressView
public extension DDExtension where Base == UIProgressView {
    /// 纯净的创建方法
    static func create() -> Base {
        let progressView = UIProgressView()
        return progressView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let progressView: UIProgressView = self.create()
        return progressView
    }
}

// MARK: - UIRefreshControl
public extension DDExtension where Base == UIRefreshControl {
    /// 纯净的创建方法
    static func create() -> Base {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let refreshControl: UIRefreshControl = self.create()
        return refreshControl
    }
}

// MARK: - UISearchBar
public extension DDExtension where Base == UISearchBar {
    /// 纯净的创建方法
    static func create() -> Base {
        let searchBar = UISearchBar()
        return searchBar
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let searchBar: UISearchBar = self.create()
        return searchBar
    }
}

// MARK: - UISegmentedControl
public extension DDExtension where Base == UISegmentedControl {
    /// 纯净的创建方法
    static func create() -> Base {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let segmentedControl: UISegmentedControl = self.create()
        return segmentedControl
    }
}

// MARK: - UISlider
public extension DDExtension where Base == UISlider {
    /// 纯净的创建方法
    static func create() -> Base {
        let slider = UISlider()
        return slider
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let slider: UISlider = self.create()
        return slider
    }
}

// MARK: - UIStackView
public extension DDExtension where Base == UIStackView {
    /// 纯净的创建方法
    static func create() -> Base {
        let stackView = UIStackView()
        return stackView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let stackView: UIStackView = self.create()
        return stackView
    }
}

// MARK: - UISwitch
public extension DDExtension where Base == UISwitch {
    /// 纯净的创建方法
    static func create() -> Base {
        let switchButton = UISwitch()
        return switchButton
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let switchButton: UISwitch = self.create()
        return switchButton
    }
}

// MARK: - UITabBar
public extension DDExtension where Base == UITabBar {
    /// 纯净的创建方法
    static func create() -> Base {
        let tabBar = UITabBar()
        return tabBar
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let tabBar: UITabBar = self.create()
        return tabBar
    }
}

// MARK: - UITabBarItem
public extension DDExtension where Base == UITabBarItem {
    /// 纯净的创建方法
    static func create() -> Base {
        let tabBarItem = UITabBarItem()
        return tabBarItem
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let tabBarItem: UITabBarItem = self.create()
        return tabBarItem
    }
}

// MARK: - UITextField
public extension DDExtension where Base == UITextField {
    /// 纯净的创建方法
    static func create() -> Base {
        let textField = UITextField()
        return textField
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let textField: UITextField = self.create()
        return textField
    }
}

// MARK: - UITextView
public extension DDExtension where Base == UITextView {
    /// 纯净的创建方法
    static func create() -> Base {
        let textView = UITextView()
        return textView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let textView: UITextView = self.create()
        return textView
    }
}

// MARK: - UIView
public extension DDExtension where Base == UIView {
    /// 纯净的创建方法
    static func create() -> Base {
        let view = UIView()
        return view
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let view: UIView = self.create()
        return view
    }
}

// MARK: - UIWindow
public extension DDExtension where Base == UIWindow {
    /// 纯净的创建方法
    static func create() -> Base {
        let window = UIWindow()
        return window
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let window: UIWindow = self.create()
        return window
    }
}

// MARK: - WKWebView
public extension DDExtension where Base == WKWebView {
    /// 纯净的创建方法
    static func create() -> Base {
        let webView = WKWebView()
        return webView
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let webView: WKWebView = self.create()
        return webView
    }
}

// MARK: - UIGestureRecognizer
public extension DDExtension where Base == UIGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let gesture = UIGestureRecognizer()
        return gesture
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let gesture: UIGestureRecognizer = self.create()
        return gesture
    }
}

// MARK: - UIHoverGestureRecognizer
public extension DDExtension where Base == UIHoverGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let gesture = UIHoverGestureRecognizer()
        return gesture
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let gesture: UIHoverGestureRecognizer = self.create()
        return gesture
    }
}

// MARK: - UILongPressGestureRecognizer
public extension DDExtension where Base == UILongPressGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let gesture = UILongPressGestureRecognizer()
        return gesture
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let gesture: UILongPressGestureRecognizer = self.create()
        return gesture
    }
}

// MARK: - UIPanGestureRecognizer
public extension DDExtension where Base == UIPanGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let control = UIPanGestureRecognizer()
        return control
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let control: UIPanGestureRecognizer = self.create()
        return control
    }
}

// MARK: - UIPinchGestureRecognizer
public extension DDExtension where Base == UIPinchGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let control = UIPinchGestureRecognizer()
        return control
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let control: UIPinchGestureRecognizer = self.create()
        return control
    }
}

// MARK: - UIRotationGestureRecognizer
public extension DDExtension where Base == UIRotationGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let gesture = UIRotationGestureRecognizer()
        return gesture
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let gesture: UIRotationGestureRecognizer = self.create()
        return gesture
    }
}

// MARK: - UIScreenEdgePanGestureRecognizer
public extension DDExtension where Base == UIScreenEdgePanGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let gesture = UIScreenEdgePanGestureRecognizer()
        return gesture
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let gesture: UIScreenEdgePanGestureRecognizer = self.create()
        return gesture
    }
}

// MARK: - UISwipeGestureRecognizer
public extension DDExtension where Base == UISwipeGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let gesture = UISwipeGestureRecognizer()
        return gesture
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let gesture: UISwipeGestureRecognizer = self.create()
        return gesture
    }
}

// MARK: - UITapGestureRecognizer
public extension DDExtension where Base == UITapGestureRecognizer {
    /// 纯净的创建方法
    static func create() -> Base {
        let gesture = UITapGestureRecognizer()
        return gesture
    }

    /// 带默认配置的创建方法
    static func `default`() -> Base {
        let gesture: UITapGestureRecognizer = self.create()
        return gesture
    }
}
