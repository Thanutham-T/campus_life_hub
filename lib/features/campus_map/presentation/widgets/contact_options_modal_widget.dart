import 'package:flutter/material.dart';
import '../../domain/entities/place_entity.dart';

class ContactOptionsModalWidget extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onPhoneCall;

  const ContactOptionsModalWidget({
    super.key,
    required this.place,
    this.onPhoneCall,
  });

  void _showPhoneDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เบอร์โทรศัพท์'),
        content: Text(phoneNumber),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showWebsiteSnackBar(BuildContext context, String website) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Website: $website')),
    );
  }

  void _showAddressSnackBar(BuildContext context, String address) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ที่อยู่: $address')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ติดต่อ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Phone
              if (place.phone != null && place.phone!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: Text(
                    place.phone!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: const Text('เบอร์โทรศัพท์'),
                  onTap: () => _showPhoneDialog(context, place.phone!),
                ),
              
              // Website
              if (place.website != null && place.website!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.orange),
                  title: Text(
                    place.website!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: const Text('เว็บไซต์'),
                  onTap: () => _showWebsiteSnackBar(context, place.website!),
                ),
              
              // Address
              if (place.address != null && place.address!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  title: Text(
                    place.address!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  subtitle: const Text('ที่อยู่'),
                  onTap: () => _showAddressSnackBar(context, place.address!),
                ),
              
              // Show message if no contact info available
              if ((place.phone == null || place.phone!.isEmpty) &&
                  (place.website == null || place.website!.isEmpty) &&
                  (place.address == null || place.address!.isEmpty))
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'ไม่มีข้อมูลการติดต่อ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ปิด'),
                ),
              ),
              // Add padding for bottom insets
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, PlaceEntity place) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => ContactOptionsModalWidget(place: place),
    );
  }
}
