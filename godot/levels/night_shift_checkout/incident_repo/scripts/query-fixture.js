import { couponRules } from "../src/fixtures.js";

console.log("Read-only diagnostic query");
console.log("select code, channel, discount_percent, discount_basis_points, starts_at, expires_at");
console.log("from marketing.coupon_rules");
console.log("where code in ('LATE-NIGHT-15', 'WELCOME10');");
console.table(
  couponRules
    .filter((rule) => ["LATE-NIGHT-15", "WELCOME10"].includes(rule.code))
    .map((rule) => ({
      code: rule.code,
      channel: rule.channel,
      discount_percent: rule.discount_percent,
      discount_basis_points: rule.discount_basis_points,
      starts_at: rule.starts_at,
      expires_at: rule.expires_at,
    })),
);
