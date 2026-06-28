import { quoteCheckout } from "../src/checkout.js";
import { INCIDENT_TIME, incidentCart } from "../src/fixtures.js";

const quote = quoteCheckout({
  items: incidentCart,
  couponCode: "LATE-NIGHT-15",
  now: INCIDENT_TIME,
});

console.log("POST /api/checkout/quote");
console.log("coupon_code=LATE-NIGHT-15 channel=web at=2026-06-28T01:21:00Z");
console.log(`subtotal_cents=${quote.subtotalCents}`);
console.log(`discount_cents=${quote.discountCents}`);
console.log(`total_cents=${quote.totalCents}`);

if (!quote.couponFound) {
  console.error("ALERT coupon was not selected. Check channel/date validation.");
  process.exit(1);
}

if (quote.discountCents !== 1500) {
  console.error("ALERT coupon selected but discount amount does not match marketing.coupon_rules.");
  process.exit(1);
}

console.log("OK replay matches production expectation.");
