import 'package:flutter/material.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';

class PinAuthDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const PinAuthDialog({
    Key? key,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<PinAuthDialog> createState() => _PinAuthDialogState();
}

class _PinAuthDialogState extends State<PinAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isWrongPassword = false;

  // Your secret pin password - change this to whatever you want
  static const String _pinPassword = 'jef97212'; // MY PASSWORD FOR PINS!

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPassword() {
    if (_passwordController.text.trim() == _pinPassword) {
      Navigator.of(context).pop();
      widget.onSuccess();
    } else {
      setState(() {
        _isWrongPassword = true;
        _passwordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: WireframeColorManager.colors.surface,
      title: Text(
        'Pin Authorization',
        style: TextStyle(color: WireframeColorManager.colors.text),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter the admin password to pin this post:',
            style: TextStyle(color: WireframeColorManager.colors.textSecondary),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            onSubmitted: (_) => _checkPassword(),
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              errorText: _isWrongPassword ? 'Incorrect password' : null,
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _checkPassword,
          child: Text('Pin Post'),
        ),
      ],
    );
  }
}
