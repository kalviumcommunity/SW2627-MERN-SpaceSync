import { FiPlus } from 'react-icons/fi'
import Header from '../components/Header'
import WelcomeSection from '../components/WelcomeSection'
import StatCard from '../components/StatCard'
import OccupancyCard from '../components/OccupancyCard'
import PeakHours from '../components/PeakHours'
import LocationCard from '../components/LocationCard'
import AlertCard from '../components/AlertCard'
import BottomNavigation from '../components/BottomNavigation'
import { alerts, locations, peakHours, stats } from '../data/mockData'

function SectionHeading({ children }) {
  return <h2 className="section-heading">{children}</h2>
}

function Home() {
  const handleNewBooking = () => console.info('New booking flow coming soon')

  return (
    <div className="app-shell">
      <Header />
      <WelcomeSection />
      <main className="dashboard-content">
        <section className="stats-grid" aria-label="Workspace summary">
          {stats.map((stat) => <StatCard key={stat.label} {...stat} />)}
        </section>

        <section className="dashboard-section" aria-labelledby="live-occupancy-heading">
          <SectionHeading>LIVE OCCUPANCY</SectionHeading>
          <OccupancyCard />
        </section>

        <section className="dashboard-section" aria-labelledby="peak-hours-heading">
          <SectionHeading>PEAK HOURS <span aria-hidden="true">·</span> TODAY</SectionHeading>
          <PeakHours data={peakHours} />
        </section>

        <section className="dashboard-section" aria-labelledby="locations-heading">
          <SectionHeading>LOCATION OVERVIEW</SectionHeading>
          <div className="location-list">{locations.map((location) => <LocationCard key={location.name} location={location} />)}</div>
        </section>

        <section className="dashboard-section alerts-section" aria-labelledby="alerts-heading">
          <SectionHeading>ACTIVE ALERTS</SectionHeading>
          <div className="alert-list">{alerts.map((alert) => <AlertCard key={alert.title} alert={alert} />)}</div>
        </section>

        <button className="new-booking-button" type="button" onClick={handleNewBooking}><FiPlus aria-hidden="true" /> New Booking</button>
      </main>
      <BottomNavigation />
    </div>
  )
}

export default Home
