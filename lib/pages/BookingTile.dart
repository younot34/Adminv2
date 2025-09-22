import 'dart:async';
import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingTile extends StatefulWidget {
  final Booking booking;
  BookingTile({required this.booking});

  @override
  State<BookingTile> createState() => _BookingTileState();
}

class _BookingTileState extends State<BookingTile> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }
  DateTime? parseBookingDate(String dateStr) {
    try {
      if (dateStr.contains("T")) {
        return DateTime.parse(dateStr).toLocal();
      }

      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
        return DateTime.parse(dateStr).toLocal();
      }

      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }

      return null;
    } catch (e) {
      debugPrint("ERROR parseBookingDate: $dateStr ($e)");
      return null;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final bookingDate = parseBookingDate(widget.booking.date);
    if (bookingDate == null) {
      return ListTile(
        title: Text("Invalid date: ${widget.booking.date}"),
      );
    }

    final startTimeParts = widget.booking.time.split(":");
    final startHour = int.parse(startTimeParts[0]);
    final startMinute = int.parse(startTimeParts[1]);
    final startTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      startHour,
      startMinute,
    );

    final durationMinutes = int.tryParse(widget.booking.duration ?? "0") ?? 0;
    final endTime = startTime.add(Duration(minutes: durationMinutes));

    final isOngoing = now.isAfter(startTime) && now.isBefore(endTime);
    final isFinished = now.isAfter(endTime);

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event_note, color: Color(0xFF5C6BC0)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.booking.meetingTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isFinished ? Colors.grey.shade300 :isOngoing ? Colors.red.shade100 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isFinished
                  ? "Finished"
                  : isOngoing
                  ? "Ongoing"
                  : "In Queue",
              style: TextStyle(
                color: isFinished
                    ? Colors.grey.shade700
                    : isOngoing
                    ? Colors.red
                    : Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        "${widget.booking.time} • ${widget.booking.hostName}",
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}