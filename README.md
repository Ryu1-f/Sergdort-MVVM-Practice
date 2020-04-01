# Sergdort-MVVM-Practice

## Setup
### install libraries by Carthage
```terminal
$ make install-carthage
```

### make project file
```terminal
$ make run-xcodegen
```

### install new library by Carthage(if necessary)
```terminal
$ carthage update <library name> --platform iOS --no-use-binaries
```

### Gemfile
```terminal
$ make install-cocoapods
```

### Pod install
```terminal
$ make install-pod
```

### Integrate SwiftLint(installed by brew) into an Xcode scheme
Integrate SwiftLint into an Xcode scheme to get warnings and errors displayed in the IDE. Just add a new "Run Script Phase" with:
```shell
if which swiftlint >/dev/null; then
    swiftlint
    swiftlint autocorrect --format
else
```

