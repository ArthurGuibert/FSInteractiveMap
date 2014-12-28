Pod::Spec.new do |s|
	s.name = "FSInteractiveMap"
	s.version = "0.1.0"
	s.summary = "FSInteractiveMap is a charting library to visualize and interact with a vector map on iOS."
	s.description = <<-DESC
	It's like Geochart but for iOS. It's loading the maps from simple SVG files. It lets you visualize and interact with a vector map on iOS.
	DESC
	s.homepage = "https://github.com/ArthurGuibert/FSInteractiveMap"
	s.screenshots = "https://github.com/ArthurGuibert/FSInteractiveMap/raw/master/Screenshots/screen02.png"
	s.author = { "Arthur Guibert" => "birslip@gmail.com" }
	s.license = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
	s.platform = :ios, '7.0'
	s.source = { :git => "https://github.com/ArthurGuibert/FSInteractiveMap.git",:tag => "#{s.version}" }
	s.source_files = 'Classes', 'FSInteractiveMap/FSInteractiveMap/**/*.{h,m}'
	s.requires_arc = true
end
