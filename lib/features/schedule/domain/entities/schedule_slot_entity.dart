class ScheduleSlotEntity {
  final String id;
  final String dayOfWeek;        // "Mon", "Tue", ...
  final String startTime;        // "HH:mm"
  final String endTime;          // "HH:mm"
  final String room;
  final String origin;           // "course" | "custom"
  final bool isActive;
  final bool isCustom;           // true if user modified default slot

  ScheduleSlotEntity({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.origin = "course",
    this.isActive = true,
    this.isCustom = false,
  });

  factory ScheduleSlotEntity.fromMap(Map<String, dynamic> map) {
    return ScheduleSlotEntity(
      id: map['id'] ?? '',
      dayOfWeek: map['dayOfWeek'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      room: map['room'] ?? '',
      origin: map['origin'] ?? 'course',
      isActive: map['isActive'] ?? true,
      isCustom: map['isCustom'] ?? false,
    );
  }
}
