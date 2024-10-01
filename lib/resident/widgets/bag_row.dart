import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BagRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int bagCount;
  final Function(int) onCountChanged;

  const BagRow({
    super.key,
    required this.label,
    required this.controller,
    required this.bagCount,
    required this.onCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x445CAE54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.delete_sharp,
                    size: 50,
                    color: label == 'Plastic'
                        ? const Color.fromRGBO(12, 147, 0, 1)
                        : (label == 'Paper'
                        ? const Color.fromRGBO(147, 0, 0, 1)
                        : const Color.fromRGBO(0, 32, 147, 1)),
                  ),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 70),
            IconButton(
              onPressed: () {
                if (bagCount > 0) {
                  onCountChanged(bagCount - 1); // Prevent negative values
                }
              },
              icon: const Icon(
                Icons.remove_rounded,
                size: 35.0,
                weight: 700,
              ),
            ),
            Container(
              width: 60,
              height: 41,
              alignment: Alignment.center,
              child: TextFormField(
                controller: controller,
                maxLength: 2,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  int? newValue = int.tryParse(value);
                  if (newValue != null && newValue >= 0) {
                    onCountChanged(newValue); // Only accept valid non-negative numbers
                  } else {
                    controller.text = bagCount.toString(); // Revert invalid input
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () => onCountChanged(bagCount + 1),
              icon: const Icon(
                Icons.add_rounded,
                size: 35.0,
                weight: 700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
