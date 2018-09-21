Pod::Spec.new do |s|

    s.name         = "VSStoreKit"
    s.version      = "1.0.3"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }

    s.summary      = "Simple iOS StoreKit library"
    s.description  = <<-DESC
You can use VSStoreKit to make in-app purchases in iOS app.
                    DESC
    s.homepage         = 'https://github.com/suvov/VSStoreKit'
    s.author       = { 'Vladimir Shutyuk' => 'vladimir.shutyuk@gmail.com' }
    s.platform     = :ios, "8.0"

    s.source       = { :git => 'https://github.com/suvov/VSStoreKit.git', :tag => s.version.to_s }
    s.source_files = 'VSStoreKit/*.swift'
    s.ios.deployment_target = '8.0'
end
