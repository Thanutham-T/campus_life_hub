import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class CourseCard extends StatefulWidget {
  final String courseCode;
  final String courseName;
  final String courseSection;
  final List<Schedule> schedules;
  final bool isEnrolled;
  final VoidCallback? onEnrol;
  final VoidCallback? onWithdrawn;

  const CourseCard({
    Key? key,
    required this.courseCode,
    required this.courseName,
    required this.courseSection,
    required this.schedules,
    required this.isEnrolled,
    this.onEnrol,
    this.onWithdrawn,
  }) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class Schedule {
  final String day;
  final String time;
  final String instructor;
  final String? room;

  Schedule({
    required this.day,
    required this.time,
    required this.instructor,
    required this.room,
  });
}

class _CourseCardState extends State<CourseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.courseCode + widget.courseSection),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (widget.isEnrolled) {
                widget.onWithdrawn?.call();
              } else {
                widget.onEnrol?.call();
              }
            },
            backgroundColor: widget.isEnrolled ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            icon: widget.isEnrolled ? Icons.logout : Icons.login,
            label: widget.isEnrolled ? 'Withdrawn' : 'Enrol',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: widget.isEnrolled ? Colors.yellow[100] : null,
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.courseCode,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      ' - ${widget.courseName}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Section: ${widget.courseSection}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: widget.schedules.map((schedule) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${schedule.day} ${schedule.time}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            schedule.room ?? 'N/A',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          Text(
                            schedule.instructor,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}