import assert from "node:assert/strict";
import test from "node:test";

import { quoteCheckout } from "../src/checkout.js";
import { INCIDENT_TIME, incidentCart } from "../src/fixtures.js";

test("LATE-NIGHT-15 applies the migrated basis-points discount", () => {
  const quote = quoteCheckout({
    items: incidentCart,
    couponCode: "late-night-15",
    now: INCIDENT_TIME,
  });

  assert.equal(quote.couponFound, true);
  assert.equal(quote.subtotalCents, 10000);
  assert.equal(quote.discountCents, 1500);
  assert.equal(quote.totalCents, 8500);
});

test("legacy percent coupons keep working during rollback window", () => {
  const quote = quoteCheckout({
    items: incidentCart,
    couponCode: "WELCOME10",
    now: INCIDENT_TIME,
  });

  assert.equal(quote.couponFound, true);
  assert.equal(quote.discountCents, 1000);
  assert.equal(quote.totalCents, 9000);
});

test("mobile-only coupons do not leak into web checkout", () => {
  const quote = quoteCheckout({
    items: incidentCart,
    couponCode: "MOBILEONLY",
    now: INCIDENT_TIME,
  });

  assert.equal(quote.couponFound, false);
  assert.equal(quote.discountCents, 0);
  assert.equal(quote.totalCents, 10000);
});
