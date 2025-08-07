import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceEntity {
  final String name;
  final LatLng position;
  final String description;
  final String type;
  final double? rating;
  final int? priceLevel;
  final bool? isOpen;
  final String? placeId;
  final List<dynamic>? photos;
  final List<String> types;
  final String? address;
  final String? phone;
  final String? website;
  final List<String>? openingHours;
  final bool? isOpenNow;

  const PlaceEntity({
    required this.name,
    required this.position,
    required this.description,
    required this.type,
    required this.types,
    this.rating,
    this.priceLevel,
    this.isOpen,
    this.placeId,
    this.photos,
    this.address,
    this.phone,
    this.website,
    this.openingHours,
    this.isOpenNow,
  });

  PlaceEntity copyWith({
    String? name,
    LatLng? position,
    String? description,
    String? type,
    double? rating,
    int? priceLevel,
    bool? isOpen,
    String? placeId,
    List<dynamic>? photos,
    List<String>? types,
    String? address,
    String? phone,
    String? website,
    List<String>? openingHours,
    bool? isOpenNow,
  }) {
    return PlaceEntity(
      name: name ?? this.name,
      position: position ?? this.position,
      description: description ?? this.description,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      priceLevel: priceLevel ?? this.priceLevel,
      isOpen: isOpen ?? this.isOpen,
      placeId: placeId ?? this.placeId,
      photos: photos ?? this.photos,
      types: types ?? this.types,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
      isOpenNow: isOpenNow ?? this.isOpenNow,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'position': position,
      'description': description,
      'type': type,
      'rating': rating,
      'priceLevel': priceLevel,
      'isOpen': isOpen,
      'placeId': placeId,
      'photos': photos,
      'types': types,
      'address': address,
      'phone': phone,
      'website': website,
      'openingHours': openingHours,
      'isOpenNow': isOpenNow,
    };
  }
}
