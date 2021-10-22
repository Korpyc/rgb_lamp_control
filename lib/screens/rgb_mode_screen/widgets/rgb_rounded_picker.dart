import 'dart:developer' as developTools;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColorPickerView extends StatefulWidget {
  ColorPickerView({
    this.radius = 120,
    this.thumbRadius = 10,
    this.initialColor = const Color(0xffff0000),
    required this.colorListener,
  });

  final double radius;
  final double thumbRadius;
  final ValueChanged<Color>? colorListener;
  final Color initialColor;

  @override
  _ColorPickerViewState createState() => _ColorPickerViewState();
}

class _ColorPickerViewState extends State<ColorPickerView> {
  final GlobalKey _colorPickerKey = GlobalKey();
  static const List<Color> colors = [
    Color(0xffff0000),
    Color(0xffff00ff),
    Color(0xff0000ff),
    Color(0xff00ffff),
    Color(0xff00ff00),
    Color(0xffffff00),
    Color(0xffff0000)
  ];

  late Color mixedColor;

  late ValueNotifier<Offset> lastTapedPosition;
  late ValueNotifier<double> lastUngle;

  /* double thumbDistanceToCenter = 0;
  double thumbRadians = 0;
  double barWidth = 0;
  double barHeight = 0;

  Color? mixedColor;
  Color? baseColor;
  double rate = 0;

  
  double lastDist = 0.0;
 */

  @override
  void initState() {
    super.initState();
    lastTapedPosition =
        ValueNotifier<Offset>(Offset(widget.radius, widget.radius));
    lastUngle = ValueNotifier<double>(0);
    mixedColor = widget.initialColor;

/*     barWidth = widget.radius * 2;
    barHeight = widget.thumbRadius * 2;
    rate = HSVColor.fromColor(widget.initialColor).value; */

    /*   thumbRadians =
        degreesToRadians(HSVColor.fromColor(widget.initialColor).hue - 90);
    thumbDistanceToCenter = (widget.radius - widget.thumbRadius) *
        HSVColor.fromColor(widget.initialColor).saturation; */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF212327),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Text('$mixedColor'),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: lastUngle,
            builder: (context, value, child) => Align(
              alignment: Alignment(0, 0.9),
              child: Container(
                color: Colors.white,
                child: Text('${lastUngle.value}'),
              ),
            ),
          ),
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
          /*  Positioned(
            //alignment: Alignment(lastTapedPosition.dx, lastTapedPosition.dy),
            top: lastTapedPosition.dy,
            left: lastTapedPosition.dx,
            child: Container(
              height: 100,
              width: 100,
              color: Colors.white,
            ),
          ), */
          // will be used in future
          /* Align(alignment: Alignment(0, 0.7), child: _barArea()), */
        ],
      ),
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
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: mixedColor,
            borderRadius: BorderRadius.all(
              Radius.circular(widget.thumbRadius),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wheelArea() {
    final double radius = widget.radius;
    final double thumbRadius = widget.thumbRadius;
    /*   final double thumbCenterX =
        widget.radius + thumbDistanceToCenter * sin(thumbRadians);
    final double thumbCenterY =
        widget.radius + thumbDistanceToCenter * cos(thumbRadians); */

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (details) => handleTouchWheel(
        details.globalPosition,
        details.localPosition,
        context,
      ),
      onPanStart: (details) => handleTouchWheel(
        details.globalPosition,
        details.localPosition,
        context,
      ),
      onPanUpdate: (details) => handleTouchWheel(
        details.globalPosition,
        details.localPosition,
        context,
      ),
      onPanEnd: (details) {
        //handleTouchWheel(details.globalPosition, context);
        setState(
          () {
            widget.colorListener!(mixedColor);
          },
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          /* Opacity(
            opacity: 0.5,
            child: Container(
              width: (radius * 2) + 20,
              height: (radius * 2) + 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(radius + 20)),
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
          ), */
          Container(
            key: _colorPickerKey,
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              gradient: SweepGradient(
                colors: colors,
              ),
            ),
          ),
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              gradient: RadialGradient(
                colors: <Color>[
                  Colors.white,
                  Color(0x00ffffff),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          ValueListenableBuilder<Offset>(
            valueListenable: lastTapedPosition,
            builder: (context, value, child) {
              return _thumb(value.dx - thumbRadius, value.dy - thumbRadius);
            },
          ),
          /*  Positioned(
        left: thumbRadius,
        top: thumbRadius,
        child: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            color:
                Color.fromARGB(((1 /* - rate */) * 255).toInt(), 1, 1, 1),
          ),
        ),
      ), */
          /* _thumb(thumbCenterX, thumbCenterY), */
        ],
      ),
    );
  }

  /* Widget _barArea() {
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
      /* onPanEnd: (_) => setState(() {
        widget.colorListener!(mixedColor!);
      }), */
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
  } */

  void handleTouchWheel(
    Offset globalPosition,
    Offset localPosition,
    BuildContext context,
  ) {
    developTools.log('local : $localPosition');
    lastTapedPosition.value = localPosition;
    if (_colorPickerKey.currentContext != null) {
      RenderBox colorPickerBox =
          _colorPickerKey.currentContext!.findRenderObject() as RenderBox;
      var translation = colorPickerBox.getTransformTo(null).getTranslation();
      var rect = colorPickerBox.paintBounds
          .shift(Offset(translation.x, translation.y));

      /* RenderBox colorPickerWidgetBox = context.findRenderObject() as RenderBox;
      var translation1 =
          colorPickerWidgetBox.getTransformTo(null).getTranslation();
      var rect1 = colorPickerWidgetBox.paintBounds
          .shift(Offset(translation1.x, translation1.y)); */

      developTools.log('Position: ${rect.toString()}');

      double difX = widget.radius - localPosition.dx;
      double difY = widget.radius - localPosition.dy;
      difX = difX > 0 ? difX : -difX;
      difY = difY > 0 ? difY : -difY;
      double distanceFromCenter = sqrt(pow(difX, 2) + pow(difY, 2));
      final double dist = distanceFromCenter / widget.radius > 0.7
          ? 1
          : distanceFromCenter / widget.radius;
      developTools.log('Distance: ${dist.toString()}');

      double deltaX = widget.radius - localPosition.dx;
      double deltaY = widget.radius - localPosition.dy;
      double theta = atan2(deltaX, deltaY);
      double degree = radiansToDegrees(theta);
      lastUngle.value = degree;
      developTools.log('theta: ${degree.toString()}');
      /* double theta = atan2(deltaX, deltaY);
      double degree = radiansToDegrees(theta) + 90; */

      mixedColor = HSVColor.fromAHSV(1, degree, dist, 1).toColor();
      developTools.log('Color: $mixedColor');
      /* final double centerX = box.size.width / 2;
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
      if (degree > 360) degree -= 360; */

      /* baseColor = HSVColor.fromAHSV(1, degree, dist, 1).toColor(); */
      mixColor();

      setState(() {
        /*  thumbDistanceToCenter =
          min(distanceToCenter, widget.radius - widget.thumbRadius);
      thumbRadians = theta; */
      });
    }
  }

  double radiansToDegrees(double radians) {
    double angle = (radians + pi) / pi * 180;
    return angle >= 90 ? angle - 90 : angle + 270;
  }

  double degreesToRadians(double degrees) {
    if (degrees >= 0 && degrees <= 270) {
      return (degrees + 90) / 180 * pi - pi;
    }
    return (degrees - 270) / 180 * pi - pi;
  }

  /*  void handleTouchBar(Offset globalPosition, BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(globalPosition);
    double rate = (localPosition.dx - widget.thumbRadius) / barWidth;
    rate = min(max(0.0, rate), 1.0);
    setState(() {
      this.rate = rate;
    });
    mixColor();
  }
 */
  void mixColor() {
    setState(() {
      /* mixedColor = HSVColor.fromColor(baseColor!).withValue(rate).toColor(); */
    });
  }
}
