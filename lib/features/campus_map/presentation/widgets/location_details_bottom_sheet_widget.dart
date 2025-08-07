import 'package:flutter/material.dart';
import '../../domain/entities/place_entity.dart';
import '../../../../core/constants/app_colors.dart';

class LocationDetailsBottomSheetWidget extends StatelessWidget {
  final PlaceEntity place;
  final String placeName;
  final bool isNavigationMode;
  final double? drivingTime;
  final double? walkingTime;
  final VoidCallback onClose;
  final VoidCallback onNavigate;
  final VoidCallback onViewLocation;
  final VoidCallback onShowContact;

  const LocationDetailsBottomSheetWidget({
    super.key,
    required this.place,
    required this.placeName,
    required this.isNavigationMode,
    this.drivingTime,
    this.walkingTime,
    required this.onClose,
    required this.onNavigate,
    required this.onViewLocation,
    required this.onShowContact,
  });

  String _getOperatingStatus() {
    if (place.isOpenNow != null) {
      return place.isOpenNow! ? 'เปิดบริการ' : 'ปิดบริการ';
    }
    return 'ไม่มีข้อมูลเวลาทำการ';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation mode (compact view)
              if (isNavigationMode) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        placeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Travel times
                        if (drivingTime != null || walkingTime != null) ...[
                          if (drivingTime != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.directions_car, size: 16, color: Colors.blue),
                                const SizedBox(width: 2),
                                Text('${drivingTime!.round()} นาที', 
                                     style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          const SizedBox(width: 8),
                          if (walkingTime != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.directions_walk, size: 16, color: Colors.green),
                                const SizedBox(width: 2),
                                Text('${walkingTime!.round()} นาที', 
                                     style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          const SizedBox(width: 8),
                        ],
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                // Full view (normal mode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        placeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ],
                ),
                
                // Description
                Text(
                  place.description,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                
                // Travel times
                if (drivingTime != null || walkingTime != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Wrap(
                      spacing: 16,
                      children: [
                        if (drivingTime != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_car, size: 20, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('${drivingTime!.round()} นาที'),
                            ],
                          ),
                        if (walkingTime != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_walk, size: 20, color: Colors.green),
                              const SizedBox(width: 4),
                              Text('${walkingTime!.round()} นาที'),
                            ],
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                
                // Rating
                if (place.rating != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text('${place.rating} ดาว'),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                
                // Operating status and hours
                if (place.openingHours != null || place.isOpenNow != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      if (place.openingHours != null && place.openingHours!.isNotEmpty)
                        Flexible(
                          child: Text(
                            place.openingHours!.first,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      else
                        const Flexible(
                          child: Text(
                            'ไม่มีข้อมูล',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        '(${_getOperatingStatus()})',
                        style: TextStyle(
                          color: _getOperatingStatus() == 'เปิดบริการ' 
                              ? Colors.green 
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onNavigate,
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text(
                          'นำทาง',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onViewLocation,
                        icon: const Icon(Icons.zoom_in, size: 18),
                        label: const Text(
                          'ดูตำแหน่ง',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onShowContact,
                      icon: const Icon(Icons.contact_phone, color: Colors.green),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
