import { FiAlertTriangle, FiZap, FiAlertCircle, FiArrowUpRight } from 'react-icons/fi'

const icons = { warning: FiAlertTriangle, demand: FiZap, conflict: FiAlertCircle }

function AlertCard({ alert }) {
  const Icon = icons[alert.icon]

  return (
    <article className={`alert-card alert-${alert.tone}`}>
      <span className="alert-icon"><Icon aria-hidden="true" /></span>
      <div className="alert-copy"><h3>{alert.title}</h3><p>{alert.description}</p></div>
      <button type="button" className="resolve-button" aria-label={`Resolve ${alert.title}`}>Resolve <FiArrowUpRight aria-hidden="true" /></button>
    </article>
  )
}

export default AlertCard
