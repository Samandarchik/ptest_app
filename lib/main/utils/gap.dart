import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

extension SizedExtension on num {
  // Column and Row spacing
  Gap get gap => Gap(toDouble());
}

extension EdgeInsetsExtension on num {
  // Padding
  EdgeInsets get pall => EdgeInsets.all(toDouble());
}

extension TextExtension on String {
  Text text({
    Key? key,
    TextStyle? style,
  }) {
    return Text(
      this,
      key: key,
      style: style,
    );
  }
}
