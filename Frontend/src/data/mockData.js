export const stats = [
  { label: 'Total Locations', value: '4', tone: 'primary', icon: 'locations' },
  { label: "Today's Bookings", value: '128', tone: 'primary', icon: 'bookings' },
  { label: 'Current Occupancy', value: '78%', tone: 'warning', icon: 'occupancy' },
  { label: 'Available Desks', value: '64', tone: 'success', icon: 'desks' },
]

export const peakHours = [
  { label: '8a', value: 35 },
  { label: '9a', value: 55 },
  { label: '10a', value: 68 },
  { label: '11a', value: 82 },
  { label: '12p', value: 90 },
  { label: '1p', value: 85 },
  { label: '2p', value: 78 },
  { label: '3p', value: 88 },
  { label: '4p', value: 80 },
  { label: '5p', value: 65 },
  { label: '6p', value: 45 },
]

export const locations = [
  {
    name: 'Bengaluru Central',
    city: 'Bengaluru, KA',
    bookings: 48,
    occupied: 98,
    total: 120,
    occupancy: 82,
    status: 'Near Capacity',
    tone: 'warning',
  },
  {
    name: 'Koramangala',
    city: 'Bengaluru, KA',
    bookings: 36,
    occupied: 64,
    total: 80,
    occupancy: 80,
    status: 'Available',
    tone: 'success',
  },
  {
    name: 'Indiranagar',
    city: 'Bengaluru, KA',
    bookings: 27,
    occupied: 54,
    total: 60,
    occupancy: 90,
    status: 'High Demand',
    tone: 'critical',
  },
  {
    name: 'Whitefield',
    city: 'Bengaluru, KA',
    bookings: 17,
    occupied: 22,
    total: 45,
    occupancy: 49,
    status: 'Available',
    tone: 'success',
  },
]

export const alerts = [
  {
    title: 'Bengaluru Central nearing capacity',
    description: '82% occupancy - expected full by 11:30 AM',
    icon: 'warning',
    tone: 'warning',
  },
  {
    title: 'High demand: 11 AM - 1 PM',
    description: 'All locations above 80% occupancy',
    icon: 'demand',
    tone: 'critical',
  },
  {
    title: 'Booking conflict detected',
    description: 'Board Room - Bengaluru Central - 10-11:30 AM',
    icon: 'conflict',
    tone: 'primary',
  },
]
