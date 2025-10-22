# Clarity Web

A Flutter library for integrating with Microsoft Clarity Analytics, enabling user session capture and behavior analysis in Flutter web applications.

## ⚠️ Important - About Canvas Capture

This package implements an **optimized workaround** to generate screen captures efficiently, allowing Microsoft Clarity to visualize and record canvas content, simulating real recording. This solution was developed because **it's not possible to directly record the canvas** in Flutter Web applications.

**IT IS MANDATORY** to activate `setIsCanvasMirrorActive(true)` for capture to work correctly, as it's through this function that the screen capture workaround is executed.

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Basic Usage](#basic-usage)
- [Tracking Control](#tracking-control)
- [Examples](#examples)
- [Documentation](#documentation)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

- **Complete Integration**: Native integration with Microsoft Clarity Analytics
- **Canvas Capture**: Automatic canvas content capture for session analysis
- **Flexible Configuration**: FPS control, quality, and canvas mirroring
- **Custom Events**: Send custom events and personalized tags
- **User Identification**: Support for custom user identification
- **Consent Management**: Automatic consent configuration for analytics
- **Tracking Control**: Start, stop, pause, and resume analytics tracking
- **Dynamic Configuration**: Runtime configuration updates

## 🚀 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  clarity_web: ^0.0.1
```

Run the command:

```bash
flutter pub get
```

## ⚙️ Configuration

### 1. Get Clarity Project ID

1. Visit [Microsoft Clarity](https://clarity.microsoft.com/)
2. Create a new project or access an existing one
3. Copy the Project ID from the project configuration

## 📖 Basic Usage

### Initialization

```dart
import 'package:clarity_web/clarity_web.dart';

// Get service instance
final clarityService = ClarityWebJsInteropService.instance;

// Initialize with Project ID
await clarityService.initClarityWeb('your-project-id');
```

### Advanced Configuration

```dart
await clarityService.initClarityWeb(
  'your-project-id',
  targetFpsMax: 10,    // Maximum FPS for capture
  targetFpsMin: 3,      // Minimum FPS for capture
  quality: 0.1,         // Image quality (0.0 - 1.0)
);
```

## 🎮 Tracking Control

The library provides comprehensive control over Clarity analytics tracking:

**Note**: The `start`, `stop`, `resume`, and `pause` functions are **NOT mandatory** - they are only for greater control. When Clarity is initialized, it automatically starts tracking. However, **to enable screen captures, you MUST activate `setIsCanvasMirrorActive(true)`**.

### Start Tracking

```dart
// Start with default configuration
clarityService.start();

// Start with custom configuration
final config = {
  'projectId': 'your-project-id',
  'delay': 1000,
  'lean': false,
  'track': true,
  'content': true,
};
clarityService.start(config);
```

### Stop Tracking

```dart
// Completely stop tracking and clean up resources
clarityService.stop();
```

### Pause/Resume Tracking

```dart
// Temporarily pause data collection
clarityService.pause();

// Resume data collection
clarityService.resume();
```

### Use Cases (Optional Functions)

These functions are **optional** and provide additional control:

- **Privacy Compliance**: Pause tracking when users opt out
- **Performance**: Stop tracking during heavy operations
- **User Control**: Allow users to control their privacy settings
- **Dynamic Configuration**: Update settings without restarting

**Remember**: Clarity starts automatically after initialization. Only `setIsCanvasMirrorActive(true)` is mandatory for screen captures.

## 📚 Documentation

### Comprehensive Guides

- **[Tracking Control Guide](docs/tracking_control_guide.md)**: Complete guide for using start, stop, pause, and resume functions
- **[API Reference](lib/src/clarity_analytics_js_interpol_abstract.dart)**: Detailed API documentation
- **[Example App](example/lib/main.dart)**: Complete working example with all features

### Quick Reference

| Function                        | Purpose                       | When to Use                       | Mandatory  |
| ------------------------------- | ----------------------------- | --------------------------------- | ---------- |
| `start([config])`               | Initialize and start tracking | App launch, user consent          | ❌ No      |
| `stop()`                        | Completely stop tracking      | User opt-out, app shutdown        | ❌ No      |
| `pause()`                       | Temporarily pause tracking    | Sensitive operations, performance | ❌ No      |
| `resume()`                      | Resume paused tracking        | After sensitive operations        | ❌ No      |
| `setIsCanvasMirrorActive(true)` | Enable screen captures        | Canvas capture workaround         | ✅ **YES** |

## 🎯 Examples

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:clarity_web/clarity_web.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final clarityService = ClarityWebJsInteropService.instance;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeClarity();
  }

  Future<void> _initializeClarity() async {
    try {
      await clarityService.initClarityWeb('your-project-id');
      setState(() {
        _isInitialized = true;
      });

      // ⚠️ MANDATORY: Enable screen captures (Clarity starts automatically)
      clarityService.setIsCanvasMirrorActive(true);

      // Configure custom user
      clarityService.setCustomUserId('user123');

      // Send initialization event
      clarityService.sendCustomEvent('app_initialized');

    } catch (e) {
      print('Error initializing Clarity: $e');
    }
  }

  void _trackButtonClick() {
    clarityService.sendCustomEvent('button_clicked');
  }

  void _setUserTag() {
    clarityService.setCustomTag('user_type', 'premium');
    clarityService.setCustomTag('app_version', '1.0.0');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Clarity Web Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clarity Status: ${_isInitialized ? "Initialized" : "Not initialized"}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _trackButtonClick,
                child: Text('Track Click'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _setUserTag,
                child: Text('Set Tags'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Canvas Example

```dart
import 'package:flutter/material.dart';
import 'package:clarity_web/clarity_web.dart';

class CanvasExample extends StatefulWidget {
  @override
  _CanvasExampleState createState() => _CanvasExampleState();
}

class _CanvasExampleState extends State<CanvasExample> {
  final clarityService = ClarityWebJsInteropService.instance;

  @override
  void initState() {
    super.initState();
    _setupClarity();
  }

  Future<void> _setupClarity() async {
    await clarityService.initClarityWeb('your-project-id');

    // ⚠️ MANDATORY: Activate canvas mirroring for capture
    // This function executes the screen capture workaround
    clarityService.setIsCanvasMirrorActive(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: MyCustomPainter(),
        child: Container(),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Your drawing code here
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
```

## 📚 API Reference

### ClarityWebJsInteropService

#### Properties

- `bool isLoaded`: Indicates if the Clarity library has been loaded
- `bool isInitialized`: Indicates if Clarity has been initialized

#### Methods

##### `initClarityWeb(String projectId, {int targetFpsMax, int targetFpsMin, double quality})`

Initializes Microsoft Clarity with the specified settings.

**Parameters:**

- `projectId` (String): Project ID in Microsoft Clarity
- `targetFpsMax` (int, optional): Maximum FPS for capture (default: 5)
- `targetFpsMin` (int, optional): Minimum FPS for capture (default: 2)
- `quality` (double, optional): Captured image quality 0.0-1.0 (default: 0.05)

**Returns:** `Future<void>`

##### `setIsCanvasMirrorActive(bool isActive)` ⚠️ **MANDATORY**

**This function is MANDATORY** for canvas capture to work. It executes the screen capture workaround, allowing Clarity to visualize canvas content.

**Parameters:**

- `isActive` (bool): true to activate (MANDATORY), false to deactivate

##### `setCustomUserId(String userId)`

Sets a custom ID for the current user.

**Parameters:**

- `userId` (String): Unique user ID

##### `setCustomTag(String key, dynamic value)`

Sets a custom tag for tracking.

**Parameters:**

- `key` (String): Tag key
- `value` (dynamic): Tag value

##### `sendCustomEvent(String eventName)`

Sends a custom event for analysis.

**Parameters:**

- `eventName` (String): Event name

##### `upgradeClarity(String reason)`

Updates Clarity with a specific reason.

**Parameters:**

- `reason` (String): Reason for the update

## 🔧 Advanced Configuration

### FPS Control

```dart
// For applications with lots of movement
await clarityService.initClarityWeb(
  'project-id',
  targetFpsMax: 15,
  targetFpsMin: 5,
);

// For static applications
await clarityService.initClarityWeb(
  'project-id',
  targetFpsMax: 2,
  targetFpsMin: 1,
);
```

### Capture Quality

```dart
// High quality (higher bandwidth usage)
await clarityService.initClarityWeb(
  'project-id',
  quality: 0.8,
);

// Low quality (lower bandwidth usage)
await clarityService.initClarityWeb(
  'project-id',
  quality: 0.1,
);
```

## 🐛 Troubleshooting

### Clarity doesn't initialize

1. Check if the Project ID is correct
2. Confirm that the `clarity_web.js` file is being loaded
3. Check the browser console for errors

### Canvas is not captured

1. **⚠️ MANDATORY**: Make sure `setIsCanvasMirrorActive(true)` was called - this function executes the screen capture workaround
2. Check if there are canvas elements on the page
3. Confirm that the canvas has visible content

### Performance

1. Adjust FPS values as needed
2. Reduce quality if there are performance issues
3. Use `setIsCanvasMirrorActive(false)` when capture is not needed (remember that this function executes the screen capture workaround)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Useful Links

- [Microsoft Clarity](https://clarity.microsoft.com/)
- [Clarity Documentation](https://docs.microsoft.com/en-us/clarity/)
- [Flutter Web](https://flutter.dev/web)
