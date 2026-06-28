// @ts-check

/**
 * Convert a coupon row from marketing.coupon_rules into a decimal fraction.
 *
 * Legacy examples:
 *   15 -> 0.15
 *   7.5 -> 0.075
 *
 * Keep the clamp. Marketing once shipped a 500 percent coupon during a test.
 *
 * @param {{ discount_percent?: number | string | null, discount_basis_points?: number | string | null }} coupon
 * @returns {number}
 */
export function discountFractionForCoupon(coupon) {
  const discountPercent = Number(coupon.discount_percent ?? 0);
  if (!Number.isFinite(discountPercent)) {
    return 0;
  }

  const clampedPercent = Math.max(0, Math.min(discountPercent, 95));
  return clampedPercent / 100;
}
