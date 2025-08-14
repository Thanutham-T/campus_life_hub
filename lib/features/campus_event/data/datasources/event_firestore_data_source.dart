import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event_model.dart';

abstract class EventFirestoreDataSource {
  Future<List<Event>> getAllEvents();
  Future<List<Event>> getEventsByCategory(EventCategory category);
  Future<List<Event>> getEventsByStatus(EventStatus status);
  Future<Event?> getEventById(String id);
  Future<void> addEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);
}

class EventFirestoreDataSourceImpl implements EventFirestoreDataSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'events';

  EventFirestoreDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Event>> getAllEvents() async {
    try {
      print('🔍 EventFirestore: Getting all events');
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('date', descending: false)
          .get();

      final events = querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc.data(), doc.id))
          .toList();

      print('✅ EventFirestore: Retrieved ${events.length} events');
      return events;
    } catch (e) {
      print('❌ EventFirestore: Error getting all events: $e');
      return [];
    }
  }

  @override
  Future<List<Event>> getEventsByCategory(EventCategory category) async {
    try {
      print('🔍 EventFirestore: Getting events by category: ${category.name}');
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category.name)
          .orderBy('date', descending: false)
          .get();

      final events = querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc.data(), doc.id))
          .toList();

      print('✅ EventFirestore: Retrieved ${events.length} events for category ${category.name}');
      return events;
    } catch (e) {
      print('❌ EventFirestore: Error getting events by category: $e');
      return [];
    }
  }

  @override
  Future<List<Event>> getEventsByStatus(EventStatus status) async {
    try {
      print('🔍 EventFirestore: Getting events by status: ${status.name}');
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status.name)
          .orderBy('date', descending: false)
          .get();

      final events = querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc.data(), doc.id))
          .toList();

      print('✅ EventFirestore: Retrieved ${events.length} events for status ${status.name}');
      return events;
    } catch (e) {
      print('❌ EventFirestore: Error getting events by status: $e');
      return [];
    }
  }

  @override
  Future<Event?> getEventById(String id) async {
    try {
      print('🔍 EventFirestore: Getting event by ID: $id');
      
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        print('❌ EventFirestore: Event not found: $id');
        return null;
      }

      final event = Event.fromFirestore(docSnapshot.data()!, docSnapshot.id);
      print('✅ EventFirestore: Retrieved event: ${event.title}');
      return event;
    } catch (e) {
      print('❌ EventFirestore: Error getting event by ID: $e');
      return null;
    }
  }

  @override
  Future<void> addEvent(Event event) async {
    try {
      print('💾 EventFirestore: Adding event: ${event.title}');
      
      await _firestore
          .collection(_collection)
          .add(event.toFirestore());

      print('✅ EventFirestore: Event added successfully');
    } catch (e) {
      print('❌ EventFirestore: Error adding event: $e');
      throw Exception('Failed to add event: $e');
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    try {
      print('🔄 EventFirestore: Updating event: ${event.title}');
      
      await _firestore
          .collection(_collection)
          .doc(event.id)
          .update(event.toFirestore());

      print('✅ EventFirestore: Event updated successfully');
    } catch (e) {
      print('❌ EventFirestore: Error updating event: $e');
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      print('🗑️ EventFirestore: Deleting event: $id');
      
      await _firestore
          .collection(_collection)
          .doc(id)
          .delete();

      print('✅ EventFirestore: Event deleted successfully');
    } catch (e) {
      print('❌ EventFirestore: Error deleting event: $e');
      throw Exception('Failed to delete event: $e');
    }
  }

  // Additional helper methods
  
  Future<List<Event>> getUpcomingEvents() async {
    try {
      print('🔍 EventFirestore: Getting upcoming events');
      
      final now = DateTime.now();
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: now.toIso8601String())
          .orderBy('date', descending: false)
          .get();

      final events = querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc.data(), doc.id))
          .toList();

      print('✅ EventFirestore: Retrieved ${events.length} upcoming events');
      return events;
    } catch (e) {
      print('❌ EventFirestore: Error getting upcoming events: $e');
      return [];
    }
  }

  Future<List<Event>> searchEvents(String query) async {
    try {
      print('🔍 EventFirestore: Searching events with query: $query');
      
      // Note: Firestore doesn't support full-text search natively
      // This is a basic implementation - for better search, consider using Algolia or similar
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('title')
          .get();

      final events = querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc.data(), doc.id))
          .where((event) =>
              event.title.toLowerCase().contains(query.toLowerCase()) ||
              event.description.toLowerCase().contains(query.toLowerCase()) ||
              event.location.toLowerCase().contains(query.toLowerCase()))
          .toList();

      print('✅ EventFirestore: Found ${events.length} events matching query');
      return events;
    } catch (e) {
      print('❌ EventFirestore: Error searching events: $e');
      return [];
    }
  }
}
