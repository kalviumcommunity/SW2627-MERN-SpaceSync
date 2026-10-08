const express = require('express');
const { signup, login, me } = require('../controllers/authController');
const { requireAuth } = require('../middleware/auth');
const { loginRateLimiter } = require('../middleware/rateLimiter');
const { validate } = require('../middleware/validate');
const { authSchemas } = require('../utils/validationSchemas');

const router = express.Router();

router.post('/signup', validate(authSchemas.signup), signup);
router.post('/login', loginRateLimiter, validate(authSchemas.login), login);
router.get('/me', requireAuth, me);

module.exports = router;
