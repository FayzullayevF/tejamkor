import 'package:flutter/material.dart';

class BudgetRow extends StatelessWidget {
  const BudgetRow({super.key, required this.title, required this.buttonTitle, required this.callback});
  final String title;
  final String buttonTitle;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xff171C1D),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: callback,
          child: Text(
            buttonTitle,
            style: TextStyle(
              color: Color(0xff006673),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
