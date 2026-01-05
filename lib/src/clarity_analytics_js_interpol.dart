/// Concrete implementation of Microsoft Clarity Analytics integration
///
/// This class implements the [ClarityWebAbstract] interface using
/// JavaScript Interop for communication with the Clarity library.
///
/// **Features:**
/// - Automatic loading of Clarity JavaScript library
/// - Consent configuration for analytics
/// - Canvas capture with FPS and quality control
/// - Support for custom events and tags
///
/// **Usage:**
/// ```dart
/// final clarityService = ClarityWeb.instance;
/// await clarityService.initClarityWeb('your-project-id');
/// ```
@JS()
library;

import 'dart:js_interop';

import 'package:web/web.dart';

import 'clarity_analytics_js_interpol_abstract.dart';

/// Clarity JavaScript function loaded dynamically
@JS('clarity')
external JSFunction? _clarityFunction;

/// Global flag to control canvas mirroring
@JS('window.isCanvasMirrorActive')
external set isCanvasMirrorActive(JSBoolean value);

/// Clarity library available globally
@JS('window.clarityLib')
external ClarityLib? clarityLib;

/// Extension type for the Clarity JavaScript library
///
/// This extension allows calling Clarity JavaScript methods
/// in a type-safe way using Dart JS Interop.
extension type ClarityLib(JSObject _) implements JSObject {
  /// Loads the Clarity script for the specified project
  ///
  /// **Parameters:**
  /// - [projectId] Project ID in Microsoft Clarity
  external void clarityScript(String projectId);

  /// Initializes Clarity with specific settings
  ///
  /// **Parameters:**
  /// - [projectId] Project ID in Microsoft Clarity
  /// - [targetFpsMax] Maximum FPS for capture
  /// - [targetFpsMin] Minimum FPS for capture
  /// - [quality] Captured image quality
  external void clarityInit(
    String projectId,
    int targetFpsMax,
    int targetFpsMin,
    double quality,
  );
}

/// Concrete implementation of the Clarity Web service
///
/// This class implements all the necessary functionality for
/// integration with Microsoft Clarity Analytics in Flutter Web applications.
///
/// **Features:**
/// - Dynamic JavaScript library loading
/// - Initialization with custom settings
/// - Canvas capture control
/// - Custom event and tag tracking
/// - User identification
class ClarityWeb implements ClarityWebAbstract {
  static ClarityWeb? _instance;

  /// Gets the singleton instance of the service
  ///
  /// Returns a unique instance of the service, creating a new one if necessary.
  /// This implementation follows the Singleton pattern to ensure that only
  /// one instance of the service is used throughout the application.
  static ClarityWeb get instance {
    _instance ??= ClarityWeb._internal();
    return _instance!;
  }

  /// Private constructor to implement the Singleton pattern
  ClarityWeb._internal();

  @override
  bool get isLoaded => _clarityFunction != null;

  @override
  bool get isInitialized => _isInitialized;

  /// Internal flag to control initialization state
  bool _isInitialized = false;

  @override
  Future<void> initClarityWeb(
    String projectId, {
    int targetFpsMax = 5,
    int targetFpsMin = 2,
    double quality = 0.05,
  }) async {
    const path = 'assets/packages/clarity_web/web/js/clarity_web.js';

    // Check if script has already been loaded to avoid duplicate loading
    if (document.querySelector('script[src="$path"]') != null) return;

    // Create and add the Clarity script to the document
    final script = HTMLScriptElement()
      ..src = path
      ..type = 'application/javascript';
    document.head!.append(script);

    // Wait for the script to load completely
    await script.onLoad.first;

    // Initialize Clarity with the provided settings
    clarityLib!.clarityInit(projectId, targetFpsMax, targetFpsMin, quality);
    _initClarity();
  }

  /// Initializes Clarity with consent settings
  ///
  /// This private method configures consent for analytics
  /// and marks the service as initialized.
  void _initClarity() {
    if (!isLoaded) return;
    if (_isInitialized) return;
    _isInitialized = true;

    // Configure consent for analytics
    _clarityFunction!.callAsFunction(
      null,
      'consentv2'.toJS,
      {'ad_Storage': 'granted', 'analytics_Storage': 'granted'}.toJSBox,
    );
    _clarityFunction!.callAsFunction(null, 'consent'.toJS, true.toJS);
  }

  @override
  void setIsCanvasMirrorActive(bool isActive) {
    isCanvasMirrorActive = isActive.toJS;
    _initClarity();
  }

  @override
  void setCustomUserId(String userId) {
    if (!isLoaded) return;
    _initClarity();
    _clarityFunction!.callAsFunction(null, 'identify'.toJS, userId.toJS);
  }

  @override
  void setCustomTag(String key, dynamic value) {
    if (!isLoaded) return;
    _initClarity();
    _clarityFunction!.callAsFunction(
      null,
      'set'.toJS,
      key.toJS,
      value.toString().toJS,
    );
  }

  @override
  void sendCustomEvent(String eventName) {
    if (!isLoaded) return;
    _initClarity();
    _clarityFunction!.callAsFunction(null, 'event'.toJS, eventName.toJS);
  }

  @override
  void upgradeClarity(String reason) {
    if (!isLoaded) return;
    _initClarity();
    _clarityFunction!.callAsFunction(null, 'upgrade'.toJS, reason.toJS);
  }

  @override
  void start([Map<String, dynamic>? config]) {
    if (!isLoaded) return;
    _initClarity();
    if (config != null) {
      _clarityFunction!.callAsFunction(null, 'start'.toJS, config.toJSBox);
    } else {
      _clarityFunction!.callAsFunction(null, 'start'.toJS);
    }
    _isInitialized = true;
  }

  @override
  void stop() {
    if (!isLoaded) return;
    _initClarity();
    _clarityFunction!.callAsFunction(null, 'stop'.toJS);
    _isInitialized = false;
  }

  @override
  void pause() {
    if (!isLoaded) return;
    _initClarity();
    _clarityFunction!.callAsFunction(null, 'pause'.toJS);
  }

  @override
  void resume() {
    if (!isLoaded) return;
    _initClarity();
    _clarityFunction!.callAsFunction(null, 'resume'.toJS);
  }
}
