import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';

import '../../theme.dart';

class Support extends StatelessWidget{
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
              // Fixed Back Arrow (Non-scrollable)
              BackArrow(),
            ]
        )
    );
  }
}