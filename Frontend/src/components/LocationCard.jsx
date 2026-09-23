function LocationCard({ location }) {
  return (
    <article className="location-card">
      <div className="location-card-header">
        <div><h3>{location.name}</h3><p>{location.city} <span aria-hidden="true">·</span> {location.bookings} bookings today</p></div>
        <span className={`status-badge status-${location.tone}`}>{location.status}</span>
      </div>
      <div className="seat-row"><span>{location.occupied} / {location.total} seats</span><strong>{location.occupancy}%</strong></div>
      <div className="location-progress"><span className={`fill-${location.tone}`} style={{ width: `${location.occupancy}%` }} /></div>
    </article>
  )
}

export default LocationCard
