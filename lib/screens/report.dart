import 'package:flutter/material.dart';
import 'package:greenroute/widgets/back_arrow.dart';

import '../theme.dart';

class Report extends StatelessWidget{
  const Report({super.key});

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