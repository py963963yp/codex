# Focus Flow

一个使用 Flutter 构建的离线专注计时器，可运行于 Android、iOS 和 Web。
当前仓库提供 Android 自动构建配置。

## 功能

- 15、25、45 分钟专注预设与 5 分钟休息预设
- 开始、暂停和重置计时
- 专注结束后自动切换到休息状态
- 本地保存已完成的专注次数
- 深色响应式界面，无网络和账户依赖

## 技术栈

- Flutter / Dart
- `shared_preferences` 本地持久化
- GitHub Actions 编译 Android release APK

## 本地运行

```sh
flutter pub get
flutter run
```

## 检查与构建

```sh
dart format lib test
flutter analyze
flutter test
flutter build apk --release
```

APK 输出路径为 `build/app/outputs/flutter-apk/app-release.apk`。
GitHub Actions 会在推送到 `main`、提交 Pull Request 或手动触发时运行，
并将 APK 与 SHA-256 校验文件上传为 `focus-flow-android` 构建产物。

## 目录

```text
lib/
  main.dart                        应用入口与依赖装配
  src/app.dart                     计时器界面
  src/focus_timer_controller.dart  计时状态与业务逻辑
  src/session_store.dart           本地存储接口与实现
test/                              单元测试和组件测试
android/                           Android 工程
.github/workflows/android.yml      APK 构建工作流
```
