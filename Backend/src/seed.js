const bcrypt = require('bcryptjs');
const mongoose = require('mongoose');
const { connectDatabase } = require('./config/database');
const Branch = require('./models/Branch');
const Booking = require('./models/Booking');
const Space = require('./models/Space');
const User = require('./models/User');
const WalkIn = require('./models/WalkIn');

async function seed() {
  await connectDatabase();

  await Promise.all([
    Booking.deleteMany({}),
    WalkIn.deleteMany({})
  ]);

  const passwordHash = await bcrypt.hash('Password123!', 12);
  const branchSeeds = [
    ['Bengaluru Central', 'Bengaluru', 'MG Road, Bengaluru'],
    ['Koramangala Hub', 'Koramangala', '5th Block, Koramangala'],
    ['Indiranagar Studio', 'Indiranagar', '100 Feet Road, Indiranagar'],
    ['Whitefield Works', 'Whitefield', 'ITPL Main Road, Whitefield']
  ];
  const branches = [];

  for (const [name, city, address] of branchSeeds) {
    const branch = await Branch.findOneAndUpdate(
      { name },
      {
        name,
        city,
        address,
        timezone: 'Asia/Calcutta',
        isActive: true
      },
      { upsert: true, new: true }
    );
    branches.push(branch);
  }

  const admin = await User.findOneAndUpdate(
    { email: 'admin@example.com' },
    {
      name: 'Central Admin',
      email: 'admin@example.com',
      passwordHash,
      role: 'central_admin',
      isActive: true
    },
    { upsert: true, new: true }
  );

  await User.findOneAndUpdate(
    { email: 'manager@example.com' },
    {
      name: 'Branch Manager',
      email: 'manager@example.com',
      passwordHash,
      role: 'branch_manager',
      branch: branches[0]._id,
      isActive: true
    },
    { upsert: true, new: true }
  );

  const member = await User.findOneAndUpdate(
    { email: 'member@example.com' },
    {
      name: 'Member User',
      email: 'member@example.com',
      passwordHash,
      role: 'member',
      isActive: true
    },
    { upsert: true, new: true }
  );

  const allSpaces = [];
  for (const branch of branches) {
    const spaceSeeds = [
      ['Hot Desk 1', 'desk', 1],
      ['Hot Desk 2', 'desk', 1],
      ['Dedicated Desk 1', 'desk', 1],
      ['Meeting Room A', 'meeting_room', 8],
      ['Meeting Room B', 'meeting_room', 10]
    ];

    for (const [name, type, capacity] of spaceSeeds) {
      const space = await Space.findOneAndUpdate(
        { branch: branch._id, name },
        {
          branch: branch._id,
          name,
          type,
          capacity,
          amenities: type === 'desk' ? ['Power outlet', 'Wi-Fi'] : ['Display', 'Whiteboard'],
          isActive: true
        },
        { upsert: true, new: true }
      );
      allSpaces.push(space);
    }
  }

  const today = new Date();
  const slot = (daysFromNow, startHour, durationHours = 2) => {
    const startTime = new Date(today.getFullYear(), today.getMonth(), today.getDate() + daysFromNow, startHour);
    const endTime = new Date(startTime.getTime() + durationHours * 60 * 60 * 1000);
    return { startTime, endTime };
  };

  for (let index = 0; index < allSpaces.length; index += 3) {
    const space = allSpaces[index];
    await Booking.create({
      member: member._id,
      branch: space.branch,
      space: space._id,
      ...slot(index % 2, 9 + (index % 5), 2),
      status: 'confirmed',
      notes: 'Seeded demo booking'
    });
  }

  for (const [index, branch] of branches.entries()) {
    await WalkIn.create({
      branch: branch._id,
      recordedBy: admin._id,
      count: 8 + index * 4,
      observedAt: new Date(),
      notes: 'Seeded demo walk-in count'
    });
  }

  console.log('Seed complete');
  console.log('Demo password for all seeded users: Password123!');
  await mongoose.connection.close();
}

seed().catch(async (error) => {
  console.error(error);
  await mongoose.connection.close();
  process.exit(1);
});
