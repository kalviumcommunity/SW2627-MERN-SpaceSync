const mongoose = require('mongoose');
const { asyncHandler } = require('../utils/asyncHandler');

const health = asyncHandler(async (req, res) => {
  res.json({
    status: 'ok',
    database: mongoose.connection.readyState === 1 ? 'connected' : 'disconnected',
    timestamp: new Date().toISOString()
  });
});

module.exports = { health };
