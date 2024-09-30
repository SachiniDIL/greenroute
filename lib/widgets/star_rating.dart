import 'package:flutter/material.dart';
import '../theme.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  const StarRating({required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: AppColors.primaryColor,
            size: 40,
          ),
          onPressed: () {
            onRatingChanged(index + 1);
          },
        );
      }),
    );
  }
}
