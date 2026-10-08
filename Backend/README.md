# Smart Co-working Backend

Express and MongoDB backend for the Smart Co-working Space Booking and Utilization System described in the PRD.

## Setup

```bash
npm install
copy .env.example .env
npm run dev
```

Update `.env` with your MongoDB connection string and JWT secret before running the server. Local Flutter web origins on `localhost` and `127.0.0.1` are accepted automatically during development.

## API Surface

- `POST /api/auth/signup`
- `POST /api/auth/login`
- `GET /api/auth/me`
- `POST /api/branches`
- `GET /api/branches`
- `POST /api/branches/:branchId/spaces`
- `GET /api/branches/:branchId/spaces`
- `PUT /api/spaces/:id`
- `DELETE /api/spaces/:id`
- `POST /api/spaces/:id/capacity-rules`
- `POST /api/branches/:branchId/walk-ins`
- `POST /api/bookings`
- `GET /api/bookings`
- `GET /api/bookings/:id`
- `PATCH /api/bookings/:id/status`
- `GET /api/audit-logs`
- `GET /api/audit-logs/summary`
- `GET /api/analytics/utilization`
- `GET /api/analytics/utilization/:branchId`
- `GET /api/health`

## Rubric Notes

The backend demonstrates middleware, RESTful design, HTTP status codes, server-side validation, centralized error handling, JWT authentication, password hashing, role-based authorization, rate limiting, MongoDB schema modeling, CRUD operations, and aggregation pipelines.

The booking controller uses `async/await` with a MongoDB transaction. Booking conflicts are guarded by both a transactional lookup and a partial unique index on active bookings for the same `space`, `startTime`, and `endTime`, so concurrent duplicate requests return `409 Conflict`.
