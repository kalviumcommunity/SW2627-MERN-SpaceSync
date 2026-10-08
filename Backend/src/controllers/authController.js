const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { env } = require('../config/env');
const { AppError } = require('../utils/AppError');
const { asyncHandler } = require('../utils/asyncHandler');

function signToken(user) {
  return jwt.sign({ sub: user._id, role: user.role }, env.JWT_SECRET, {
    expiresIn: env.JWT_EXPIRES_IN
  });
}

function serializeUser(user) {
  return {
    id: user._id,
    name: user.name,
    email: user.email,
    role: user.role,
    branch: user.branch
  };
}

const signup = asyncHandler(async (req, res) => {
  const existing = await User.findOne({ email: req.body.email });
  if (existing) {
    throw new AppError(409, 'Email is already registered');
  }

  const passwordHash = await bcrypt.hash(req.body.password, 12);
  const user = await User.create({
    name: req.body.name,
    email: req.body.email,
    passwordHash,
    role: req.body.role || 'member',
    branch: req.body.branch
  });

  res.status(201).json({
    token: signToken(user),
    user: serializeUser(user)
  });
});

const login = asyncHandler(async (req, res) => {
  const user = await User.findOne({ email: req.body.email });
  if (!user || !user.isActive) {
    throw new AppError(401, 'Invalid email or password');
  }

  const passwordMatches = await bcrypt.compare(req.body.password, user.passwordHash);
  if (!passwordMatches) {
    throw new AppError(401, 'Invalid email or password');
  }

  res.json({
    token: signToken(user),
    user: serializeUser(user)
  });
});

const me = asyncHandler(async (req, res) => {
  res.json({ user: serializeUser(req.user) });
});

module.exports = { signup, login, me };
