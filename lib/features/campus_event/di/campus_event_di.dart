import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/event_model.dart';
import '../data/repositories/event_repository.dart';

/// Campus Event DI - Dependency Injection for Campus Event Feature
/// ใช้เก็บ function ทั้งหมดของ Campus Event feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class CampusEventDI {

  /// Get all events
  static List<Event> getAllEvents() {
    return EventRepository.getAllEvents();
  }

  /// Get events by category
  static List<Event> getEventsByCategory(EventCategory category) {
    return EventRepository.getEventsByCategory(category);
  }

  /// Get events by status
  static List<Event> getEventsByStatus(EventStatus status) {
    return EventRepository.getEventsByStatus(status);
  }

  /// Get upcoming events
  static List<Event> getUpcomingEvents() {
    return EventRepository.getUpcomingEvents();
  }

  /// Get event by ID
  static Event? getEventById(String id) {
    return EventRepository.getEventById(id);
  }

  /// Get academic events
  static List<Event> getAcademicEvents() {
    return getEventsByCategory(EventCategory.academic);
  }

  /// Get sports events
  static List<Event> getSportsEvents() {
    return getEventsByCategory(EventCategory.sports);
  }

  /// Get cultural events
  static List<Event> getCulturalEvents() {
    return getEventsByCategory(EventCategory.cultural);
  }

  /// Get competition events
  static List<Event> getCompetitionEvents() {
    return getEventsByCategory(EventCategory.competition);
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

  /// Filter events by search query
  static List<Event> searchEvents(List<Event> events, String query) {
    if (query.isEmpty) return events;
    
    return events.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()) ||
             event.description.toLowerCase().contains(query.toLowerCase()) ||
             event.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Sort events by date
  static List<Event> sortEventsByDate(List<Event> events, {bool ascending = true}) {
    final sortedEvents = List<Event>.from(events);
    sortedEvents.sort((a, b) => ascending 
        ? a.date.compareTo(b.date) 
        : b.date.compareTo(a.date));
    return sortedEvents;
  }
}
