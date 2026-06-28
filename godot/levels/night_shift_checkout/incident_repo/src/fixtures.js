// @ts-check

export const INCIDENT_TIME = new Date("2026-06-28T01:21:00.000Z");

export const incidentCart = [
  { sku: "desk-lamp-refurb", quantity: 1, unitPriceCents: 6500 },
  { sku: "usb-c-dock-grade-b", quantity: 1, unitPriceCents: 3500 },
];

export const couponRules = [
  {
    code: "LATE-NIGHT-15",
    channel: "web",
    starts_at: "2026-06-27T22:00:00.000Z",
    expires_at: "2026-06-28T06:00:00.000Z",
    discount_percent: null,
    discount_basis_points: 1500,
  },
  {
    code: "WELCOME10",
    channel: "web",
    starts_at: "2025-01-01T00:00:00.000Z",
    expires_at: "2027-01-01T00:00:00.000Z",
    discount_percent: 10,
    discount_basis_points: null,
  },
  {
    code: "MOBILEONLY",
    channel: "mobile",
    starts_at: "2026-06-27T00:00:00.000Z",
    expires_at: "2026-06-29T00:00:00.000Z",
    discount_percent: null,
    discount_basis_points: 2000,
  },
];
