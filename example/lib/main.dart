import 'package:clarity_web/clarity_web.dart';
import 'package:flutter/material.dart';

/// Complete example of Microsoft Clarity Analytics integration
///
/// This example demonstrates how to use Clarity Web to:
/// - Initialize the analytics service
/// - Configure custom users
/// - Send custom events
/// - Set tags for tracking
/// - Control canvas capture
/// - Start, stop, pause and resume tracking
void main() {
  runApp(ClarityWebExampleApp());
}

class ClarityWebExampleApp extends StatelessWidget {
  const ClarityWebExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clarity Web Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClarityWebExampleHome(),
    );
  }
}

class ClarityWebExampleHome extends StatefulWidget {
  const ClarityWebExampleHome({super.key});

  @override
  State<ClarityWebExampleHome> createState() => _ClarityWebExampleHomeState();
}

class _ClarityWebExampleHomeState extends State<ClarityWebExampleHome> {
  final clarityService = ClarityWeb.instance;
  bool _isInitialized = false;
  bool _isCanvasMirrorActive = false;
  String _userId = '';
  int _eventCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeClarity();
  }

  /// Initializes Microsoft Clarity with custom settings
  Future<void> _initializeClarity() async {
    try {
      // Replace 'your-project-id' with your real Microsoft Clarity Project ID
      await clarityService.initClarityWeb(
        'tucuoh2mox', // ⚠️ IMPORTANT: Replace with your Project ID
        targetFpsMax: 8, // Maximum FPS for capture
        targetFpsMin: 3, // Minimum FPS for capture
        quality: 0.1, // Image quality (0.0 - 1.0)
      );

      setState(() {
        _isInitialized = true;
      });

      // Send application initialization event
      clarityService.sendCustomEvent('app_initialized');

      // Set default application tags
      clarityService.setCustomTag('app_name', 'Clarity Web Example');
      clarityService.setCustomTag('app_version', '1.0.0');
      clarityService.setCustomTag('platform', 'web');

      _showSnackBar('Clarity initialized successfully!', Colors.green);
    } catch (e) {
      _showSnackBar('Error initializing Clarity: $e', Colors.red);
      print('Error initializing Clarity: $e');
    }
  }

  /// Activates/deactivates canvas mirroring
  void _toggleCanvasMirror() {
    setState(() {
      _isCanvasMirrorActive = !_isCanvasMirrorActive;
    });

    clarityService.setIsCanvasMirrorActive(_isCanvasMirrorActive);

    _showSnackBar(
      'Canvas Mirror ${_isCanvasMirrorActive ? "Activated" : "Deactivated"}',
      _isCanvasMirrorActive ? Colors.green : Colors.orange,
    );
  }

  /// Sets a custom user
  void _setCustomUser() {
    if (_userId.isEmpty) {
      _showSnackBar('Enter a user ID', Colors.red);
      return;
    }

    clarityService.setCustomUserId(_userId);
    clarityService.setCustomTag('user_type', 'demo_user');
    clarityService.setCustomTag('login_time', DateTime.now().toIso8601String());

    _showSnackBar('User set: $_userId', Colors.blue);
  }

  /// Sends a custom event
  void _sendCustomEvent(String eventName) {
    clarityService.sendCustomEvent(eventName);
    setState(() {
      _eventCount++;
    });

    _showSnackBar('Event sent: $eventName', Colors.purple);
  }

  /// Sets custom tags
  void _setCustomTags() {
    clarityService.setCustomTag('button_clicks', _eventCount.toString());
    clarityService.setCustomTag(
      'session_duration',
      '${DateTime.now().millisecondsSinceEpoch}',
    );
    clarityService.setCustomTag('user_agent', 'flutter_web');

    _showSnackBar('Custom tags set', Colors.teal);
  }

  /// Updates Clarity with a specific reason
  void _upgradeClarity() {
    clarityService.upgradeClarity('user_requested_upgrade');
    _showSnackBar('Clarity updated', Colors.indigo);
  }

  /// Starts Clarity tracking
  void _startTracking() {
    // Example with custom configuration
    final config = {'projectId': 'your-project-id'};

    clarityService.start(config);
    _showSnackBar('Clarity tracking started with config', Colors.green);
  }

  /// Stops Clarity tracking
  void _stopTracking() {
    clarityService.stop();
    _showSnackBar('Clarity tracking stopped', Colors.red);
  }

  /// Pauses Clarity tracking
  void _pauseTracking() {
    clarityService.pause();
    _showSnackBar('Clarity tracking paused', Colors.orange);
  }

  /// Resumes Clarity tracking
  void _resumeTracking() {
    clarityService.resume();
    _showSnackBar('Clarity tracking resumed', Colors.blue);
  }

  /// Shows a feedback message
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clarity Web Example'),
        backgroundColor: Colors.blue[700],
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clarity Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _isInitialized ? Icons.check_circle : Icons.error,
                          color: _isInitialized ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _isInitialized ? 'Initialized' : 'Not initialized',
                          style: TextStyle(
                            fontSize: 16,
                            color: _isInitialized ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          clarityService.isLoaded
                              ? Icons.check_circle
                              : Icons.error,
                          color: clarityService.isLoaded
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text(
                          clarityService.isLoaded
                              ? 'Library loaded'
                              : 'Library not loaded',
                          style: TextStyle(
                            fontSize: 14,
                            color: clarityService.isLoaded
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Canvas Mirror Control
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Canvas Control',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Activate to capture canvas content in sessions',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12),
                    SwitchListTile(
                      title: Text('Canvas Mirror'),
                      subtitle: Text(
                        _isCanvasMirrorActive ? 'Activated' : 'Deactivated',
                      ),
                      value: _isCanvasMirrorActive,
                      onChanged: (_) => _toggleCanvasMirror(),
                      activeThumbColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Tracking Control Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tracking Control',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Control Clarity analytics tracking state',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _startTracking,
                          icon: Icon(Icons.play_arrow),
                          label: Text('Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _stopTracking,
                          icon: Icon(Icons.stop),
                          label: Text('Stop'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _pauseTracking,
                          icon: Icon(Icons.pause),
                          label: Text('Pause'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _resumeTracking,
                          icon: Icon(Icons.play_circle),
                          label: Text('Resume'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // User Management
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        hintText: 'Enter a unique ID',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) => setState(() => _userId = value),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _setCustomUser,
                      icon: Icon(Icons.person_add),
                      label: Text('Set User'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Event Tracking
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Tracking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Events sent: $_eventCount',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _sendCustomEvent('button_click'),
                          icon: Icon(Icons.mouse),
                          label: Text('Click'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _sendCustomEvent('page_view'),
                          icon: Icon(Icons.visibility),
                          label: Text('View'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _sendCustomEvent('user_action'),
                          icon: Icon(Icons.touch_app),
                          label: Text('Action'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Custom Tags
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Tags',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Set custom tags for advanced analysis',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _setCustomTags,
                      icon: Icon(Icons.label),
                      label: Text('Set Tags'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Advanced Actions
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advanced Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _upgradeClarity,
                      icon: Icon(Icons.upgrade),
                      label: Text('Update Clarity'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Canvas Example
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Canvas Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This canvas will be captured when mirroring is active',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomPaint(
                        painter: ExampleCanvasPainter(),
                        child: Center(
                          child: Text(
                            'Example Canvas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Painter to demonstrate canvas capture
class ExampleCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw animated circles
    for (int i = 0; i < 5; i++) {
      final center = Offset(size.width * (0.2 + i * 0.15), size.height * 0.5);
      canvas.drawCircle(center, 20 + i * 5, paint);
    }

    // Draw lines
    final linePaint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.7),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
