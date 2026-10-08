const { ZodError } = require('zod');

function errorHandler(error, req, res, next) {
  if (error instanceof ZodError) {
    return res.status(422).json({
      message: 'Request validation failed',
      errors: error.errors
    });
  }

  if (error.name === 'CastError') {
    return res.status(400).json({ message: 'Invalid identifier format' });
  }

  if (error.code === 11000) {
    return res.status(409).json({ message: 'Resource already exists', details: error.keyValue });
  }

  const statusCode = error.statusCode || 500;
  const message = statusCode === 500 ? 'Internal server error' : error.message;

  if (statusCode === 500) {
    console.error(error);
  }

  return res.status(statusCode).json({
    message,
    details: error.details
  });
}

module.exports = { errorHandler };
