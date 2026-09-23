function PhoneMockup({ children }) {
  return (
    <main className="presentation-stage">
      <div className="phone-frame" aria-label="CoWorkHub mobile application preview">
        <div className="phone-island" aria-hidden="true" />
        <div className="phone-screen">{children}</div>
      </div>
    </main>
  )
}

export default PhoneMockup
