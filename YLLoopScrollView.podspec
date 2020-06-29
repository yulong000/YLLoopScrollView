Pod::Spec.new do |s|

  s.name         = "YLLoopScrollView"
  s.version      = "1.3.1"
  s.summary      = "轮播"
  s.description  = <<-DESC
                    轮播,可以在项目里多处调用, 只需要自定义需要轮播的view就可以了
                   DESC
  s.homepage     = "https://github.com/yulong000/YLLoopScrollView"
  s.license      = "MIT"
  s.author       = { "weiyulong" => "weiyulong1987@163.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/yulong000/YLLoopScrollView.git", :tag => s.version }
  s.source_files = "YLLoopScrollView/YLLoopScrollView/YLLoopScrollView/*.{h,m}"

end
