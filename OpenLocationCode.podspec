Pod::Spec.new do |s|

  s.name         = "OpenLocationCode"
  s.version      = "0.9.0"
  s.summary      = "Open Location Code"

  s.description  = <<-DESC

Open Location Codes are short, 10-11 character codes that can be used
instead of street addresses. The codes can be generated and decoded offline,
and use a reduced character set that minimises the chance of codes including
words.

                   DESC

  s.homepage     = "https://openlocationcode.com"
  s.license      = "Apache License, Version 2.0"
  s.authors      = { "William Denniss" => "wdenniss@google.com",
                   }

  s.platforms    = { :ios => "8.0", :osx => "10.9", :watchos => "2.0", :tvos => "9.0" }

  s.source       = { :git => "https://github.com/WilliamDenniss/open-location-code.git", :commit => "414c0f4cc0f2f3bb56bc02656728e75d472c11fc" }

  s.pod_target_xcconfig = {
    # Treat warnings as errors.
  }

  s.source_files = "swift/*.swift"
  s.requires_arc = true
end
