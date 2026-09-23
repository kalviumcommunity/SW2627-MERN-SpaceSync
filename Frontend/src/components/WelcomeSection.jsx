import { FiAlertTriangle } from 'react-icons/fi'

function WelcomeSection() {
  return (
    <section className="welcome-section" aria-labelledby="welcome-title">
      <p className="eyebrow eyebrow-light">Tuesday, 22 September</p>
      <h1 id="welcome-title">Good morning, Admin <span aria-hidden="true">👋</span></h1>
      <p className="welcome-subtitle">Workspace utilization overview</p>
      <div className="conflict-pill"><FiAlertTriangle aria-hidden="true" /> <span>2 conflicts need attention</span></div>
    </section>
  )
}

export default WelcomeSection
