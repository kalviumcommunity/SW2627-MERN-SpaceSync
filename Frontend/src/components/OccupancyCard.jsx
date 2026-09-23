import { FiUsers } from 'react-icons/fi'

function OccupancyCard() {
  return (
    <article className="occupancy-card">
      <div className="occupancy-main">
        <div className="donut" aria-label="78 percent occupancy">
          <div className="donut-center"><strong>78%</strong><span>Occupied</span></div>
        </div>
        <div className="occupancy-breakdown">
          <div className="occupancy-metric"><div><span>Occupied</span><strong>238</strong></div><div className="mini-progress"><span className="fill-primary" style={{ width: '78%' }} /></div></div>
          <div className="occupancy-metric"><div><span>Available</span><strong>67</strong></div><div className="mini-progress"><span className="fill-success" style={{ width: '22%' }} /></div></div>
        </div>
      </div>
      <div className="utilization-grid">
        <div className="utilization-box"><span><FiUsers aria-hidden="true" /> Desk Utilization</span><strong>80%</strong></div>
        <div className="utilization-box"><span><FiUsers aria-hidden="true" /> Room Utilization</span><strong>71%</strong></div>
      </div>
    </article>
  )
}

export default OccupancyCard
