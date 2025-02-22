import UIKit

// MARK: - Skinable 协议
/// 定义一个协议，用于支持主题切换的对象
///
/// 任何遵循 `Skinable` 协议的类或结构体都应该实现 `apply()` 方法，
/// 该方法用来更新其 UI 元素的主题样式。
public protocol Skinable: AnyObject {
    /// 在该方法中实现具体的主题更新逻辑
    /// 例如，可以在此方法中更改控件的颜色、字体等样式。
    func apply()
}

// MARK: - SkinProvider 协议
/// 提供主题管理功能的协议
///
/// `SkinProvider` 协议定义了主题管理的方法，包括注册、移除监听者，
/// 以及更新所有注册监听者的主题。实现该协议的类可以作为主题管理器。
public protocol SkinProvider: AnyObject {
    /// 注册一个观察者对象，用于监听主题更新
    /// - Parameter observer: 遵循 `Skinable` 协议的对象，将在主题更新时进行更新。
    func register(observer: Skinable)

    /// 批量注册观察者对象
    /// - Parameter observers: 一组遵循 `Skinable` 协议的对象，将在主题更新时进行更新。
    func registerObservers(_ observers: [Skinable])

    /// 移除观察者对象
    /// - Parameter observer: 需要移除的观察者对象。
    func remove(observer: Skinable)

    /// 批量移除观察者对象
    /// - Parameter observers: 一组需要移除的观察者对象。
    func removeObservers(_ observers: [Skinable])

    /// 更新主题
    /// 通知所有注册的观察者对象更新其主题样式。
    func updateSkin()
}

// MARK: - SkinManager
/// 实现主题管理功能的单例类
///
/// `SkinManager` 类遵循 `SkinProvider` 协议，用于管理所有需要更新主题的观察者对象。
/// 它负责向所有注册的观察者发送主题更新的通知。
///
/// - Example:
///
/// 假设我们有一个 `ViewController`，它需要根据主题的变化更新界面的颜色、字体等样式：
/// ```swift
/// class ViewController: UIViewController, Skinable {
///     override func viewDidLoad() {
///         super.viewDidLoad()
///         // 注册到主题管理器
///         SkinManager.shared.register(observer: self)
///     }
///
///     func apply() {
///         // 根据当前主题更新界面样式
///         self.view.backgroundColor = .white // 示例更新
///     }
/// }
/// ```
/// 当主题更新时，`SkinManager.shared.updateSkin()` 会自动通知所有注册的观察者调用 `apply()` 方法，从而更新它们的主题样式。
public class SkinManager: SkinProvider {
    /// 存储观察者对象的弱引用集合
    ///
    /// 使用 `NSHashTable<AnyObject>` 来存储观察者，避免强引用导致的内存泄漏。
    /// 弱引用集合意味着，当观察者对象被销毁时，它会自动从集合中移除。
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    /// 单例实例，用于访问全局的主题管理器。
    public static let shared = SkinManager()

    /// 私有初始化方法，防止外部直接初始化
    ///
    /// 保证只有一个 `SkinManager` 实例在应用中存在。
    private init() {}

    // MARK: - SkinProvider 协议实现

    /// 注册监听对象
    /// - Parameter observer: 遵循 `Skinable` 协议的对象，注册后会接收主题更新通知。
    ///
    /// 将指定的观察者添加到主题管理器的观察者列表中。
    public func register(observer: Skinable) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
    }

    /// 批量注册监听对象
    /// - Parameter observers: 一组遵循 `Skinable` 协议的对象，注册后会接收主题更新通知。
    ///
    /// 将多个观察者添加到主题管理器的观察者列表中。
    public func registerObservers(_ observers: [Skinable]) {
        for observer in observers {
            if !self.observers.contains(observer) {
                self.observers.add(observer)
            }
        }
    }

    /// 移除监听对象
    /// - Parameter observer: 需要移除的观察者对象。
    ///
    /// 从主题管理器的观察者列表中移除指定的观察者对象。
    public func remove(observer: Skinable) {
        observers.remove(observer)
    }

    /// 批量移除监听对象
    /// - Parameter observers: 一组需要移除的观察者对象。
    ///
    /// 从主题管理器的观察者列表中移除多个观察者对象。
    public func removeObservers(_ observers: [Skinable]) {
        for observer in observers {
            self.observers.remove(observer)
        }
    }

    /// 更新主题
    /// 通知所有注册的观察者对象执行 `apply()` 方法，从而更新其主题。
    ///
    /// 该方法会遍历所有注册的观察者，并依次调用它们的 `apply()` 方法。
    /// 主题更新后，UI 控件会根据新的主题配置更新样式。
    public func updateSkin() {
        // 通知所有注册的观察者更新主题
        observers.allObjects
            .compactMap { $0 as? Skinable }
            .forEach { $0.apply() }
    }
}

// MARK: - UITraitEnvironment
public extension Skinable where Self: UITraitEnvironment {
    /// 返回单例对象
    ///
    /// 通过此属性，遵循 `Skinable` 协议并且是 `UITraitEnvironment` 的对象可以访问全局的主题管理器 `SkinManager` 实例。
    /// 使用该属性可以方便地进行主题切换或注册观察者等操作。
    ///
    /// - Example:
    /// 假设我们有一个 `UIViewController` 遵循 `Skinable` 协议并且是 `UITraitEnvironment` 的子类：
    /// ```swift
    /// class MyViewController: UIViewController, Skinable {
    ///     override func viewDidLoad() {
    ///         super.viewDidLoad()
    ///         // 注册视图控制器为观察者
    ///         skinManager.register(observer: self)
    ///     }
    ///
    ///     func apply() {
    ///         // 更新视图控制器的主题
    ///         self.view.backgroundColor = .white // 根据主题更新
    ///     }
    /// }
    /// ```
    ///
    /// 在此例中，`skinManager` 返回 `SkinManager.shared`，使得 `MyViewController` 能够通过该属性直接访问并管理其主题更新。
    var skinManager: SkinProvider {
        return SkinManager.shared
    }
}
