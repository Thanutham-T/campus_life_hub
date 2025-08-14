import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/entities/event_model.dart';
import '../data/repositories/event_repository_firestore.dart';

/// Campus Event DI - Dependency Injection for Campus Event Feature
/// ใช้เก็บ function ทั้งหมดของ Campus Event feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class CampusEventDI {
  static final EventRepository _eventRepository = EventRepository();

  /// Get all events from Firestore
  static Future<List<Event>> getAllEvents() async {
    return await _eventRepository.getAllEvents();
  }

  /// Get events by category from Firestore
  static Future<List<Event>> getEventsByCategory(EventCategory category) async {
    return await _eventRepository.getEventsByCategory(category);
  }

  /// Get events by status from Firestore
  static Future<List<Event>> getEventsByStatus(EventStatus status) async {
    return await _eventRepository.getEventsByStatus(status);
  }

  /// Get upcoming events from Firestore
  static Future<List<Event>> getUpcomingEvents() async {
    return await _eventRepository.getUpcomingEvents();
  }

  /// Add event to Firestore
  static Future<void> addEventToFirestore(String eventId, Map<String, dynamic> eventData) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .set(eventData);
  }

  /// Delete event from Firestore
  static Future<void> deleteEvent(String eventId) async {
    // ลบ event registrations ที่เกี่ยวข้องก่อน
    final registrations = await FirebaseFirestore.instance
        .collection('event_registrations')
        .where('eventId', isEqualTo: eventId)
        .get();
    
    // ลบ registrations ทั้งหมด
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in registrations.docs) {
      batch.delete(doc.reference);
    }
    
    // ลบ event
    batch.delete(FirebaseFirestore.instance.collection('events').doc(eventId));
    
    // Execute batch
    await batch.commit();
  }

  /// Update event in Firestore
  static Future<void> updateEvent(String eventId, Map<String, dynamic> eventData) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .update(eventData);
  }

  /// Get event by ID from Firestore
  static Future<Event?> getEventById(String id) async {
    return await _eventRepository.getEventById(id);
  }

  /// Search events from Firestore
  static Future<List<Event>> searchEvents(String query) async {
    return await _eventRepository.searchEvents(query);
  }

  /// Get academic events
  static Future<List<Event>> getAcademicEvents() async {
    return await getEventsByCategory(EventCategory.academic);
  }

  /// Get sports events
  static Future<List<Event>> getSportsEvents() async {
    return await getEventsByCategory(EventCategory.sports);
  }

  /// Get cultural events
  static Future<List<Event>> getCulturalEvents() async {
    return await getEventsByCategory(EventCategory.cultural);
  }

  /// Get competition events
  static Future<List<Event>> getCompetitionEvents() async {
    return await getEventsByCategory(EventCategory.competition);
  }

  /// Navigate to event detail page
  static void navigateToEventDetail(BuildContext context, String eventId) {
    context.go('/events/$eventId');
  }

  /// Navigate to events list page
  static void navigateToEventsList(BuildContext context) {
    context.go('/events');
  }

  /// Navigate to events by category
  static void navigateToEventsByCategory(BuildContext context, EventCategory category) {
    context.go('/events?category=${category.name}');
  }

  /// Get event status color
  static Color getEventStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return Colors.blue;
      case EventStatus.ongoing:
        return Colors.green;
      case EventStatus.completed:
        return Colors.grey;
      case EventStatus.cancelled:
        return Colors.red;
    }
  }

  /// Get event status text
  static String getEventStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return 'กำลังจะมาถึง';
      case EventStatus.ongoing:
        return 'กำลังดำเนินการ';
      case EventStatus.completed:
        return 'เสร็จสิ้นแล้ว';
      case EventStatus.cancelled:
        return 'ยกเลิก';
    }
  }

  /// Get event category icon
  static IconData getEventCategoryIcon(EventCategory category) {
    switch (category) {
      case EventCategory.academic:
        return Icons.school;
      case EventCategory.sports:
        return Icons.sports;
      case EventCategory.cultural:
        return Icons.theater_comedy;
      case EventCategory.competition:
        return Icons.emoji_events;
      case EventCategory.general:
        return Icons.event;
    }
  }

  /// Get event category color
  static Color getEventCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.academic:
        return Colors.blue;
      case EventCategory.sports:
        return Colors.green;
      case EventCategory.cultural:
        return Colors.purple;
      case EventCategory.competition:
        return Colors.orange;
      case EventCategory.general:
        return Colors.grey;
    }
  }

  /// Get event category text
  static String getEventCategoryText(EventCategory category) {
    switch (category) {
      case EventCategory.academic:
        return 'วิชาการ';
      case EventCategory.sports:
        return 'กีฬา';
      case EventCategory.cultural:
        return 'วัฒนธรรม';
      case EventCategory.competition:
        return 'การแข่งขัน';
      case EventCategory.general:
        return 'ทั่วไป';
    }
  }

  /// Format event date
  static String formatEventDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'วันนี้';
    } else if (difference == 1) {
      return 'พรุ่งนี้';
    } else if (difference == -1) {
      return 'เมื่อวาน';
    } else if (difference > 1) {
      return 'อีก $difference วัน';
    } else {
      return '${-difference} วันที่แล้ว';
    }
  }

  /// Check if event is today
  static bool isEventToday(Event event) {
    final now = DateTime.now();
    return event.date.year == now.year &&
           event.date.month == now.month &&
           event.date.day == now.day;
  }

  /// Check if event is upcoming
  static bool isEventUpcoming(Event event) {
    return event.date.isAfter(DateTime.now());
  }

  /// Filter events by search query (local filtering)
  static List<Event> searchEventsLocally(List<Event> events, String query) {
    return _eventRepository.searchEventsLocally(events, query);
  }

  /// Sort events by date
  static List<Event> sortEventsByDate(List<Event> events, {bool ascending = true}) {
    return _eventRepository.sortEventsByDate(events, ascending: ascending);
  }
}
