require('dotenv').config();

const env = {
  PORT: Number(process.env.PORT || 5000),
  MONGO_URI: process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/smart_coworking',
  JWT_SECRET: process.env.JWT_SECRET || 'development-secret-change-me',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '1d',
  RATE_LIMIT_WINDOW_MS: Number(process.env.RATE_LIMIT_WINDOW_MS || 15 * 60 * 1000),
  RATE_LIMIT_MAX: Number(process.env.RATE_LIMIT_MAX || 10),
  CORS_ORIGIN: process.env.CORS_ORIGIN || 'http://localhost:5173'
};

module.exports = { env };
