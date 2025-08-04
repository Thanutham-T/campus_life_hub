import '../../domain/entities/event_model.dart';

// Mock data repository for events
class EventRepository {
  // Simulated user joined events
  static final Set<String> _joinedEvents = {'2'};

  // Static event data - with local asset images
  static final List<Event> _allEvents = [
    Event(
      id: '1',
      title: 'เปิดรับสมัครประกวดดาว-เดือน',
      date: DateTime(2025, 7, 28),
      location: 'งานกิจกรรมนักศึกษา',
      description: 'ชมรมนักศึกษาขององค์การประกวดดาว-เดือน ภาคในวันที่ 28 ก.ค. ที่งานกิจกรรมนักศึกษา',
      category: EventCategory.competition,
      status: EventStatus.upcoming,
      imageUrl: 'assets/events/ประกวดดาวเดือน.jpg',
    ),
    Event(
      id: '2',
      title: 'ชมรมหนังสือ การอ่านเพื่อการพัฒนาตนเอง',
      date: DateTime(2025, 7, 30),
      location: 'ห้องสมุด',
      description: 'กิจกรรมการแบ่งปันและพูดคุยเกี่ยวกับหนังสือดีๆ ที่น่าสนใจ รวมถึงกิจกรรมการอ่าน',
      category: EventCategory.academic,
      status: EventStatus.ongoing,
      imageUrl: 'assets/events/การอ่านหนังสือ.jpg',
    ),
    Event(
      id: '3',
      title: 'งานวิ่งฟันรัน มหาวิทยาลัย',
      date: DateTime(2025, 8, 5),
      location: 'สนามกีฬามหาวิทยาลัย',
      description: 'กิจกรรมวิ่งเพื่อสุขภาพประจำปี เปิดให้นักศึกษาและบุคลากรเข้าร่วม',
      category: EventCategory.sports,
      status: EventStatus.upcoming,
      imageUrl: 'assets/events/งานวิ่งฟันรัน.jpg',
    ),
    Event(
      id: '4',
      title: 'ค่ำคืนหนังดี',
      date: DateTime(2025, 8, 12),
      location: 'โรงภาพยนตร์มหาวิทยาลัย',
      description: 'ชมภาพยนตร์คุณภาพพร้อมกิจกรรมสนทนาหลังการฉาย',
      category: EventCategory.cultural,
      status: EventStatus.upcoming,
      imageUrl: 'assets/events/ชมภาพยนตร์สนทนา.jpg',
    ),
    Event(
      id: '5',
      title: 'นิทรรศการศิลปะนักศึกษา',
      date: DateTime(2025, 8, 20),
      location: 'หอศิลป์มหาวิทยาลัย',
      description: 'แสดงผลงานศิลปะจากนักศึกษาคณะต่างๆ',
      category: EventCategory.cultural,
      status: EventStatus.upcoming,
      imageUrl: 'assets/events/นิทรรศการศิลปะ.jpg',
    ),
    Event(
      id: '6',
      title: 'อบรมเทคนิคการทำพอดแคสต์',
      date: DateTime(2025, 8, 25),
      location: 'ห้องปฏิบัติการสื่อ',
      description: 'เรียนรู้เทคนิคการสร้างเนื้อหาและผลิตพอดแคสต์',
      category: EventCategory.academic,
      status: EventStatus.upcoming,
      imageUrl: 'assets/events/พอดแคสต์.jpg',
    ),
    Event(
      id: '7',
      title: 'วันมหาวิทยาลัย',
      date: DateTime(2025, 9, 1),
      location: 'ลานกิจกรรมกลาง',
      description: 'งานฉลองวันสถาปนามหาวิทยาลัย พร้อมกิจกรรมมากมาย',
      category: EventCategory.general,
      status: EventStatus.upcoming,
      imageUrl: 'assets/events/วันสถาปนา.jpg',
    ),
  ];

  // Get all events
  static List<Event> getAllEvents() {
    return List.from(_allEvents);
  }

  // Get events by category
  static List<Event> getEventsByCategory(EventCategory category) {
    return _allEvents.where((event) => event.category == category).toList();
  }

  // Get events by status
  static List<Event> getEventsByStatus(EventStatus status) {
    return _allEvents.where((event) => event.status == status).toList();
  }

  // Get upcoming events
  static List<Event> getUpcomingEvents() {
    return getEventsByStatus(EventStatus.upcoming);
  }

  // Get ongoing events
  static List<Event> getOngoingEvents() {
    return getEventsByStatus(EventStatus.ongoing);
  }

  // Get events user has joined
  static List<Event> getJoinedEvents() {
    return _allEvents.where((event) => _joinedEvents.contains(event.id)).toList();
  }

  // Check if user joined an event
  static bool isUserJoined(String eventId) {
    return _joinedEvents.contains(eventId);
  }

  // Join an event
  static bool joinEvent(String eventId) {
    if (_allEvents.any((event) => event.id == eventId)) {
      _joinedEvents.add(eventId);
      return true;
    }
    return false;
  }

  // Leave an event
  static bool leaveEvent(String eventId) {
    return _joinedEvents.remove(eventId);
  }

  // Get event by ID
  static Event? getEventById(String eventId) {
    try {
      return _allEvents.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  // Search events
  static List<Event> searchEvents(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _allEvents.where((event) => 
      event.title.toLowerCase().contains(lowercaseQuery) ||
      event.description.toLowerCase().contains(lowercaseQuery) ||
      event.location.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  // Get popular events (mock implementation)
  static List<Event> getPopularEvents({int limit = 5}) {
    return _allEvents.take(limit).toList();
  }

  // Get recent events
  static List<Event> getRecentEvents({int limit = 10}) {
    final sortedEvents = List<Event>.from(_allEvents);
    sortedEvents.sort((a, b) => b.date.compareTo(a.date));
    return sortedEvents.take(limit).toList();
  }

  // Get events for today
  static List<Event> getTodayEvents() {
    final today = DateTime.now();
    return _allEvents.where((event) => 
      event.date.year == today.year &&
      event.date.month == today.month &&
      event.date.day == today.day
    ).toList();
  }

  // Get events for this week
  static List<Event> getThisWeekEvents() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    
    return _allEvents.where((event) => 
      event.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
      event.date.isBefore(endOfWeek.add(Duration(days: 1)))
    ).toList();
  }

  // Get events by category for dashboard display
  static List<Event> getDashboardEventsByCategory() {
    return [
      // Competition events
      ...getEventsByCategory(EventCategory.competition).take(1),
      // Academic events  
      ...getEventsByCategory(EventCategory.academic).take(1),
      // Sports events
      ...getEventsByCategory(EventCategory.sports).take(1),
    ];
  }
}
