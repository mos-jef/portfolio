// File: lib/themes/wireframe/scroll_theme/audio_feedback.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Audio feedback system for enhanced scroll experience
class AudioFeedback {
  static bool _isEnabled = true;
  static double _volume = 0.5;
  static AudioTheme _currentTheme = AudioTheme.subtle;

  /// Enable or disable audio feedback
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Set audio volume (0.0 to 1.0)
  static void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }

  /// Set audio theme
  static void setTheme(AudioTheme theme) {
    _currentTheme = theme;
  }

  /// Play scroll start sound
  static void playScrollStart() {
    if (!_isEnabled) return;

    switch (_currentTheme) {
      case AudioTheme.subtle:
        HapticFeedback.lightImpact();
        break;
      case AudioTheme.mechanical:
        HapticFeedback.mediumImpact();
        break;
      case AudioTheme.digital:
        HapticFeedback.heavyImpact();
        break;
      case AudioTheme.none:
        break;
    }
  }

  /// Play wireframe transition sound
  static void playTransition() {
    if (!_isEnabled) return;

    switch (_currentTheme) {
      case AudioTheme.subtle:
        HapticFeedback.selectionClick();
        break;
      case AudioTheme.mechanical:
        HapticFeedback.mediumImpact();
        break;
      case AudioTheme.digital:
        HapticFeedback.heavyImpact();
        break;
      case AudioTheme.none:
        break;
    }
  }

  /// Play wireframe completion sound
  static void playCompletion() {
    if (!_isEnabled) return;

    switch (_currentTheme) {
      case AudioTheme.subtle:
        HapticFeedback.lightImpact();
        break;
      case AudioTheme.mechanical:
        HapticFeedback.heavyImpact();
        break;
      case AudioTheme.digital:
        _playSuccessPattern();
        break;
      case AudioTheme.none:
        break;
    }
  }

  /// Play hover sound
  static void playHover() {
    if (!_isEnabled) return;

    switch (_currentTheme) {
      case AudioTheme.subtle:
        HapticFeedback.selectionClick();
        break;
      case AudioTheme.mechanical:
        HapticFeedback.lightImpact();
        break;
      case AudioTheme.digital:
        HapticFeedback.selectionClick();
        break;
      case AudioTheme.none:
        break;
    }
  }

  /// Play click sound
  static void playClick() {
    if (!_isEnabled) return;
    HapticFeedback.mediumImpact();
  }

  /// Play error sound
  static void playError() {
    if (!_isEnabled) return;
    HapticFeedback.heavyImpact();
  }

  /// Play ambient scroll sound based on progress
  static void playAmbientScroll(double scrollProgress) {
    if (!_isEnabled || _currentTheme == AudioTheme.none) return;

    // Create subtle feedback based on scroll position
    if (scrollProgress > 0 && scrollProgress < 0.1) {
      // Beginning of scroll
      HapticFeedback.lightImpact();
    } else if (scrollProgress > 0.2 && scrollProgress < 0.3) {
      // Entering transition zone
      HapticFeedback.selectionClick();
    } else if (scrollProgress > 0.6 && scrollProgress < 0.7) {
      // Entering interactive zone
      HapticFeedback.mediumImpact();
    }
  }

  static void _playSuccessPattern() {
    // Play a pattern of haptic feedback for success
    HapticFeedback.lightImpact();
    Future.delayed(Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(Duration(milliseconds: 200), () {
      HapticFeedback.lightImpact();
    });
  }
}

/// Audio themes for different experiences
enum AudioTheme {
  none,
  subtle,
  mechanical,
  digital,
}

/// Audio-aware widget that provides contextual feedback
class AudioAwareWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onHover;
  final bool enableHover;
  final bool enableTap;
  final AudioFeedbackType feedbackType;

  const AudioAwareWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.onHover,
    this.enableHover = true,
    this.enableTap = true,
    this.feedbackType = AudioFeedbackType.click,
  }) : super(key: key);

  @override
  State<AudioAwareWidget> createState() => _AudioAwareWidgetState();
}

class _AudioAwareWidgetState extends State<AudioAwareWidget> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enableHover ? _onHover : null,
      child: GestureDetector(
        onTap: widget.enableTap ? _onTap : null,
        child: widget.child,
      ),
    );
  }

  void _onHover(PointerEnterEvent event) {
    AudioFeedback.playHover();
    widget.onHover?.call();
  }

  void _onTap() {
    switch (widget.feedbackType) {
      case AudioFeedbackType.click:
        AudioFeedback.playClick();
        break;
      case AudioFeedbackType.transition:
        AudioFeedback.playTransition();
        break;
      case AudioFeedbackType.completion:
        AudioFeedback.playCompletion();
        break;
      case AudioFeedbackType.error:
        AudioFeedback.playError();
        break;
    }
    widget.onTap?.call();
  }
}

/// Types of audio feedback
enum AudioFeedbackType {
  click,
  transition,
  completion,
  error,
}

/// Scroll-reactive audio controller
class ScrollAudioController {
  static double _lastScrollProgress = 0.0;
  static DateTime _lastFeedbackTime = DateTime.now();
  static const Duration _feedbackCooldown = Duration(milliseconds: 100);

  /// Update audio based on scroll progress
  static void updateScrollAudio(double scrollProgress) {
    final now = DateTime.now();

    // Throttle audio feedback
    if (now.difference(_lastFeedbackTime) < _feedbackCooldown) {
      return;
    }

    // Play ambient scroll feedback
    AudioFeedback.playAmbientScroll(scrollProgress);

    // Detect significant scroll events
    final progressDiff = (scrollProgress - _lastScrollProgress).abs();

    if (progressDiff > 0.1) {
      // Significant scroll movement
      if (scrollProgress > 0.2 &&
          scrollProgress < 0.3 &&
          _lastScrollProgress < 0.2) {
        // Entering transition zone
        AudioFeedback.playTransition();
      } else if (scrollProgress > 0.7 && _lastScrollProgress < 0.7) {
        // Reached interactive zone
        AudioFeedback.playCompletion();
      }

      _lastFeedbackTime = now;
    }

    _lastScrollProgress = scrollProgress;
  }
}

/// Audio settings widget for user preferences
class AudioSettingsWidget extends StatefulWidget {
  final Function(bool)? onEnabledChanged;
  final Function(double)? onVolumeChanged;
  final Function(AudioTheme)? onThemeChanged;

  const AudioSettingsWidget({
    Key? key,
    this.onEnabledChanged,
    this.onVolumeChanged,
    this.onThemeChanged,
  }) : super(key: key);

  @override
  State<AudioSettingsWidget> createState() => _AudioSettingsWidgetState();
}

class _AudioSettingsWidgetState extends State<AudioSettingsWidget> {
  bool _isEnabled = true;
  double _volume = 0.5;
  AudioTheme _selectedTheme = AudioTheme.subtle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audio & Haptic Feedback',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 16),

          // Enable/disable toggle
          SwitchListTile(
            title: Text('Enable Feedback'),
            subtitle: Text('Haptic and audio responses to interactions'),
            value: _isEnabled,
            onChanged: (value) {
              setState(() {
                _isEnabled = value;
              });
              AudioFeedback.setEnabled(value);
              widget.onEnabledChanged?.call(value);
            },
          ),

          if (_isEnabled) ...[
            SizedBox(height: 16),

            // Volume slider
            Text(
              'Feedback Intensity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Slider(
              value: _volume,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
                AudioFeedback.setVolume(value);
                widget.onVolumeChanged?.call(value);
              },
              divisions: 10,
              label: '${(_volume * 100).round()}%',
            ),

            SizedBox(height: 16),

            // Theme selection
            Text(
              'Feedback Style',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),

            ...AudioTheme.values.map((theme) => RadioListTile<AudioTheme>(
                  title: Text(_getThemeDisplayName(theme)),
                  subtitle: Text(_getThemeDescription(theme)),
                  value: theme,
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedTheme = value;
                      });
                      AudioFeedback.setTheme(value);
                      widget.onThemeChanged?.call(value);

                      // Play sample feedback
                      AudioFeedback.playClick();
                    }
                  },
                )),

            SizedBox(height: 16),

            // Test buttons
            Text(
              'Test Feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => AudioFeedback.playHover(),
                  child: Text('Hover'),
                ),
                ElevatedButton(
                  onPressed: () => AudioFeedback.playClick(),
                  child: Text('Click'),
                ),
                ElevatedButton(
                  onPressed: () => AudioFeedback.playTransition(),
                  child: Text('Transition'),
                ),
                ElevatedButton(
                  onPressed: () => AudioFeedback.playCompletion(),
                  child: Text('Success'),
                ),
              ],
            ),
          ],

          SizedBox(height: 16),

          // Accessibility note
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.accessibility, color: Colors.blue[700]),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Haptic feedback enhances the user experience and provides accessibility benefits for users with visual impairments.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeDisplayName(AudioTheme theme) {
    switch (theme) {
      case AudioTheme.none:
        return 'Silent';
      case AudioTheme.subtle:
        return 'Subtle';
      case AudioTheme.mechanical:
        return 'Mechanical';
      case AudioTheme.digital:
        return 'Digital';
    }
  }

  String _getThemeDescription(AudioTheme theme) {
    switch (theme) {
      case AudioTheme.none:
        return 'No haptic feedback';
      case AudioTheme.subtle:
        return 'Light, gentle feedback';
      case AudioTheme.mechanical:
        return 'Crisp, tactile feedback';
      case AudioTheme.digital:
        return 'Tech-inspired patterns';
    }
  }
}
