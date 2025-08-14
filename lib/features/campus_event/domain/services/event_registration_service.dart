import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventRegistration {
  final String id;
  final String userId;
  final String eventId;
  final DateTime registeredAt;
  final String? notes;

  EventRegistration({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.registeredAt,
    this.notes,
  });

  factory EventRegistration.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventRegistration(
      id: doc.id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      registeredAt: (data['registeredAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'eventId': eventId,
      'registeredAt': Timestamp.fromDate(registeredAt),
      'notes': notes,
    };
  }
}

class EventRegistrationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register for an event
  static Future<bool> registerForEvent({
    required String eventId,
    String? notes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Check if already registered
      final existingRegistration = await _firestore
          .collection('event_registrations')
          .where('userId', isEqualTo: user.uid)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (existingRegistration.docs.isNotEmpty) {
        print('User already registered for this event');
        return false;
      }

      // Create registration
      final registration = EventRegistration(
        id: '', // Firestore will generate
        userId: user.uid,
        eventId: eventId,
        registeredAt: DateTime.now(),
        notes: notes,
      );

      await _firestore
          .collection('event_registrations')
          .add(registration.toFirestore());

      return true;
    } catch (e) {
      print('Error registering for event: $e');
      return false;
    }
  }

  // Cancel registration
  static Future<bool> cancelRegistration(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final registrations = await _firestore
          .collection('event_registrations')
          .where('userId', isEqualTo: user.uid)
          .where('eventId', isEqualTo: eventId)
          .get();

      for (final doc in registrations.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      print('Error canceling registration: $e');
      return false;
    }
  }

  // Check if user is registered for an event
  static Future<bool> isUserRegistered(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final registrations = await _firestore
          .collection('event_registrations')
          .where('userId', isEqualTo: user.uid)
          .where('eventId', isEqualTo: eventId)
          .get();

      return registrations.docs.isNotEmpty;
    } catch (e) {
      print('Error checking registration: $e');
      return false;
    }
  }

  // Get user's registered events
  static Future<List<EventRegistration>> getUserRegistrations() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('event_registrations')
          .where('userId', isEqualTo: user.uid)
          .get(); // Remove orderBy temporarily until index is created

      final registrations = snapshot.docs
          .map((doc) => EventRegistration.fromFirestore(doc))
          .toList();
      
      // Sort manually by registeredAt (descending)
      registrations.sort((a, b) => b.registeredAt.compareTo(a.registeredAt));

      return registrations;
    } catch (e) {
      print('Error getting user registrations: $e');
      return [];
    }
  }

  // Get registrations for an event (admin only)
  static Future<List<EventRegistration>> getEventRegistrations(String eventId) async {
    try {
      print('EventRegistrationService: Getting registrations for eventId: $eventId');
      
      final snapshot = await _firestore
          .collection('event_registrations')
          .where('eventId', isEqualTo: eventId)
          .get(); // Remove orderBy temporarily until index is created

      print('EventRegistrationService: Found ${snapshot.size} registrations');
      
      final registrations = snapshot.docs
          .map((doc) => EventRegistration.fromFirestore(doc))
          .toList();
      
      // Sort manually by registeredAt (descending)
      registrations.sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
      
      return registrations;
    } catch (e) {
      print('Error getting event registrations: $e');
      return [];
    }
  }

  // Get registration count for an event
  static Future<int> getRegistrationCount(String eventId) async {
    try {
      final snapshot = await _firestore
          .collection('event_registrations')
          .where('eventId', isEqualTo: eventId)
          .get();

      return snapshot.size;
    } catch (e) {
      print('Error getting registration count: $e');
      return 0;
    }
  }
}
