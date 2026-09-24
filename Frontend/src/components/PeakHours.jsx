function getBarTone(value) {
  if (value >= 85) return 'peak'
  if (value >= 75) return 'high'
  return 'normal'
}

function PeakHours({ data }) {
  return (
    <article className="peak-card">
      <div className="chart" aria-label="Today's workspace demand by hour">
        {data.map((hour) => (
          <div className="bar-column" key={hour.label}>
            <div className={`bar bar-${getBarTone(hour.value)}`} style={{ height: `${hour.value}%` }} title={`${hour.label}: ${hour.value}%`} />
            <span>{hour.label}</span>
          </div>
        ))}
      </div>
      <div className="chart-legend" aria-label="Demand level legend">
        <span><i className="legend-dot dot-normal" /> Normal</span>
        <span><i className="legend-dot dot-high" /> High</span>
        <span><i className="legend-dot dot-peak" /> Peak</span>
      </div>
    </article>
  )
}

export default PeakHours
