# XcodeGen
run-xcodegen:
	xcodegen

# CocoaPods
install-cocoapods:
	bundle install --path vendor/bundle

install-pod:
	bundle exec pod install

remove-pod:
	rm -rf Pods/

# Carthage
install-carthage:
	carthage update --platform iOS --no-use-binaries

# SwiftLint
run-autocorrect:
	Pods/SwiftLint/swiftlint autocorrect
