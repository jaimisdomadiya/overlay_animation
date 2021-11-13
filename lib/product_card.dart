import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'Product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  final Product product;

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.all(
            Radius.circular(defaultPadding * 1.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: product.title!,
              child: Image.asset(product.image!),
            ),
            Text(
              product.title!,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              "Fruits",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductAnimation extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final Color color;
  final double opacity;
  final double height;
  final double width;
  final double dxCurveAnimation;
  final double dyCurveAnimation;
  final String? image;
  final String? text;

  const ProductAnimation(
      {Key? key,
      required this.startPosition,
      required this.endPosition,
      this.color = Colors.red,
      this.height = 14,
      this.width = 14,
      this.opacity = 1.0,
      this.dxCurveAnimation = 100,
      this.dyCurveAnimation = 100,
      this.image,
      this.text})
      : super(key: key);

  @override
  _ProductAnimationState createState() => _ProductAnimationState();
}

class _ProductAnimationState extends State<ProductAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Animation controller
  late Animation<double> _animation; // animation
  late double left; // The left of the small dot (dynamic calculation)
  late double top; // Small far point right (dynamic calculation)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1300), vsync: this);
    _animation = Tween(begin: 0.25, end: 1.1).animate(_controller);

    var x0 = widget.startPosition.dx;
    var y0 = widget.startPosition.dy;

    var x1 = x0 - widget.dxCurveAnimation;
    var y1 = y0 - widget.dyCurveAnimation;

    var x2 = widget.endPosition.dx;
    var y2 = widget.endPosition.dy;

    _animation.addListener(() {
// Value for second-order Bezier curve
      var t = _animation.value;
      if (mounted) {
        setState(() {
          left = pow(1 - t, 2) * x0 + 2 * t * (1 - t) * x1 + pow(t, 2) * x2;
          top = pow(1 - t, 2) * y0 + 2 * t * (1 - t) * y1 + pow(t, 2) * y2;
        });
      }
    });

    // Initialize the position of the widget
    left = widget.startPosition.dx;
    top = widget.startPosition.dy;
    print("left ==> $left top ==> $top");

    // The animation starts when the widget is displayed
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: left,
              top: top,
              child: Opacity(
                opacity: 0.7,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(defaultPadding * 1.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(widget.image!,
                          height: (1 - _animation.value) * 220,
                          width: (1 - _animation.value) * 220),
                      Text(
                        widget.text!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: (1 - _animation.value) * 18),
                      ),
                      Text(
                        "Fruits",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: (1 - _animation.value) * 15),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
