# Night Shift Checkout Incident Repo

This is the real code puzzle used by the Godot level.

## Commands

```powershell
npm test
npm run simulate
npm run query:coupon
```

The initial snapshot fails by design. The player should diagnose the mismatch between the coupon schema and `src/discounts.js`, then make the smallest fix that restores `LATE-NIGHT-15` while preserving legacy percent coupons.

## Production story

Marketing migrated `marketing.coupon_rules` from `discount_percent` to `discount_basis_points`. Checkout still accepts the coupon code, but the quoted discount is zero because the value reader only understands the old field.
