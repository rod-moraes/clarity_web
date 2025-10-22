/// Clarity Web library for Microsoft Clarity Analytics integration
///
/// This library provides a Dart interface for integrating with Microsoft Clarity
/// Analytics in Flutter Web applications, enabling user session capture,
/// behavior analysis and custom event tracking.
///
/// **Main features:**
/// - Native integration with Microsoft Clarity Analytics
/// - Automatic canvas content capture
/// - Flexible FPS and quality configuration
/// - Support for custom events and tags
/// - User identification
/// - Automatic consent configuration
///
/// **Basic usage:**
/// ```dart
/// import 'package:clarity_web/clarity_web.dart';
///
/// final clarityService = ClarityWeb.instance;
/// await clarityService.initClarityWeb('your-project-id');
/// ```
///
/// **Advanced features:**
/// ```dart
/// // Custom configuration
/// await clarityService.initClarityWeb(
///   'your-project-id',
///   targetFpsMax: 10,
///   targetFpsMin: 3,
///   quality: 0.1,
/// );
///
/// // Activate canvas capture
/// clarityService.setIsCanvasMirrorActive(true);
///
/// // Set custom user
/// clarityService.setCustomUserId('user123');
///
/// // Send custom events
/// clarityService.sendCustomEvent('button_clicked');
///
/// // Set custom tags
/// clarityService.setCustomTag('user_type', 'premium');
/// ```
///
/// For more information, see the complete documentation in README.md
/// or the examples in the `example/` folder.
library;

export './src/clarity_analytics_js_interpol_abstract.dart'
    if (dart.library.js_interop) './src/clarity_analytics_js_interpol.dart';
