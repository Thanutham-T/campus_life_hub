import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/place_entity.dart';
import '../../data/services/map_utils.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<PlaceEntity> searchResults;
  final bool showSearchResults;
  final Function(PlaceEntity) onLocationSelected;

  const SearchResultsWidget({
    super.key,
    required this.searchResults,
    required this.showSearchResults,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!showSearchResults || searchResults.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(
        maxHeight: 300, // Limit height to prevent overflow
      ),
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
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: searchResults.length > 8 ? 8 : searchResults.length, // Limit to 8 results
        itemBuilder: (context, index) {
          final place = searchResults[index];
          return ListTile(
            leading: Icon(
              MapUtils.getLocationIcon(place.type),
              color: AppColors.primary,
            ),
            title: Text(
              place.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              place.description,
              style: TextStyle(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            onTap: () => onLocationSelected(place),
          );
        },
      ),
    );
  }
}
