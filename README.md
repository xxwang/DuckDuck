# DuckDuck

`.dd.`使用方法

```Swift
let view = UIView()
view.dd.backgroundColor(.red)
```

`dd_`使用方法

```Swift
let view = UIView()
view.dd_backgroundColor(.red)
```

`.dd.`自定义扩展

```
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
