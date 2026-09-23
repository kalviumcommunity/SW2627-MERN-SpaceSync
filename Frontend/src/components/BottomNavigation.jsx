import { FiBarChart2, FiCalendar, FiHome, FiLayers, FiUser } from 'react-icons/fi'

const navigation = [
  { label: 'Home', icon: FiHome, active: true },
  { label: 'Bookings', icon: FiCalendar },
  { label: 'Spaces', icon: FiLayers },
  { label: 'Analytics', icon: FiBarChart2 },
  { label: 'Profile', icon: FiUser },
]

function BottomNavigation() {
  return (
    <nav className="bottom-navigation" aria-label="Main navigation">
      {navigation.map(({ label, icon: Icon, active }) => (
        <button key={label} type="button" className={`nav-item ${active ? 'nav-item-active' : ''}`} aria-current={active ? 'page' : undefined}>
          <Icon aria-hidden="true" /><span>{label}</span>
        </button>
      ))}
    </nav>
  )
}

export default BottomNavigation
