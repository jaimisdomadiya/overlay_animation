import 'package:easy_animation/product_card.dart';
import 'package:flutter/material.dart';

import 'Product.dart';

class EasyCartAnimationExamplePage extends StatefulWidget {
  @override
  _EasyCartAnimationExamplePageState createState() =>
      _EasyCartAnimationExamplePageState();
}

class _EasyCartAnimationExamplePageState
    extends State<EasyCartAnimationExamplePage> {
  GlobalKey _key = GlobalKey();
  late Offset _endOffset;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((c) {
      // Get the location of the "shopping cart"
      _endOffset = (_key.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);

      print('_endOffset dx => ${_endOffset.dx} dy => ${_endOffset.dy}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Animation Cart',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white54,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              primary: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 15, bottom: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2 / 2.3,
                  crossAxisCount: 2,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 8),
              itemCount: demo_products.length,
              itemBuilder: (context, index) {
                return Builder(
                  builder: (BuildContext context) {
                    return ProductCard(
                      product: demo_products[index],
                      press: () {
                        OverlayEntry? _overlayEntry =
                            OverlayEntry(builder: (_) {
                          final box = context.findRenderObject() as RenderBox;
                          var offset = box.localToGlobal(Offset.zero);
                          return ProductAnimation(
                            startPosition: offset,
                            endPosition: _endOffset,
                            dxCurveAnimation: index % 2 == 0 ? -200 : 200,
                            dyCurveAnimation: 70,
                            opacity: 0.5,
                            image: demo_products[index].image,
                            text: demo_products[index].title,
                          );
                        });
                        Overlay.of(context)?.insert(_overlayEntry);
                        Future.delayed(const Duration(milliseconds: 1300), () {
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Icon(
                  Icons.home_outlined,
                ),
                const Icon(
                  Icons.search,
                ),
                Icon(
                  Icons.shopping_cart,
                  key: _key,
                ),
                const Icon(
                  Icons.perm_identity_rounded,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
