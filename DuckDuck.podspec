Pod::Spec.new do |spec|
  spec.name         = "DuckDuck"
  spec.version      = "0.0.1"
  spec.summary      = "常用工具库"

  spec.description  = <<-DESC
  - 这是一个日常开发工具库
                   DESC

  spec.homepage     = "https://github.com/xxwang/DuckDuck.swift"
  spec.license      = "MIT"
  spec.author = { "xxwang" => "78023776@qq.com" }

  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = '15.0'
  spec.requires_arc = true
  spec.module_name = 'DuckDuck'

  spec.swift_version = '6'
  spec.source       = { :git => "https://github.com/xxwang/DuckDuck.swift.git", :branch => 'main' }
  spec.source_files  = 'Sources/DuckDuck/**/*.{c,h,m,swift}'
  
end

