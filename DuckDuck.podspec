Pod::Spec.new do |spec|

  # 项目名称
  spec.name         = "DuckDuck"
  # 项目版本号
  spec.version      = "0.0.2"
  # 项目介绍
  spec.summary      = "常用工具库"

 # 项目详细描述(可以markdown)
  spec.description  = <<-DESC
  - 这是一个日常开发工具库
                   DESC

  # 项目主页
  spec.homepage     = "https://github.com/xxwang/DuckDuck"

  # 项目许可证
  spec.license      = "MIT"

  # 作者信息
  spec.author = { "xxwang" => "78023776@qq.com" }

  # 平台及版本
  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = '15.0'

  # 需要arc
  spec.requires_arc = true

  #模块名称
  spec.module_name = 'DuckDuck'

  # 指定语言版本
  spec.swift_version = '5'

  # 项目源文件
  spec.source       = { :git => "https://github.com/xxwang/DuckDuck.git", :tag => "#{spec.version}" }

  # 文件目录
  spec.source_files  = 'Sources/DuckDuck/**/*.{c,h,m,swift}'
  
  # spec.frameworks = 'UIKit', 'QuartzCore', 'Foundation', 'AVFAudio', 'CoreGraphics', 'CoreLocation', 'Dispatch', 'HealthKit', 'MapKit'
end
