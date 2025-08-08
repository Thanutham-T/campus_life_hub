import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MapControlButtonsWidget extends StatelessWidget {
  final VoidCallback onCompassPressed;
  final VoidCallback onLocationPressed;

  const MapControlButtonsWidget({
    super.key,
    required this.onCompassPressed,
    required this.onLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Compass button
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.navigation, color: Colors.black54),
            onPressed: onCompassPressed,
          ),
        ),
        
        // Current location button
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: onLocationPressed,
          ),
        ),
      ],
    );
  }
}
