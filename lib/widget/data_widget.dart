import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeWidget extends StatelessWidget {
  final Color? titleColor;
  const DateTimeWidget({super.key, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5), // Smaller padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
             Colors.white.withOpacity(0.1),
             Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10), // Smaller radius
        border: Border.all(
          color:  Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule,
            color:  Colors.white,
            size: 12, // Smaller icon
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat('MMM d, yyyy').format(DateTime.now().toUtc().toLocal()),
            style: const TextStyle(
              color:  Colors.white,
              fontSize: 11, // Smaller font
              fontWeight: FontWeight.w600,
              fontFamily: "SF Pro Text",
            ),
          ),
        ],
      ),
    );
  }
}
