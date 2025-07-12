// File: lib/themes/wireframe/widgets/realtime_clock.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealtimeClock extends StatefulWidget {
  final TextStyle? textStyle;
  final String? format; // Optional custom format
  final bool showSeconds;

  const RealtimeClock({
    Key? key,
    this.textStyle,
    this.format,
    this.showSeconds = false,
  }) : super(key: key);

  @override
  State<RealtimeClock> createState() => _RealtimeClockState();
}

class _RealtimeClockState extends State<RealtimeClock> {
  late Timer _timer;
  String _currentTime = ''; // Initialize with empty string

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update every second if showing seconds, otherwise every minute
    final duration =
        widget.showSeconds ? Duration(seconds: 1) : Duration(minutes: 1);

    _timer = Timer.periodic(duration, (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    String format;

    if (widget.format != null) {
      format = widget.format!;
    } else {
      // Default format changed to 12-hour with AM/PM
      format = widget.showSeconds ? 'h:mm:ss a' : 'h:mm a';
    }

    final formatter = DateFormat(format);
    final newTime = formatter.format(now);

    if (newTime != _currentTime) {
      setState(() {
        _currentTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: widget.textStyle,
    );
  }
}

/// Digital clock with date
class RealtimeClockWithDate extends StatefulWidget {
  final TextStyle? timeStyle;
  final TextStyle? dateStyle;
  final bool showSeconds;
  final MainAxisAlignment alignment;

  const RealtimeClockWithDate({
    Key? key,
    this.timeStyle,
    this.dateStyle,
    this.showSeconds = false,
    this.alignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  State<RealtimeClockWithDate> createState() => _RealtimeClockWithDateState();
}

class _RealtimeClockWithDateState extends State<RealtimeClockWithDate> {
  late Timer _timer;
  String _currentTime = ''; // Initialize with empty string
  String _currentDate = ''; // Initialize with empty string

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();

    // Format time - changed to 12-hour format
    final timeFormat = widget.showSeconds ? 'h:mm:ss a' : 'h:mm a';
    final timeFormatter = DateFormat(timeFormat);
    final newTime = timeFormatter.format(now);

    // Format date
    final dateFormatter = DateFormat('MMM d, yyyy');
    final newDate = dateFormatter.format(now);

    if (newTime != _currentTime || newDate != _currentDate) {
      setState(() {
        _currentTime = newTime;
        _currentDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _currentTime,
          style: widget.timeStyle,
        ),
        Text(
          _currentDate,
          style: widget.dateStyle,
        ),
      ],
    );
  }
}
