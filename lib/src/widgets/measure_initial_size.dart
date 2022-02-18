import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnSizeFound = void Function(Size size);

/// measures the size of a child
class MeasureInitialSizeRenderObject extends RenderProxyBox {
  final OnSizeFound onSizeFound;
  bool isInitialLayout = true;

  MeasureInitialSizeRenderObject(this.onSizeFound);

  @override
  void performLayout() {
    super.performLayout();
    if (isInitialLayout) {
      isInitialLayout = false;
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        onSizeFound(child?.size ?? const Size(0, 0));
      });
    }
  }
}

class MeasureInitialSize extends SingleChildRenderObjectWidget {
  final OnSizeFound onSizeFound;

  const MeasureInitialSize({
    Key? key,
    required this.onSizeFound,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureInitialSizeRenderObject(onSizeFound);
  }
}
