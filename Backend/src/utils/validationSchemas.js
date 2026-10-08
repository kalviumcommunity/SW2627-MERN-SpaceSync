const { z } = require('zod');

const objectId = z.string().regex(/^[0-9a-fA-F]{24}$/, 'Expected a MongoDB ObjectId');
const isoDate = z.string().datetime({ offset: true }).or(z.string().datetime());

const authSchemas = {
  signup: z.object({
    body: z.object({
      name: z.string().trim().min(2),
      email: z.string().trim().email(),
      password: z.string().min(8),
      role: z.enum(['member', 'branch_manager', 'central_admin']).optional(),
      branch: objectId.optional()
    })
  }),
  login: z.object({
    body: z.object({
      email: z.string().trim().email(),
      password: z.string().min(1)
    })
  })
};

const branchSchemas = {
  create: z.object({
    body: z.object({
      name: z.string().trim().min(2),
      city: z.string().trim().min(2),
      address: z.string().trim().min(5),
      timezone: z.string().trim().optional()
    })
  })
};

const spaceBody = z.object({
  name: z.string().trim().min(2).optional(),
  type: z.enum(['desk', 'meeting_room']).optional(),
  capacity: z.number().int().min(1).optional(),
  amenities: z.array(z.string().trim()).optional()
});

const capacityRule = z.object({
  name: z.string().trim().min(2),
  daysOfWeek: z.array(z.number().int().min(0).max(6)).min(1),
  startHour: z.number().int().min(0).max(23),
  endHour: z.number().int().min(1).max(24),
  capacityOverride: z.number().int().min(0)
}).refine((value) => value.endHour > value.startHour, {
  message: 'endHour must be greater than startHour',
  path: ['endHour']
});

const spaceSchemas = {
  create: z.object({
    params: z.object({ branchId: objectId }),
    body: spaceBody.extend({
      name: z.string().trim().min(2),
      type: z.enum(['desk', 'meeting_room']),
      capacity: z.number().int().min(1).default(1)
    })
  }),
  list: z.object({
    params: z.object({ branchId: objectId }),
    query: z.object({
      type: z.enum(['desk', 'meeting_room']).optional(),
      startTime: isoDate.optional(),
      endTime: isoDate.optional()
    })
  }),
  update: z.object({
    params: z.object({ id: objectId }),
    body: spaceBody.refine((value) => Object.keys(value).length > 0, {
      message: 'At least one field is required'
    })
  }),
  idParam: z.object({
    params: z.object({ id: objectId })
  }),
  capacityRule: z.object({
    params: z.object({ id: objectId }),
    body: capacityRule
  })
};

const bookingSchemas = {
  create: z.object({
    body: z.object({
      space: objectId,
      startTime: isoDate,
      endTime: isoDate,
      notes: z.string().trim().max(500).optional()
    })
  }),
  idParam: z.object({
    params: z.object({ id: objectId })
  }),
  status: z.object({
    params: z.object({ id: objectId }),
    body: z.object({
      status: z.enum(['confirmed', 'cancelled', 'completed'])
    })
  })
};

const occupancySchemas = {
  createWalkIn: z.object({
    params: z.object({ branchId: objectId }),
    body: z.object({
      count: z.number().int().min(1),
      observedAt: isoDate.optional(),
      notes: z.string().trim().max(500).optional()
    })
  })
};

const analyticsSchemas = {
  branchParam: z.object({
    params: z.object({ branchId: objectId }),
    query: z.object({
      from: isoDate.optional(),
      to: isoDate.optional()
    })
  }),
  range: z.object({
    query: z.object({
      from: isoDate.optional(),
      to: isoDate.optional()
    })
  })
};

module.exports = {
  authSchemas,
  branchSchemas,
  spaceSchemas,
  bookingSchemas,
  occupancySchemas,
  analyticsSchemas
};
