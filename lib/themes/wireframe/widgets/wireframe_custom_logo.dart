import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

class WireframeCustomLogo extends StatefulWidget {
  final bool isMobile;
  final double? width;
  final double? height;

  const WireframeCustomLogo({
    Key? key,
    required this.isMobile,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<WireframeCustomLogo> createState() => _WireframeCustomLogoState();
}

class _WireframeCustomLogoState extends State<WireframeCustomLogo> {
  // Customizable properties
  bool _useGradientFont = true;
  Color _logoColor = Colors.blue;
  double _logoRotation = 0.0;
  Alignment _logoAlignment = Alignment.center;
  bool _showShadow = true;
  double _shadowBlurRadius = 1.0;
  Offset _shadowOffset = Offset(2, 2);
  Color _shadowColor = Colors.black26.withAlpha(0);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onLongPress: _showCustomizationModal,
      child: Transform.rotate(
        angle: _logoRotation,
        child: Container(
          width: widget.width ?? (widget.isMobile ? 120 : 240),
          height: widget.height ?? (widget.isMobile ? 28 : 60),
          alignment: _logoAlignment,
          child: _showShadow
              ? Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: _shadowBlurRadius,
                        offset: _shadowOffset,
                      ),
                    ],
                  ),
                  child: _buildLogoContent(),
                )
              : _buildLogoContent(),
        ),
      ),
    );
  }

  Widget _buildLogoContent() {
    return Text(
      'Jeffjitsu',
      style: TextStyle(
        fontFamily: 'Cocogoose',
        fontWeight: _useGradientFont ? FontWeight.w400 : FontWeight.w400,
        fontSize: widget.isMobile ? 20 : 30,
        color: _useGradientFont ? null : _logoColor,
        foreground: _useGradientFont
            ? (Paint()
              ..shader = LinearGradient(
                colors: [
                  _logoColor,
                  _logoColor.withAlpha(150),
                  WireframeColorManager.colors.primary,
                ],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)))
            : null,
      ),
    );
  }

  void _showCustomizationModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text('Customize Logo'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Font Style Toggle
                    SwitchListTile(
                      title: Text('Gradient Font'),
                      value: _useGradientFont,
                      onChanged: (value) {
                        setModalState(() {
                          setState(() {
                            _useGradientFont = value;
                          });
                        });
                      },
                    ),

                    // Color Picker
                    ListTile(
                      title: Text('Logo Color'),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _logoColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      onTap: () => _showColorPicker(setModalState),
                    ),

                    // Rotation Slider
                    Text(
                        'Rotation: ${(_logoRotation * 180 / 3.14159).round()}°'),
                    Slider(
                      value: _logoRotation,
                      min: -3.14159,
                      max: 3.14159,
                      divisions: 36,
                      onChanged: (value) {
                        setModalState(() {
                          setState(() {
                            _logoRotation = value;
                          });
                        });
                      },
                    ),

                    // Position Dropdown
                    DropdownButton<Alignment>(
                      value: _logoAlignment,
                      items: [
                        DropdownMenuItem(
                            value: Alignment.topLeft, child: Text('Top Left')),
                        DropdownMenuItem(
                            value: Alignment.topCenter,
                            child: Text('Top Center')),
                        DropdownMenuItem(
                            value: Alignment.topRight,
                            child: Text('Top Right')),
                        DropdownMenuItem(
                            value: Alignment.center, child: Text('Center')),
                        DropdownMenuItem(
                            value: Alignment.bottomLeft,
                            child: Text('Bottom Left')),
                        DropdownMenuItem(
                            value: Alignment.bottomCenter,
                            child: Text('Bottom Center')),
                        DropdownMenuItem(
                            value: Alignment.bottomRight,
                            child: Text('Bottom Right')),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          setState(() {
                            _logoAlignment = value!;
                          });
                        });
                      },
                    ),

                    // Shadow Toggle
                    SwitchListTile(
                      title: Text('Show Shadow'),
                      value: _showShadow,
                      onChanged: (value) {
                        setModalState(() {
                          setState(() {
                            _showShadow = value;
                          });
                        });
                      },
                    ),

                    if (_showShadow) ...[
                      Text('Shadow Blur: ${_shadowBlurRadius.round()}'),
                      Slider(
                        value: _shadowBlurRadius,
                        min: 0,
                        max: 20,
                        onChanged: (value) {
                          setModalState(() {
                            setState(() {
                              _shadowBlurRadius = value;
                            });
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showColorPicker(StateSetter setModalState) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.amber,
      WireframeColorManager.colors.primary,
      WireframeColorManager.colors.secondary,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Color'),
          content: Wrap(
            children: colors.map((color) {
              return ClickableWidget(
                onTap: () {
                  setModalState(() {
                    setState(() {
                      _logoColor = color;
                    });
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
