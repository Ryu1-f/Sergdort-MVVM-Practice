# Sergdort-MVVM-Practice

## Setup
```terminal
$ carthage update --platform iOS --no-use-binaries
$ xcodegen
```

### install new library by Carthage
```terminal
$ carthage update <library name> --platform iOS --no-use-binaries
```　

### Gemfile
```terminal
$ bundle install --path vendor/bundle
```

### Pod install
```terminal
$ bundle exec pod install
```

### Integrate SwiftLint into an Xcode scheme
Integrate SwiftLint into an Xcode scheme to get warnings and errors displayed in the IDE. Just add a new "Run Script Phase" with:
```shell
if "${PODS_ROOT}/_Prebuild/GeneratedFrameworks/SwiftLint/swiftlint" >/dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```
