const mongoose = require('mongoose');

const capacityRuleSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },
    daysOfWeek: [
      {
        type: Number,
        min: 0,
        max: 6
      }
    ],
    startHour: {
      type: Number,
      required: true,
      min: 0,
      max: 23
    },
    endHour: {
      type: Number,
      required: true,
      min: 1,
      max: 24
    },
    capacityOverride: {
      type: Number,
      required: true,
      min: 0
    }
  },
  { _id: true }
);

const spaceSchema = new mongoose.Schema(
  {
    branch: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Branch',
      required: true,
      index: true
    },
    name: {
      type: String,
      required: true,
      trim: true
    },
    type: {
      type: String,
      enum: ['desk', 'meeting_room'],
      required: true
    },
    capacity: {
      type: Number,
      required: true,
      min: 1,
      default: 1
    },
    amenities: [
      {
        type: String,
        trim: true
      }
    ],
    capacityRules: [capacityRuleSchema],
    isActive: {
      type: Boolean,
      default: true
    },
    bookingLockVersion: {
      type: Number,
      default: 0,
      select: false
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model('Space', spaceSchema);
