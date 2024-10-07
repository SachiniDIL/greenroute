import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<TableRow> rows;

  const CustomTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(80),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(100),
      },
      children: rows,
    );
  }
}
