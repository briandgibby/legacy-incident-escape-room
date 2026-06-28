// @ts-check

import { couponRules, incidentCart } from "./fixtures.js";
import { discountFractionForCoupon } from "./discounts.js";

/**
 * @typedef {object} CartItem
 * @property {string} sku
 * @property {number} quantity
 * @property {number} unitPriceCents
 */

/**
 * @typedef {object} CouponRule
 * @property {string} code
 * @property {string} channel
 * @property {string} starts_at
 * @property {string} expires_at
 * @property {number | null | undefined} [discount_percent]
 * @property {number | null | undefined} [discount_basis_points]
 */

/**
 * Quote a checkout cart using the same simplified flow as the production endpoint.
 *
 * @param {object} input
 * @param {CartItem[]} [input.items]
 * @param {string} input.couponCode
 * @param {Date} [input.now]
 * @param {CouponRule[]} [input.rules]
 */
export function quoteCheckout({
  items = incidentCart,
  couponCode,
  now = new Date(),
  rules = couponRules,
}) {
  const subtotalCents = items.reduce(
    (total, item) => total + item.quantity * item.unitPriceCents,
    0,
  );

  const normalizedCode = couponCode.trim().toUpperCase();
  const coupon = rules.find(
    (rule) =>
      rule.code === normalizedCode &&
      rule.channel === "web" &&
      new Date(rule.starts_at) <= now &&
      now < new Date(rule.expires_at),
  );

  const discountFraction = coupon ? discountFractionForCoupon(coupon) : 0;
  const discountCents = Math.round(subtotalCents * discountFraction);

  return {
    couponFound: Boolean(coupon),
    couponCode: normalizedCode,
    subtotalCents,
    discountCents,
    totalCents: subtotalCents - discountCents,
  };
}
