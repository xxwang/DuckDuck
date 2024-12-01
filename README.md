# DuckDuck

## 安装

`DuckDuck`可以通过`CocoaPods`和`Swift Package Manager`安装.

### Cocoapods

```Ruby
platform :ios, '15.0'
use_frameworks!

target 'App' do
  pod 'DuckDuck'
end
```

### SPM

将下面内容添加到您的`Package.swift`文件中的`dependencies`部分中
```Swift
.package(url: "https://github.com/xxwang/DuckDuck.git", branch: "main")
```

## 使用方法

使用前需要先导入`DuckDuck`
```Swift
import DuckDUck
```

### `dd_`使用方法

```Swift
let view = UIView()
view.dd_backgroundColor(.red)
```

### `.dd.`使用方法

```Swift
let view = UIView()
view.dd.backgroundColor(.red)
```

### `.dd.`自定义扩展

```Swift
// 要扩展的类型需要先遵守协议
extension [类型]: DDExtensionable {}

// 添加方法列表
public extension DDExtension where Base: [类型] {
    //TODO: - 具体方法
}

//实例方法调用
类型实例.dd.方法名()

//类型方法调用
类型.dd.方法名()
```



