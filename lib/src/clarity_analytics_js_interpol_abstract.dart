/// Abstract interface for Microsoft Clarity Analytics integration
///
/// This class defines the interface that must be implemented for integration
/// with Microsoft Clarity Analytics in Flutter Web applications.
///
/// Microsoft Clarity is a user behavior analytics tool that allows capturing
/// user sessions, heatmaps and insights about how users interact with your web application.
abstract class ClarityWebAbstract {
  /// Gets the singleton instance of the service
  ///
  /// Returns a unique instance of the Clarity Web service.
  /// This instance must be configured by the concrete implementation.
  static ClarityWebAbstract get instance {
    throw UnimplementedError('Instance must be set by concrete implementation');
  }

  /// Indicates if the Clarity library has been loaded successfully
  ///
  /// Returns `true` if the Clarity JavaScript library has been loaded
  /// and is available for use.
  bool get isLoaded;

  /// Indicates if Clarity has been initialized and is ready for use
  ///
  /// Returns `true` if Clarity has been initialized with a Project ID
  /// and is configured to capture data.
  bool get isInitialized;

  /// Initializes Microsoft Clarity with the specified settings
  ///
  /// This method loads the Clarity JavaScript library and initializes it
  /// with the provided Project ID and capture settings.
  ///
  /// **Parameters:**
  /// - [projectId] The project ID in Microsoft Clarity
  /// - [targetFpsMax] Maximum FPS for session capture (default: 5)
  /// - [targetFpsMin] Minimum FPS for session capture (default: 2)
  /// - [quality] Captured image quality, from 0.0 to 1.0 (default: 0.05)
  ///
  /// **Example:**
  /// ```dart
  /// await clarityService.initClarityWeb(
  ///   'your-project-id',
  ///   targetFpsMax: 10,
  ///   targetFpsMin: 3,
  ///   quality: 0.1,
  /// );
  /// ```
  Future<void> initClarityWeb(
    String projectId, {
    int targetFpsMax = 5,
    int targetFpsMin = 2,
    double quality = 0.05,
  });

  /// Activates or deactivates canvas mirroring for capture
  ///
  /// When activated, allows Clarity to capture content from canvas elements
  /// on the page, including Flutter graphics and animations.
  ///
  /// **Parameters:**
  /// - [isActive] `true` to activate canvas capture, `false` to deactivate
  ///
  /// **Example:**
  /// ```dart
  /// clarityService.setIsCanvasMirrorActive(true);
  /// ```
  void setIsCanvasMirrorActive(bool isActive);

  /// Sets a custom ID for the current user
  ///
  /// Allows associating sessions and events to a specific user,
  /// facilitating individual behavior analysis.
  ///
  /// **Parameters:**
  /// - [userId] Unique user ID
  ///
  /// **Example:**
  /// ```dart
  /// clarityService.setCustomUserId('user123');
  /// ```
  void setCustomUserId(String userId);

  /// Sets a custom tag for tracking
  ///
  /// Tags allow adding custom metadata to data collected by Clarity,
  /// facilitating segmentation and advanced analysis.
  ///
  /// **Parameters:**
  /// - [key] Tag key
  /// - [value] Tag value (will be converted to string)
  ///
  /// **Example:**
  /// ```dart
  /// clarityService.setCustomTag('user_type', 'premium');
  /// clarityService.setCustomTag('app_version', '1.0.0');
  /// ```
  void setCustomTag(String key, dynamic value);

  /// Sends a custom event for analysis
  ///
  /// Allows tracking specific user actions that are not
  /// automatically captured by Clarity.
  ///
  /// **Parameters:**
  /// - [eventName] Name of the event to be tracked
  ///
  /// **Example:**
  /// ```dart
  /// clarityService.sendCustomEvent('button_clicked');
  /// clarityService.sendCustomEvent('form_submitted');
  /// ```
  void sendCustomEvent(String eventName);

  /// Updates Clarity with a specific reason
  ///
  /// Allows forcing an update of the Clarity state,
  /// useful for synchronizing settings or resolving issues.
  ///
  /// **Parameters:**
  /// - [reason] Reason for the update
  ///
  /// **Example:**
  /// ```dart
  /// clarityService.upgradeClarity('user_requested_upgrade');
  /// ```
  void upgradeClarity(String reason);

  /// Starts Clarity analytics tracking
  ///
  /// Initializes and starts the Clarity analytics service with the given configuration.
  /// This method should be called after the library is loaded to begin tracking.
  ///
  /// **Parameters:**
  /// - [config] Optional configuration object for Clarity settings. If provided,
  ///   should contain settings like:
  ///   - `projectId`: The Clarity project ID
  ///   - `delay`: Delay in milliseconds for data upload (default: 1000)
  ///   - `lean`: Enable lean mode for reduced data collection (default: false)
  ///   - `track`: Enable tracking (default: true)
  ///   - `content`: Enable content capture (default: true)
  ///   - `fraud`: Enable fraud detection (default: true)
  ///   - `drop`: Array of URL parameters to drop from tracking
  ///   - `mask`: Array of CSS selectors to mask
  ///   - `unmask`: Array of CSS selectors to unmask
  ///   - `regions`: Array of custom regions to track
  ///   - `cookies`: Array of cookie names to track
  ///
  /// **Behavior:**
  /// - If no config is provided, uses default Clarity settings
  /// - Marks the service as initialized upon successful start
  /// - Can be called multiple times safely
  /// - Automatically handles consent configuration
  ///
  /// **Example:**
  /// ```dart
  /// // Start with default settings
  /// clarityService.start();
  ///
  /// // Start with custom configuration
  /// final config = {
  ///   'projectId': 'your-project-id',
  ///   'delay': 2000,
  ///   'lean': false,
  ///   'track': true,
  ///   'content': true,
  ///   'fraud': true,
  ///   'drop': ['utm_source', 'utm_medium'],
  ///   'mask': ['.sensitive-data', '#private-info'],
  ///   'unmask': ['.public-content'],
  ///   'regions': [['header', '.main-header'], ['footer', '.main-footer']],
  ///   'cookies': ['session_id', 'user_preferences'],
  /// };
  /// clarityService.start(config);
  /// ```
  void start([Map<String, dynamic>? config]);

  /// Stops Clarity analytics tracking
  ///
  /// Completely stops the Clarity analytics service and cleans up all resources.
  /// This method performs a complete shutdown of the analytics system.
  ///
  /// **What this method does:**
  /// - Terminates all data collection and tracking
  /// - Cleans up event listeners and observers
  /// - Stops all background processes
  /// - Marks the service as not initialized
  /// - Releases memory and resources
  /// - Disconnects from Clarity servers
  ///
  /// **When to use:**
  /// - User explicitly opts out of tracking
  /// - Application is being destroyed
  /// - Privacy compliance requirements
  /// - Performance optimization during heavy operations
  /// - Testing scenarios where tracking should be disabled
  ///
  /// **Important Notes:**
  /// - This is irreversible - you'll need to call [start()] again to resume
  /// - All pending data will be lost
  /// - Safe to call multiple times
  /// - Does not affect other parts of your application
  ///
  /// **Example:**
  /// ```dart
  /// // Stop tracking when user opts out
  /// void onPrivacySettingsChanged(bool allowTracking) {
  ///   if (!allowTracking) {
  ///     clarityService.stop();
  ///   } else {
  ///     clarityService.start();
  ///   }
  /// }
  ///
  /// // Stop tracking during app shutdown
  /// @override
  /// void dispose() {
  ///   clarityService.stop();
  ///   super.dispose();
  /// }
  /// ```
  void stop();

  /// Pauses Clarity analytics tracking
  ///
  /// Temporarily pauses data collection while keeping the service initialized.
  /// This is different from [stop()] as it maintains the service state and
  /// allows for quick resumption of tracking.
  ///
  /// **What this method does:**
  /// - Suspends all data collection and event tracking
  /// - Maintains service initialization state
  /// - Preserves configuration and settings
  /// - Keeps event listeners attached but inactive
  /// - Sends a "pause" event to Clarity servers
  ///
  /// **When to use:**
  /// - Temporary privacy concerns (e.g., sensitive form filling)
  /// - Performance optimization during intensive operations
  /// - User-initiated privacy controls
  /// - Compliance with "Do Not Track" requests
  /// - Battery saving mode on mobile devices
  /// - During video playback or media consumption
  ///
  /// **Important Notes:**
  /// - Service remains initialized and ready to resume
  /// - Configuration is preserved
  /// - Can be resumed quickly with [resume()]
  /// - Safe to call multiple times
  /// - Does not clean up resources (unlike [stop()])
  ///
  /// **Example:**
  /// ```dart
  /// // Pause during sensitive operations
  /// void onSensitiveFormStart() {
  ///   clarityService.pause();
  /// }
  ///
  /// void onSensitiveFormComplete() {
  ///   clarityService.resume();
  /// }
  ///
  /// // Pause for performance during heavy operations
  /// void onHeavyComputationStart() {
  ///   clarityService.pause();
  ///   // Perform heavy computation
  ///   performHeavyComputation();
  ///   clarityService.resume();
  /// }
  ///
  /// // Pause based on user preference
  /// void onPrivacyToggleChanged(bool allowTracking) {
  ///   if (allowTracking) {
  ///     clarityService.resume();
  ///   } else {
  ///     clarityService.pause();
  ///   }
  /// }
  /// ```
  void pause();

  /// Resumes Clarity analytics tracking
  ///
  /// Resumes data collection after being paused with [pause()].
  /// This method reactivates all tracking functionality that was temporarily suspended.
  ///
  /// **What this method does:**
  /// - Reactivates all data collection and event tracking
  /// - Resumes session recording and heatmap generation
  /// - Re-enables custom event tracking
  /// - Continues user behavior analysis
  /// - Sends a "resume" event to Clarity servers
  /// - Processes any queued events from the pause period
  ///
  /// **When to use:**
  /// - After completing sensitive operations
  /// - When user re-enables tracking preferences
  /// - After performance-intensive operations complete
  /// - When returning from privacy-focused sections
  /// - After battery saving mode is disabled
  /// - When user interaction resumes after inactivity
  ///
  /// **Important Notes:**
  /// - Only works if service was previously paused (not stopped)
  /// - If service was stopped, use [start()] instead
  /// - Maintains all previous configuration and settings
  /// - Safe to call multiple times
  /// - Does not reinitialize the service (unlike [start()])
  ///
  /// **Example:**
  /// ```dart
  /// // Resume after sensitive form completion
  /// void onSensitiveFormComplete() {
  ///   clarityService.resume();
  /// }
  ///
  /// // Resume when user enables tracking
  /// void onTrackingEnabled() {
  ///   clarityService.resume();
  /// }
  ///
  /// // Resume after heavy computation
  /// void onHeavyComputationComplete() {
  ///   clarityService.resume();
  /// }
  ///
  /// // Resume when app becomes active
  /// @override
  /// void didChangeAppLifecycleState(AppLifecycleState state) {
  ///   switch (state) {
  ///     case AppLifecycleState.resumed:
  ///       clarityService.resume();
  ///       break;
  ///     case AppLifecycleState.paused:
  ///       clarityService.pause();
  ///       break;
  ///     default:
  ///       break;
  ///   }
  /// }
  /// ```
  void resume();
}

class ClarityWeb implements ClarityWebAbstract {
  static ClarityWeb? _instance;
  static ClarityWeb get instance {
    _instance ??= ClarityWeb._internal();
    return _instance!;
  }

  ClarityWeb._internal();

  @override
  bool get isLoaded => throw UnimplementedError();

  @override
  bool get isInitialized => throw UnimplementedError();

  @override
  Future<void> initClarityWeb(
    String projectId, {
    int targetFpsMax = 5,
    int targetFpsMin = 2,
    double quality = 0.05,
  }) {
    throw UnimplementedError();
  }

  @override
  void setIsCanvasMirrorActive(bool isActive) {
    throw UnimplementedError();
  }

  @override
  void setCustomUserId(String userId) {
    throw UnimplementedError();
  }

  @override
  void sendCustomEvent(String eventName) {
    throw UnimplementedError();
  }

  @override
  void setCustomTag(String key, value) {
    throw UnimplementedError();
  }

  @override
  void upgradeClarity(String reason) {
    throw UnimplementedError();
  }

  @override
  void start([Map<String, dynamic>? config]) {
    throw UnimplementedError();
  }

  @override
  void stop() {
    throw UnimplementedError();
  }

  @override
  void pause() {
    throw UnimplementedError();
  }

  @override
  void resume() {
    throw UnimplementedError();
  }
}
