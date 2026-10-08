const mongoose = require('mongoose');
const app = require('./app');
const { connectDatabase } = require('./config/database');
const { env } = require('./config/env');

async function startServer() {
  await connectDatabase();

  app.listen(env.PORT, () => {
    console.log(`API listening on port ${env.PORT}`);
  });
}

startServer().catch((error) => {
  console.error('Failed to start server', error);
  mongoose.connection.close();
  process.exit(1);
});
