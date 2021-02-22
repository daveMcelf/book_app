# book_app

Flutter Book App project using Provider.

## Getting Started
- Install Flutter and make sure everything is up and running: [documentation](https://flutter.dev/docs)
- Install packages in `pubspec.yaml`:
```
flutter pub get
```
- Run the app

** In IOS 14 update, There might be some issue when debug the app on devices. However, running in Simulator and Build using Xcode should still worked. See [IOS 14 Notice](https://flutter.dev/docs/development/ios-14)

## Features
- API connection with `http` package
- Persist storing data with `shared_preferences`
- Using `Isolate` to parse data in different thread to prevent working in Main thread => faster app starttime
- Cache HTTP data with File using `path_provider`
- Using `provider` for state management
- Open url browser within the app
- Textfield debounce for preventing flooding API request
- Infinite List scrolling
- Include Widget and Unit Testing
- Documentation to describe functions is include in each file

## Video Demo
[Demo App](https://youtu.be/TS7NXwyI8NM)

