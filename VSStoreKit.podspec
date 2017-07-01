Pod::Spec.new do |s|

    s.name         = "VSStoreKit"
    s.version      = "0.1"
    s.summary      = "VSStoreKit"
    s.description  = "VSStoreKit"
    s.homepage     = "http://suvov.github.io"

    s.license      = "MIT"
    s.author       = { 'Vladimir Shutyuk' => 'shookup@gmail.com' }
    s.authors      = { 'Vladimir Shutyuk' => 'shookup@gmail.com' }
    s.platform     = :ios, "8.0"

    s.source       = { :path => '.' }
    s.source_files = "VSStoreKit", "VSStoreKit/**/*.{h,m,swift}"
    s.resources    = "VSStoreKit/*.{xcassets,storyboard,xib}"
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
