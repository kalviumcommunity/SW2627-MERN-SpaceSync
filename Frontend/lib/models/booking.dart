enum BookingStatus { active, confirmed, conflict, walkIn, pending, cancelled }

extension BookingStatusLabel on BookingStatus {
  String get label => switch (this) {
    BookingStatus.active => 'Active',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.conflict => 'Conflict',
    BookingStatus.walkIn => 'Walk-in',
    BookingStatus.pending => 'Pending',
    BookingStatus.cancelled => 'Cancelled',
  };
}

class Booking {
  const Booking({
    required this.name,
    required this.initials,
    required this.status,
    required this.workspace,
    required this.location,
    required this.date,
    required this.time,
  });

  final String name;
  final String initials;
  final BookingStatus status;
  final String workspace;
  final String location;
  final String date;
  final String time;
}
