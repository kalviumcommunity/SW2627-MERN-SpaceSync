class OccupancyPoint {
  const OccupancyPoint(this.month, this.percentage);

  final String month;
  final int percentage;
}

class ExpansionCandidate {
  const ExpansionCandidate({
    required this.location,
    required this.recommendation,
    required this.occupancy,
    required this.priority,
  });

  final String location;
  final String recommendation;
  final int occupancy;
  final String priority;
}

const occupancyTrend = <OccupancyPoint>[
  OccupancyPoint('Jan', 54),
  OccupancyPoint('Feb', 58),
  OccupancyPoint('Mar', 62),
  OccupancyPoint('Apr', 67),
  OccupancyPoint('May', 71),
  OccupancyPoint('Jun', 73),
  OccupancyPoint('Jul', 76),
  OccupancyPoint('Aug', 78),
  OccupancyPoint('Sep', 80),
];

const expansionCandidates = <ExpansionCandidate>[
  ExpansionCandidate(
    location: 'Bengaluru Central',
    recommendation: 'Add 30 desks + 2 rooms',
    occupancy: 82,
    priority: 'High',
  ),
  ExpansionCandidate(
    location: 'Indiranagar',
    recommendation: 'Add 15 desks',
    occupancy: 78,
    priority: 'Medium',
  ),
];
