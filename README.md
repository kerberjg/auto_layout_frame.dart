<div align="center">

# auto_layout_frame
Flutter implementation of Figma's Auto Layout frames with support for alignment, padding, gap, resizing, and overflow behavior.

```bash
flutter pub add auto_layout_frame
```

<!-- Badges -->
<!-- remember to update these badges when using the template! -->

[![License: MPL-2.0](https://img.shields.io/badge/License-MPL_2.0-brightgreen.svg)](LICENSE)
[![build](https://github.com/kerberjg/auto_layout_frame.dart/actions/workflows/package.yaml/badge.svg)](https://github.com/kerberjg/auto_layout_frame.dart/actions/workflows/package.yaml)
[![example](https://github.com/kerberjg/auto_layout_frame.dart/actions/workflows/example.yaml/badge.svg)](https://github.com/kerberjg/auto_layout_frame.dart/actions/workflows/example.yaml)
[![stars](https://img.shields.io/github/stars/kerberjg/auto_layout_frame.dart.svg)](https://github.com/kerberjg/auto_layout_frame.dart/stargazers)
<br/>
[![pub package](https://img.shields.io/pub/v/auto_layout_frame?logo=dart)](https://pub.dev/packages/auto_layout_frame)
[![pub score](https://img.shields.io/pub/points/auto_layout_frame?logo=dart)](https://pub.dev/packages/auto_layout_frame/score)
[![likes](https://img.shields.io/pub/likes/auto_layout_frame?logo=dart)](https://pub.dev/packages/auto_layout_frame/likes)

</div>

### 💙 Use cases
- 🎨 **Figma-like layouts**: Replicate Figma's Auto Layout behavior in your Flutter apps
- 📱 **Responsive UI**: Build flexible, responsive layouts that adapt to different screen sizes
- 🚀 **Rapid prototyping**: Quickly create complex layouts with an intuitive, declarative syntax

<img style="width: 100%;" src="https://github.com/kerberjg/auto_layout_frame.dart/blob/0.1.1/screenshots/editor.gif?raw=true"/>


## ✨ Features
- **🎯 Alignment**: Control child alignment with `alignChildren`
- **📏 Padding & Gap**: Set padding around children and gap between them (including auto-spacing with `gap: double.infinity`)
- **📐 Resizing**: Choose from `fixed`, `hugContents`, or `fillContainer` for horizontal and vertical axes
- **↔️ Direction**: Layout children horizontally, vertically, or with wrapping
- **🔄 Overflow handling**: Choose from `none`, `clip`, `visible`, or `scroll` behaviors
- **🪆 Proper nesting**: Automatically handles nested `AutoLayoutFrame`s with correct constraint handling

#### Coming soon:
- **📚 More docs/examples**
- **🧩 More layout options**
- **⚡ Performance optimizations** 

---

## 🔮 Usage Guide

### Getting Started
Add `auto_layout_frame` to your `pubspec.yaml`:

```bash
flutter pub add auto_layout_frame
```

Then import it in your Dart code:

```dart
import 'package:auto_layout_frame/auto_layout_frame.dart';
```

### Basic Example

```dart
AutoLayoutFrame(
  direction: AutoLayoutDirection.vertical,
  gap: 16,
  padding: EdgeInsets.all(20),
  alignChildren: Alignment.centerLeft,
  children: [
    Text('Hello'),
    Text('World'),
    Text('Auto Layout!'),
  ],
)
```

### Advanced Example

```dart
AutoLayoutFrame(
  direction: AutoLayoutDirection.horizontal,
  gap: double.infinity, // Auto-space children
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  alignChildren: Alignment.center,
  horizontalResizing: AutoLayoutResizing.fillContainer,
  verticalResizing: AutoLayoutResizing.hugContents,
  backgroundColor: Colors.blue.shade50,
  overflow: AutoLayoutOverflowBehavior.scroll,
  children: [
    Icon(Icons.star),
    Text('Featured Item'),
    Icon(Icons.arrow_forward),
  ],
)
```

### Resizing

**Like Figma**, you can control how the frame resizes on both axes:

- **`AutoLayoutResizing.fixed`**: Fixed size (requires explicit `width`/`height`)
- **`AutoLayoutResizing.hugContents`**: Shrink-wrap to fit children
- **`AutoLayoutResizing.fillContainer`**: Expand to fill available space

### Overflow

**New!**: Control how overflow is handled when children exceed frame bounds:

- **`AutoLayoutOverflowBehavior.none`**: Allow overflow errors (default)
- **`AutoLayoutOverflowBehavior.clip`**: Clip overflow to frame bounds
- **`AutoLayoutOverflowBehavior.visible`**: Allow overflow to be visible
- **`AutoLayoutOverflowBehavior.scroll`**: Make frame scrollable 

---

## 📄 License

This project is licensed under the Mozilla Public License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🔥 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes. Make sure to read the following guidelines before contributing:

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- ["Effective Dart" Style Guide](https://dart.dev/guides/language/effective-dart)
- [**pub.dev** Package Publishing Guidelines](https://dart.dev/tools/pub/publishing)

## 🙏 Credits & Acknowledgements

<!-- REMEMBER! Update the URLs below to point to your own username/repo! -->

### Contributors 🧑‍💻💙📝

This package is developed/maintained by the following rockstars!
Your contributions make a difference! 💖

![contributors badge](https://readme-contribs.as93.net/contributors/kerberjg/auto_layout_frame.dart?textColor=888888)

### Sponsors 🫶✨🥳

Kind thanks to all our sponsors! Thank you for supporting the Dart/Flutter community, and keeping open source alive! 💙

![sponsors badge](https://readme-contribs.as93.net/sponsors/kerberjg?textColor=888888)

---

<!-- Keep the below notice -->

> Based on [`dart_package_template`](https://github.com/kerberjg/dart_package_template) - a high-quality Dart package template with best practices, CI/CD, and more! 💙✨