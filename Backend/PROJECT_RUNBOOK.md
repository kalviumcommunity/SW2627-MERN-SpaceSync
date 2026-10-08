# SpaceSync Project Runbook

This project has two parts:

- Backend: Express, MongoDB, JWT API in the project root.
- Frontend: Flutter app in `front/SW2627-MERN-SpaceSync/Frontend`.

## Prerequisites

Install these before running the project:

- Node.js 18 or newer
- MongoDB Community Server, or a MongoDB Atlas connection string
- Flutter SDK with Chrome/web support enabled

Check tools:

```bash
node --version
npm --version
flutter --version
```

## Backend Setup

From the project root:

```bash
npm install
copy .env.example .env
```

Open `.env` and set:

```env
PORT=5000
MONGO_URI=mongodb://127.0.0.1:27017/smart_coworking
JWT_SECRET=replace-with-a-long-random-secret
JWT_EXPIRES_IN=1d
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX=10
CORS_ORIGIN=http://localhost:5173,http://127.0.0.1:5173
```

Start MongoDB, then seed demo data:

```bash
npm run seed
```

Run the backend:

```bash
npm run dev
```

Health check:

```bash
curl http://localhost:5000/api/health
```

Demo accounts created by `npm run seed`:

- `admin@example.com` / `Password123!`
- `manager@example.com` / `Password123!`
- `member@example.com` / `Password123!`

The Flutter frontend automatically logs in with the admin demo account so the dashboard and analytics tabs can load protected API data.

## Frontend Setup

Go to the Flutter app:

```bash
cd front\SW2627-MERN-SpaceSync\Frontend
flutter pub get
```

Run in Chrome:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000/api
```

If you run the backend on another port, update the `API_BASE_URL` value.

## Demo Flow

Use this sequence when showing people the project:

1. Start MongoDB.
2. In the project root, run `npm run seed`.
3. In the project root, run `npm run dev`.
4. In the Flutter folder, run `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000/api`.
5. Open the Home tab and point out that locations, bookings, occupancy, and alerts are coming from the backend.
6. Open Spaces, choose a location, open a free space, and click Book.
7. Open Bookings and show the new booking from MongoDB.
8. Open Analytics and show utilization, walk-ins, active spaces, and expansion candidates.

## How To Work On It

Backend source lives in `src`:

- `src/models`: MongoDB schemas.
- `src/controllers`: request handling and business logic.
- `src/routes`: REST endpoint wiring.
- `src/middleware`: auth, role checks, validation, rate limiting, and errors.
- `src/seed.js`: repeatable demo data.

Frontend source lives in `front/SW2627-MERN-SpaceSync/Frontend/lib`:

- `services/api_client.dart`: backend API calls and demo session login.
- `screens`: Home, Bookings, Spaces, Analytics, and Profile UI.
- `models`: frontend view models mapped from API JSON.
- `widgets`: reusable UI cards, navigation, and headers.

Recommended workflow:

```bash
# terminal 1, project root
npm run dev

# terminal 2, Flutter folder
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000/api
```

After backend changes, run:

```bash
npm run build
npm audit
```

After frontend changes, run:

```bash
flutter analyze
flutter test
```

## Useful API Endpoints

- `GET /api/health`
- `POST /api/auth/login`
- `GET /api/branches`
- `GET /api/branches/:branchId/spaces`
- `POST /api/bookings`
- `GET /api/bookings`
- `GET /api/analytics/utilization`

## Troubleshooting

If the frontend shows a backend error:

- Make sure `npm run dev` is still running.
- Make sure MongoDB is running.
- Run `npm run seed` again.
- Confirm the frontend was started with `--dart-define=API_BASE_URL=http://localhost:5000/api`.

If Flutter says `http` is missing:

```bash
flutter pub get
```

If the browser blocks API calls:

- Use `localhost` or `127.0.0.1` for local development.
- Keep backend `PORT=5000`.
- Restart the backend after changing `.env`.

If demo booking fails because the slot is already booked, pick another free space or run `npm run seed` to reset demo bookings.
