import { FiActivity, FiBriefcase, FiMapPin, FiMonitor } from 'react-icons/fi'

const icons = {
  locations: FiMapPin,
  bookings: FiBriefcase,
  occupancy: FiActivity,
  desks: FiMonitor,
}

function StatCard({ label, value, tone, icon }) {
  const Icon = icons[icon]

  return (
    <article className={`stat-card stat-card-${tone}`}>
      <div className="stat-icon"><Icon aria-hidden="true" /></div>
      <strong>{value}</strong>
      <span>{label}</span>
    </article>
  )
}

export default StatCard
