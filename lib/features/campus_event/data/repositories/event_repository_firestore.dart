import '../datasources/event_firestore_data_source.dart';
import '../../domain/entities/event_model.dart';

class EventRepository {
  final EventFirestoreDataSource _firestoreDataSource;

  EventRepository({
    EventFirestoreDataSource? firestoreDataSource,
  }) : _firestoreDataSource = firestoreDataSource ?? EventFirestoreDataSourceImpl();

  // Get all events
  Future<List<Event>> getAllEvents() async {
    try {
      return await _firestoreDataSource.getAllEvents();
    } catch (e) {
      print('EventRepository: Error getting all events: $e');
      return [];
    }
  }

  // Get events by category
  Future<List<Event>> getEventsByCategory(EventCategory category) async {
    try {
      return await _firestoreDataSource.getEventsByCategory(category);
    } catch (e) {
      print('EventRepository: Error getting events by category: $e');
      return [];
    }
  }

  // Get events by status
  Future<List<Event>> getEventsByStatus(EventStatus status) async {
    try {
      return await _firestoreDataSource.getEventsByStatus(status);
    } catch (e) {
      print('EventRepository: Error getting events by status: $e');
      return [];
    }
  }

  // Get upcoming events
  Future<List<Event>> getUpcomingEvents() async {
    try {
      final firestoreImpl = _firestoreDataSource as EventFirestoreDataSourceImpl;
      return await firestoreImpl.getUpcomingEvents();
    } catch (e) {
      print('EventRepository: Error getting upcoming events: $e');
      return [];
    }
  }

  // Get event by ID
  Future<Event?> getEventById(String id) async {
    try {
      return await _firestoreDataSource.getEventById(id);
    } catch (e) {
      print('EventRepository: Error getting event by ID: $e');
      return null;
    }
  }

  // Search events
  Future<List<Event>> searchEvents(String query) async {
    try {
      final firestoreImpl = _firestoreDataSource as EventFirestoreDataSourceImpl;
      return await firestoreImpl.searchEvents(query);
    } catch (e) {
      print('EventRepository: Error searching events: $e');
      return [];
    }
  }

  // Add event (for admin functionality)
  Future<void> addEvent(Event event) async {
    try {
      await _firestoreDataSource.addEvent(event);
    } catch (e) {
      print('EventRepository: Error adding event: $e');
      rethrow;
    }
  }

  // Update event (for admin functionality)
  Future<void> updateEvent(Event event) async {
    try {
      await _firestoreDataSource.updateEvent(event);
    } catch (e) {
      print('EventRepository: Error updating event: $e');
      rethrow;
    }
  }

  // Delete event (for admin functionality)
  Future<void> deleteEvent(String id) async {
    try {
      await _firestoreDataSource.deleteEvent(id);
    } catch (e) {
      print('EventRepository: Error deleting event: $e');
      rethrow;
    }
  }

  // Filter and sort utilities
  List<Event> sortEventsByDate(List<Event> events, {bool ascending = true}) {
    final sortedEvents = List<Event>.from(events);
    sortedEvents.sort((a, b) => ascending 
        ? a.date.compareTo(b.date) 
        : b.date.compareTo(a.date));
    return sortedEvents;
  }

  List<Event> filterEventsByDateRange(List<Event> events, DateTime start, DateTime end) {
    return events.where((event) => 
        event.date.isAfter(start) && event.date.isBefore(end)).toList();
  }

  List<Event> searchEventsLocally(List<Event> events, String query) {
    if (query.isEmpty) return events;
    
    return events.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()) ||
             event.description.toLowerCase().contains(query.toLowerCase()) ||
             event.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
