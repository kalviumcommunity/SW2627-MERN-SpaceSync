import 'package:flutter/material.dart';

class SummaryMetric {
  const SummaryMetric({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
  });

  final String title;
  final String value;
  final String caption;
  final IconData icon;
}

class OccupancyData {
  const OccupancyData({
    required this.percentage,
    required this.occupied,
    required this.available,
    required this.deskUtilization,
    required this.roomUtilization,
  });

  final double percentage;
  final int occupied;
  final int available;
  final double deskUtilization;
  final double roomUtilization;
}

class PeakHour {
  const PeakHour({required this.label, required this.occupancy});

  final String label;
  final double occupancy;
}

enum LocationStatus { nearCapacity, available, highDemand }

class LocationData {
  const LocationData({
    required this.name,
    required this.occupied,
    required this.capacity,
    required this.status,
  });

  final String name;
  final int occupied;
  final int capacity;
  final LocationStatus status;

  double get utilization => occupied / capacity;
}

enum AlertSeverity { warning, highDemand, conflict }

class AlertData {
  const AlertData({
    required this.title,
    required this.description,
    required this.severity,
  });

  final String title;
  final String description;
  final AlertSeverity severity;
}

const summaryMetrics = <SummaryMetric>[
  SummaryMetric(
    title: 'Locations',
    value: '4',
    caption: 'Total locations',
    icon: Icons.apartment_rounded,
  ),
  SummaryMetric(
    title: 'Bookings',
    value: '128',
    caption: "Today's bookings",
    icon: Icons.calendar_month_rounded,
  ),
  SummaryMetric(
    title: 'Occupancy',
    value: '78%',
    caption: 'Current occupancy',
    icon: Icons.bar_chart_rounded,
  ),
  SummaryMetric(
    title: 'Available',
    value: '64',
    caption: 'Available desks',
    icon: Icons.desk_rounded,
  ),
];

const occupancyData = OccupancyData(
  percentage: 0.78,
  occupied: 238,
  available: 67,
  deskUtilization: 0.80,
  roomUtilization: 0.71,
);

const peakHours = <PeakHour>[
  PeakHour(label: '8 AM', occupancy: 35),
  PeakHour(label: '9 AM', occupancy: 55),
  PeakHour(label: '10 AM', occupancy: 68),
  PeakHour(label: '11 AM', occupancy: 82),
  PeakHour(label: '12 PM', occupancy: 90),
  PeakHour(label: '1 PM', occupancy: 85),
  PeakHour(label: '2 PM', occupancy: 78),
  PeakHour(label: '3 PM', occupancy: 88),
  PeakHour(label: '4 PM', occupancy: 80),
  PeakHour(label: '5 PM', occupancy: 65),
  PeakHour(label: '6 PM', occupancy: 45),
];

const locations = <LocationData>[
  LocationData(
    name: 'Bengaluru Central',
    occupied: 98,
    capacity: 120,
    status: LocationStatus.nearCapacity,
  ),
  LocationData(
    name: 'Koramangala',
    occupied: 64,
    capacity: 80,
    status: LocationStatus.available,
  ),
  LocationData(
    name: 'Indiranagar',
    occupied: 54,
    capacity: 60,
    status: LocationStatus.highDemand,
  ),
  LocationData(
    name: 'Whitefield',
    occupied: 22,
    capacity: 45,
    status: LocationStatus.available,
  ),
];

const activeAlerts = <AlertData>[
  AlertData(
    title: 'Bengaluru Central nearing capacity',
    description:
        'Occupancy is currently at 82%. Consider monitoring availability.',
    severity: AlertSeverity.warning,
  ),
  AlertData(
    title: 'High demand between 11 AM – 1 PM',
    description: 'Peak occupancy is expected during this period.',
    severity: AlertSeverity.highDemand,
  ),
  AlertData(
    title: 'Booking conflict detected',
    description: 'One or more workspace bookings require attention.',
    severity: AlertSeverity.conflict,
  ),
];
