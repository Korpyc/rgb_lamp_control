import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColorPickerView extends StatefulWidget {
  ColorPickerView(
      {this.radius = 120,
      this.thumbRadius = 10,
      this.initialColor = const Color(0xffff0000),
      required this.colorListener});

  final double radius;
  final double thumbRadius;
  final ValueChanged<Color>? colorListener;
  final Color initialColor;

  @override
  _ColorPickerViewState createState() => _ColorPickerViewState();
}

class _ColorPickerViewState extends State<ColorPickerView> {
  static const List<Color> colors = [
    Color(0xffff0000),
    Color(0xffff00ff),
    Color(0xff0000ff),
    Color(0xff00ffff),
    Color(0xff00ff00),
    Color(0xffffff00),
    Color(0xffff0000)
  ];

  double thumbDistanceToCenter = 0;
  double thumbRadians = 0;
  double barWidth = 0;
  double barHeight = 0;

  Color? mixedColor;
  Color? baseColor;
  double rate = 0;

  @override
  void initState() {
    super.initState();

    mixedColor = widget.initialColor;
    baseColor = widget.initialColor;

    barWidth = widget.radius * 2;
    barHeight = widget.thumbRadius * 2;
    rate = HSVColor.fromColor(widget.initialColor).value;

    thumbRadians =
        degreesToRadians(HSVColor.fromColor(widget.initialColor).hue - 90);
    thumbDistanceToCenter = (widget.radius - widget.thumbRadius) *
        HSVColor.fromColor(widget.initialColor).saturation;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.2,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: colors,
              ),
            ),
          ),
        ),
        _wheelArea(),
        // will be used in future
        /* Align(alignment: Alignment(0, 0.7), child: _barArea()), */
      ],
    );
  }

  Widget _thumb(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: widget.thumbRadius * 2,
        height: widget.thumbRadius * 2,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(widget.thumbRadius)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black, spreadRadius: 0.1),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: mixedColor,
            borderRadius: BorderRadius.all(Radius.circular(widget.thumbRadius)),
          ),
        ),
      ),
    );
  }

  Widget _wheelArea() {
    final double radius = widget.radius;
    final double thumbRadius = widget.thumbRadius;
    final double thumbCenterX =
        widget.radius + thumbDistanceToCenter * sin(thumbRadians);
    final double thumbCenterY =
        widget.radius + thumbDistanceToCenter * cos(thumbRadians);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (details) => handleTouchWheel(details.globalPosition, context),
      onPanStart: (details) =>
          handleTouchWheel(details.globalPosition, context),
      onPanUpdate: (details) =>
          handleTouchWheel(details.globalPosition, context),
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: (radius + thumbRadius) * 2,
            height: (radius + thumbRadius) * 2,
          ),
          Positioned(
            left: thumbRadius,
            top: thumbRadius,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: (radius * 2) + 2,
                    height: (radius * 2) + 2,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(radius + 2)),
                      gradient: SweepGradient(
                        colors: colors,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black45,
                          //spreadRadius: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                    gradient: SweepGradient(
                      colors: colors,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: thumbRadius,
            top: thumbRadius,
            child: Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  gradient: RadialGradient(colors: <Color>[
                    Colors.white,
                    Color(0x00ffffff),
                  ], stops: [
                    0.0,
                    1.0
                  ])),
            ),
          ),
          Positioned(
            left: thumbRadius,
            top: thumbRadius,
            child: Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                color: Color.fromARGB(((1 - rate) * 255).toInt(), 1, 1, 1),
              ),
            ),
          ),
          _thumb(thumbCenterX, thumbCenterY),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _barArea() {
    final thumbRadius = widget.thumbRadius;
    final thumbLeft = barWidth * rate - widget.thumbRadius < 0
        ? 0.0
        : barWidth * rate - widget.thumbRadius;
    final thumbTop = 0.0;

    Widget frame = Positioned(
      left: thumbRadius,
      top: (thumbRadius * 2 - barHeight) / 2,
      child: Container(
        width: barWidth,
        height: barHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(thumbRadius * 2)),
          color: baseColor,
        ),
      ),
    );

    Widget content = Positioned(
      left: thumbRadius,
      top: (thumbRadius * 2 - barHeight) / 2,
      child: Container(
        width: barWidth,
        height: barHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(thumbRadius * 2)),
          gradient: LinearGradient(colors: [Colors.black, Colors.transparent]),
        ),
      ),
    );

    return GestureDetector(
      onPanDown: (details) => handleTouchBar(details.globalPosition, context),
      onPanStart: (details) => handleTouchBar(details.globalPosition, context),
      onPanUpdate: (details) => handleTouchBar(details.globalPosition, context),
      child: SizedBox(
        width: barWidth + thumbRadius * 2,
        height: barHeight,
        child: Stack(
          children: [
            frame,
            content,
            _thumb(thumbLeft, thumbTop),
          ],
        ),
      ),
    );
  }

  void handleTouchWheel(Offset globalPosition, BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(globalPosition);
    final double centerX = box.size.width / 2;
    final double centerY = box.size.height / 2;
    final double deltaX = localPosition.dx - centerX;
    final double deltaY = localPosition.dy - centerY;
    final double distanceToCenter = sqrt(deltaX * deltaX + deltaY * deltaY);
    final double dist = distanceToCenter / widget.radius > 1
        ? 1
        : distanceToCenter / widget.radius;
    double theta = atan2(deltaX, deltaY);
    double degree = radiansToDegrees(theta) + 90;
    if (degree < 0) degree += 360;
    if (degree > 360) degree -= 360;
    baseColor = HSVColor.fromAHSV(1, degree, dist, 1).toColor();
    mixColor();

    setState(() {
      thumbDistanceToCenter =
          min(distanceToCenter, widget.radius - widget.thumbRadius);
      thumbRadians = theta;
    });
  }

  double radiansToDegrees(double radians) {
    return (radians + pi) / pi * 180;
  }

  double degreesToRadians(double degrees) {
    return degrees / 180 * pi - pi;
  }

  void handleTouchBar(Offset globalPosition, BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(globalPosition);
    double rate = (localPosition.dx - widget.thumbRadius) / barWidth;
    rate = min(max(0.0, rate), 1.0);
    setState(() {
      this.rate = rate;
    });
    mixColor();
  }

  void mixColor() {
    setState(() {
      mixedColor = HSVColor.fromColor(baseColor!).withValue(rate).toColor();
    });
    widget.colorListener!(mixedColor!);
  }
}

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key? key,
    this.blur = 10,
    this.color = Colors.black38,
    this.offset = const Offset(10, 10),
    required Widget child,
  }) : super(key: key, child: child);

  final double blur;
  final Color color;
  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _RenderInnerShadow renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  double blur = 0;
  Color color = Colors.white;
  double dx = 0;
  double dy = 0;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width - dx,
      size.height - dy,
    );
    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child as RenderObject, offset);
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx, dy);
    context.paintChild(child as RenderObject, offset);
    context.canvas
      ..restore()
      ..restore()
      ..restore();
  }
}
