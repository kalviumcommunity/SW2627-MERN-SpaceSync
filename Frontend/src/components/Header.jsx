import { FiBell, FiGrid } from 'react-icons/fi'

function Header() {
  return (
    <header className="app-header">
      <div className="brand-lockup">
        <span className="brand-mark" aria-hidden="true"><FiGrid /></span>
        <span>CoWorkHub</span>
      </div>
      <div className="header-actions">
        <button className="icon-button notification-button" type="button" aria-label="View notifications">
          <FiBell />
          <span className="notification-badge">2</span>
        </button>
        <button className="avatar" type="button" aria-label="Open Admin profile">A</button>
      </div>
    </header>
  )
}

export default Header
